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

-- Per-section global settings registry. These keys mirror the per-spec
-- "Use Global" flags and the copy menu sections that operate on them.
local globalSettingDefinitions = {
	bar             = { checkboxSuffix = "barDimensions",   tabKey = "resourceBar",     sectionLabel = L["CopyMenuSection_bar"],             paths = { {"bar"} } },
	comboPoints     = { checkboxSuffix = "comboPoints",     tabKey = "comboPointsBar",  sectionLabel = L["CopyMenuSection_comboPoints"],     paths = { {"comboPoints"} } },
	healthBar       = { checkboxSuffix = "healthBar",       tabKey = "healthBar",       sectionLabel = L["CopyMenuSection_healthBar"],       paths = { {"healthBar"} } },
	healthBarColors = { checkboxSuffix = "healthBarColors", tabKey = "healthBar",       sectionLabel = L["CopyMenuSection_healthBarColors"], paths = { {"colors", "healthBar"} } },
	textures        = { checkboxSuffix = "textures",        tabKey = "barTextures",     sectionLabel = L["CopyMenuSection_textures"],        paths = { {"textures"} } },
	displayBar      = { checkboxSuffix = "displayBar",      tabKey = "barVisibility",   sectionLabel = L["CopyMenuSection_displayBar"],      paths = { {"displayBar"} }, shapeSensitive = true },
	thresholdIcons  = { checkboxSuffix = "thresholdIcons",  tabKey = "thresholds",      sectionLabel = L["CopyMenuSection_thresholdIcons"],  paths = { {"thresholds", "properties"}, {"thresholds", "icons"} }, shapeSensitive = true },
	thresholdColors = { checkboxSuffix = "thresholdColors", tabKey = "thresholds",      sectionLabel = L["CopyMenuSection_thresholdColors"], paths = { {"colors", "threshold"} }, shapeSensitive = true },
	displayText     = { checkboxSuffix = "displayText",     tabKey = "fontText",        sectionLabel = L["CopyMenuSection_displayText"],     paths = { {"displayText", "default"} } },
	textColors      = { checkboxSuffix = "textColors",      tabKey = "fontText",        sectionLabel = L["CopyMenuSection_textColors"],      paths = { {"colors", "text"} } },
	precision       = { checkboxSuffix = "precision",       tabKey = "fontText",        sectionLabel = L["CopyMenuSection_precision"],       paths = { {"precision"} } },
	globalBarText   = { checkboxSuffix = "globalBarText",   tabKey = "barText",         sectionLabel = L["CopyMenuSection_globalBarText"],   paths = { {"displayText", "barText"} }, shapeSensitive = true },
}

---Sets a checkbox to tristate visual mode
---@param checkbox CheckButton # The checkbox to update
---@param state boolean|nil # true = checked, false = unchecked, nil = mixed/desaturated
local function SetCheckboxTriState(checkbox, state)
	if not checkbox then return end
	local check = checkbox:GetCheckedTexture()
	if state == true then
		checkbox:SetChecked(true)
		if check then
			check:SetDesaturated(false)
			check:SetVertexColor(1, 1, 1, 1)
		end
	elseif state == nil then
		-- Mixed/indeterminate state - show a desaturated checkmark
		checkbox:SetChecked(true)
		if check then
			check:SetDesaturated(true)
			check:SetVertexColor(0.8, 0.8, 0.8, 1)
		end
	else
		checkbox:SetChecked(false)
		if check then
			check:SetDesaturated(false)
			check:SetVertexColor(1, 1, 1, 1)
		end
	end
end

---Returns true if the panel being edited belongs to (or affects) the currently active spec.
---Used to guard live-preview callbacks so editing a non-active spec's settings doesn't
---trigger unnecessary or incorrect bar updates.
---@param classId integer? # Class ID of the panel being edited (nil for global panel)
---@param specId integer? # Spec ID of the panel being edited (nil for global panel)
---@return boolean
function TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId)
	if classId == nil and specId == nil then
		return true -- Global panel always affects active spec
	end
	-- Druids share bar settings across all forms/specs
	if TRB.Data.character.classId == 11 then
		return true
	end
	return TRB.Data.character.classId == classId and TRB.Data.character.specId == specId
end

---Gets the aggregate state of a global setting across all class/specs
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@return boolean|nil # true if all enabled, false if all disabled, nil if mixed
local function GetAllSpecsGlobalState(settingKey)
	local global = TRB.Data.settings.core.global
	local allTrue = true
	local allFalse = true

	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local className = entry.className
		local specName = entry.specName
		if global[className] and global[className][specName] and global[className][specName][settingKey] ~= nil then
			if global[className][specName][settingKey] then
				allFalse = false
			else
				allTrue = false
			end
		end
	end

	if allTrue then
		return true
	elseif allFalse then
		return false
	else
		return nil -- Mixed state
	end
end

---Sets a global setting for all class/specs and updates related UI checkboxes
---@param settingKey string # The setting key (e.g., "bar", "comboPoints", "textures")
---@param value boolean # The value to set
local function SetAllSpecsGlobalSetting(settingKey, value)
	local global = TRB.Data.settings.core.global
	local settingDef = globalSettingDefinitions[settingKey]
	local checkboxSuffix = settingDef and settingDef.checkboxSuffix

	-- Update settings for all class/specs
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		local className = entry.className
		local specName = entry.specName
		if global[className] and global[className][specName] and global[className][specName][settingKey] ~= nil then
			global[className][specName][settingKey] = value
		end
	end

	-- Update all existing per-spec checkboxes in the UI across ALL classes
	if checkboxSuffix then
		for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			local frameName = "TwintopResourceBar_" .. entry.classToken .. "_" .. entry.specName .. "_useGlobal_" .. checkboxSuffix
			local checkbox = _G[frameName]
			if checkbox then
				checkbox:SetChecked(value)
			end
		end
	end

	-- Refresh caches for all specs that have been initialized (specCache exists)
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		if TRB.Data.specCache[entry.compositeKey] then
			TRB.Functions.Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
	end

	-- Trigger bar updates for current spec
	TRB.Functions.Character:ResetCaches()
	-- RecomputeFormattedValues re-reads live API values and re-formats ALL pre-formatted
	-- display strings (resource, health, primary stats, secondary stats) using the
	-- current precision settings.  It also calls InvalidateLookupMemoization which
	-- wipes prevLookupState and sets lookupDirty, forcing every lookup string to be
	-- rebuilt from scratch on the next RefreshLookupData pass.
	-- This is the same call the per-spec precision sliders use.
	TRB.Functions.Character:RecomputeFormattedValues()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		-- Recreate bar text frames to match potentially changed settings.
		-- FillSpecializationCacheSettings always rebuilds displayText, which can shift
		-- entry indices (e.g., globalBarText prepends global entries) or change font
		-- defaults. Without this, text frames become desynced from their entries â€”
		-- wrong parents, fonts, or positions â€” causing bar text to vanish.
		-- This matches the sequence in ConstructBarGroups.
		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarVisibility:MarkDirty()
		TRB.Functions.Bar:HideResourceBar()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	else
		-- All classes use the BarGroups system; this path should not be reached.
		-- ConstructBarGroups is called by each class module's ConstructResourceBar.
		if TRB.Functions.Bar.ConstructBarGroups then
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ConstructBarGroups(settings, TRB.Frames.barGroups)
		end
	end
end

---Builds a bulk global toggle checkbox for the Global Options panel
---@param parent Frame # Parent frame
---@param controls table # Controls table to store the checkbox
---@param controlKey string # Key to store in controls.checkBoxes
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints")
---@param yCoord number # Y coordinate for positioning
---@param customLabel string? # Optional custom label text
---@param customTooltip string? # Optional custom tooltip text
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, controlKey, settingKey, yCoord, customLabel, customTooltip)
	local f = nil

	yCoord = yCoord - 30
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes[controlKey] = CreateFrame("CheckButton", "TwintopResourceBar_Global_enableAll_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[controlKey]
	f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(customLabel or L["CheckboxEnableForAllSpecs"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	f.tooltip = customTooltip or L["CheckboxEnableForAllSpecsTooltip"]

	-- Set initial tristate based on current values
	local currentState = GetAllSpecsGlobalState(settingKey)
	SetCheckboxTriState(f, currentState)

	-- Store the setting key for the click handler
	f.settingKey = settingKey

	f:SetScript("OnClick", function(self, ...)
		-- Get current tristate: Unchecked->Checked, Mixed->Checked, Checked->Unchecked
		local currentState = GetAllSpecsGlobalState(self.settingKey)
		local newValue
		if currentState == true then
			newValue = false
		else
			-- Both false and nil (mixed) go to true
			newValue = true
		end

		SetAllSpecsGlobalSetting(self.settingKey, newValue)

		-- Update this checkbox's visual state
		SetCheckboxTriState(self, newValue)
	end)

	-- Add a "Copy..." button next to the bulk-toggle checkbox so users can
	-- push Global -> a single spec or pull a single spec -> Global without
	-- using the all-specs bulk apply.
	if TRB.Functions.OptionsUi.BuildGlobalBulkCopyButton then
		TRB.Functions.OptionsUi:BuildGlobalBulkCopyButton(f, settingKey)
	end

	return yCoord
end

---Refreshes the bulk global toggle checkbox state based on current per-spec settings
---Call this after changing a per-spec "Use global settings" checkbox
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints", "textures")
function TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(settingKey)
	local frameName = "TwintopResourceBar_Global_enableAll_" .. settingKey
	local checkbox = _G[frameName]
	if checkbox then
		local currentState = GetAllSpecsGlobalState(settingKey)
		SetCheckboxTriState(checkbox, currentState)
	end
end

---Creates a teal hyperlink-style text button anchored to the right of a "Use global settings" checkbox.
---Clicking the link navigates to the Global Options panel and selects the corresponding tab.
---@param checkbox CheckButton The "Use global settings" checkbox to attach the link to
---@param globalTabKey string The Global Options tab key to navigate to (e.g., "resourceBar", "barTextures")
function TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(checkbox, globalTabKey)
	local textRegion = _G[checkbox:GetName() .. "Text"]
	if not textRegion then
		return
	end

	local link = CreateFrame("Button", nil, checkbox)
	link:SetNormalFontObject("GameFontNormalSmall")
	link:SetHighlightFontObject("GameFontHighlightSmall")
	link:SetText(L["OpenGlobalSettings"])
	link:GetFontString():SetTextColor(GetUseGlobalSettingsColor())
	link:SetWidth(link:GetFontString():GetStringWidth() + 4)
	link:SetHeight(16)
	link:SetPoint("LEFT", textRegion, "RIGHT", 8, 0)
	link.tooltip = L["OpenGlobalSettingsTooltip"]

	link:SetScript("OnEnter", function(self)
		self:GetFontString():SetTextColor(1, 1, 1)
		SetCursor("Interface\\CURSOR\\vehichleCursor.PNG")
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
---@diagnostic disable-next-line: param-type-mismatch
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)

	link:SetScript("OnLeave", function(self)
		self:GetFontString():SetTextColor(GetUseGlobalSettingsColor())
		SetCursor(nil)
		GameTooltip:Hide()
	end)

	link:SetScript("OnClick", function()
		if TRB.Options.OptionsFrame then
			TRB.Options.OptionsFrame:SelectCategory("global")
			C_Timer.After(0, function()
---@diagnostic disable-next-line: param-type-mismatch
				TRB.Functions.OptionsUi:SwitchToTabByClassSpec(nil, nil, globalTabKey)
			end)
		end
	end)
end

-- ============================================================================
-- "Use Global" Copy menu infrastructure
-- ============================================================================
-- Each "Use Global" checkbox in a per-spec panel and each bulk-toggle checkbox
-- on the Global Options panel gets a sibling "Copy..." button that opens a
-- context menu allowing the user to copy configuration between Global, the
-- current spec, and any other spec across any stored profile.
--
-- Class/spec metadata (localized class names, spec names, ordering) is read
-- from the canonical TRB.Data.allClassSpecs table populated in Options.lua.
-- DO NOT duplicate that data here.

-- Returns the localized full spec name for (className, specName), or a sane
-- fallback if the lookup fails.
local function GetCopyMenuSpecLabel(className, specName)
	local specs = TRB.Data.allClassSpecs
	if specs then
		local prefix = className .. "_"
		for _, classDef in ipairs(specs) do
			if classDef.classKey == className then
				for _, specDef in ipairs(classDef.specs) do
					if specDef.compositeKey == prefix .. specName then
						return specDef.specLabel
					end
				end
				break
			end
		end
	end
	return className .. " " .. specName
end

-- Returns a shallow copy of TRB.Data.allClassSpecs sorted alphabetically by
-- localized class label, matching the Options nav order.
local function GetSortedClassSpecs()
	local sorted = {}
	for i, classDef in ipairs(TRB.Data.allClassSpecs or {}) do
		sorted[i] = classDef
	end
	table.sort(sorted, function(a, b) return a.classLabel < b.classLabel end)
	return sorted
end

-- Returns the readable source piece for the given (scope, profile, class, spec).
-- When profileName matches the resolved active profile (or is nil), the LIVE
-- runtime table is returned so unflushed edits are picked up. Otherwise the
-- stored profile table is returned.
local function GetCopyPieceForRead(scope, profileName, className, specName)
	local profiles = TRB.Functions.Profiles
	if scope == "core" then
		local activeName = profiles:ResolveCoreProfileName()
		if profileName == nil or profileName == activeName then
			return TRB.Data.settings.core
		end
		local p = TRB.Data.settings.profiles
		if p and p.list and p.list[profileName] then
			return p.list[profileName].core
		end
	elseif scope == "spec" and className ~= nil and specName ~= nil then
		local activeName = profiles:ResolveSpecProfileName(className, specName)
		if profileName == nil or profileName == activeName then
			TRB.Functions.Character:EnsureSpecSettings(className)
			local cls = TRB.Data.settings[className]
			return cls and cls[specName] or nil
		end
		local p = TRB.Data.settings.profiles
		if p and p.list and p.list[profileName] and p.list[profileName][className] then
			return p.list[profileName][className][specName]
		end
	end
	return nil
end

-- Returns the writable destination piece for the given (scope, profile, class,
-- spec). Live runtime is returned when profileName matches the active profile.
-- For non-active stored profiles, the table is created on demand if missing.
-- Returns the table plus a boolean indicating whether the destination is the
-- live (active) piece.
local function GetCopyPieceForWrite(scope, profileName, className, specName)
	local profiles = TRB.Functions.Profiles
	if scope == "core" then
		local activeName = profiles:ResolveCoreProfileName()
		if profileName == nil or profileName == activeName then
			return TRB.Data.settings.core, true
		end
		local p = TRB.Data.settings.profiles
		if p == nil or p.list == nil or p.list[profileName] == nil then
			return nil, false
		end
		p.list[profileName].core = p.list[profileName].core or {}
		return p.list[profileName].core, false
	elseif scope == "spec" and className ~= nil and specName ~= nil then
		local activeName = profiles:ResolveSpecProfileName(className, specName)
		if profileName == nil or profileName == activeName then
			TRB.Functions.Character:EnsureSpecSettings(className)
			local cls = TRB.Data.settings[className]
			if cls == nil or cls[specName] == nil then
				return nil, false
			end
			return cls[specName], true
		end
		local p = TRB.Data.settings.profiles
		if p == nil or p.list == nil or p.list[profileName] == nil then
			return nil, false
		end
		p.list[profileName][className] = p.list[profileName][className] or {}
		p.list[profileName][className][specName] = p.list[profileName][className][specName] or {}
		return p.list[profileName][className][specName], false
	end
	return nil, false
end

-- Deep-copies the given paths from src to dst. Missing paths in src are skipped
-- silently; intermediate tables in dst are created as needed.
local function CopySettingsByPaths(src, dst, paths)
	if src == nil or dst == nil then
		return false
	end
	for _, path in ipairs(paths) do
		local node = src
		for _, key in ipairs(path) do
			if type(node) == "table" then
				node = node[key]
			else
				node = nil
				break
			end
		end
		if node ~= nil then
			local parent = dst
			for i = 1, #path - 1 do
				local key = path[i]
				if type(parent[key]) ~= "table" then
					parent[key] = {}
				end
				parent = parent[key]
			end
			parent[path[#path]] = TRB.Functions.Table:DeepCopy(node)
		end
	end
	return true
end

-- Refreshes runtime state after a copy targeting the live (active) piece.
-- Mirrors the cache/bar-refresh sequence used by SetAllSpecsGlobalSetting.
local function RefreshAfterLiveCopy(destScope, destClassName, destSpecName)
	local profiles = TRB.Functions.Profiles
	if destScope == "core" then
		-- Re-resolve every initialized spec because any of them may pull from core.
		for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			if TRB.Data.specCache[entry.compositeKey] then
				TRB.Functions.Character:FillSpecializationCacheSettings(entry.className, entry.specName)
			end
		end
		profiles:WriteThrough("core")
	elseif destScope == "spec" then
		local compositeKey = TRB.Functions.Character:GetCompositeKey(destClassName, destSpecName)
		if TRB.Data.specCache[compositeKey] then
			TRB.Functions.Character:FillSpecializationCacheSettings(destClassName, destSpecName)
		end
		profiles:WriteThrough("spec", destClassName, destSpecName)
	end

	TRB.Functions.Character:ResetCaches()
	TRB.Functions.Character:RecomputeFormattedValues()
	if TRB.Frames.barGroups ~= nil and TRB.Data.specCache[TRB.Data.character.compositeKey] then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		if settings then
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
			TRB.Functions.BarText:CreateBarTextFrames()
			TRB.Functions.BarVisibility:MarkDirty()
			TRB.Functions.Bar:HideResourceBar()
		end
		TRB.Data.lookupDirty = true
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			C_Timer.After(0, function()
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end)
		end
	end
end

-- Returns a localized one-line description of a (scope, profile, class, spec)
-- target, used inside confirmation popups (e.g. "Default - Shadow Priest"
-- or "Global Options").
local function FormatCopyTarget(scope, profileName, className, specName)
	local profiles = TRB.Functions.Profiles
	local resolvedProfile = profileName
	if resolvedProfile == nil then
		if scope == "core" then
			resolvedProfile = profiles:ResolveCoreProfileName() or profiles.DEFAULT_NAME
		else
			resolvedProfile = profiles:ResolveSpecProfileName(className, specName) or profiles.DEFAULT_NAME
		end
	end

	local pieceLabel
	if scope == "core" then
		pieceLabel = L["ProfileScopeLabelGlobal"]
	else
		pieceLabel = GetCopyMenuSpecLabel(className, specName)
	end

	return string.format(L["CopyMenuTargetFormat"], resolvedProfile, pieceLabel)
end

-- Static popup registration (idempotent). All copy-confirm popups pass their
-- operation parameters through `data`.
local RefreshProfileDropdownForScope
local copyPopupsRegistered = false
local function EnsureCopyConfigPopupsRegistered()
	if copyPopupsRegistered then
		return
	end
	copyPopupsRegistered = true

	local function PerformDeferredCopy(data)
		if data == nil or data.settingKey == nil then
			return
		end
		local def = globalSettingDefinitions[data.settingKey]
		if def == nil then
			return
		end
		local src = GetCopyPieceForRead(data.srcScope, data.srcProfileName, data.srcClassName, data.srcSpecName)
		local dst, isLive = GetCopyPieceForWrite(data.dstScope, data.dstProfileName, data.dstClassName, data.dstSpecName)
		if src == nil or dst == nil then
			return
		end
		if not CopySettingsByPaths(src, dst, def.paths) then
			return
		end
		if isLive then
			RefreshAfterLiveCopy(data.dstScope, data.dstClassName, data.dstSpecName)
			-- The bar updates immediately via RefreshAfterLiveCopy, but the
			-- options panel controls (sliders, color pickers, etc.) were
			-- bound at construction time and don't observe runtime mutations.
			-- A reload is the only way to guarantee they reflect the new
			-- values consistently across all already-built panels. This
			-- matches the existing "Use this profile" flow.
			TRB.Functions.Profiles:FlushAndSuppressLogout()
			C_UI.Reload()
		else
			TRB.Functions.Profiles:InvalidateCache()
			RefreshProfileDropdownForScope(data.dstScope, data.dstClassName, data.dstSpecName)
			-- Non-active destination - just persist the changes via a flush
			-- so a subsequent /reload doesn't overwrite them.
			TRB.Functions.Profiles:FlushActive()
		end
	end

	StaticPopupDialogs["TwintopResourceBar_UseGlobal_CopyConfirm"] = {
		text = L["CopyMenuConfirmFormat"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function(self, data)
			PerformDeferredCopy(data)
		end,
		hideOnEscape = true,
		whileDead = true,
		timeout = 0,
		preferredIndex = 3,
	}

	StaticPopupDialogs["TwintopResourceBar_UseGlobal_CopyCrossClassConfirm"] = {
		text = L["CopyMenuConfirmCrossClassFormat"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function(self, data)
			PerformDeferredCopy(data)
		end,
		hideOnEscape = true,
		whileDead = true,
		timeout = 0,
		preferredIndex = 3,
	}
end

-- Shows the appropriate confirm popup for the given copy operation. If source
-- and destination differ in class for a shape-sensitive section, the cross-
-- class warning popup is used instead.
local function PromptCopyConfirm(data)
	EnsureCopyConfigPopupsRegistered()

	local def = globalSettingDefinitions[data.settingKey]
	local sectionLabel = (def and def.sectionLabel) or data.settingKey
	local srcLabel = FormatCopyTarget(data.srcScope, data.srcProfileName, data.srcClassName, data.srcSpecName)
	local dstLabel = FormatCopyTarget(data.dstScope, data.dstProfileName, data.dstClassName, data.dstSpecName)

	local crossClass = globalSettingDefinitions[data.settingKey]
		and globalSettingDefinitions[data.settingKey].shapeSensitive
		and data.srcScope == "spec" and data.dstScope == "spec"
		and data.srcClassName ~= nil and data.dstClassName ~= nil
		and data.srcClassName ~= data.dstClassName

	local popup = crossClass and "TwintopResourceBar_UseGlobal_CopyCrossClassConfirm"
		or "TwintopResourceBar_UseGlobal_CopyConfirm"
	StaticPopup_Show(popup, sectionLabel, string.format("%s\n  -> %s", srcLabel, dstLabel), data)
end

-- Adds a "From profile -> Class -> Spec" submenu under `parent` (a menu
-- description). Each leaf calls onSpecPicked(profileName, className, specName).
-- Returns true if the given profile contains core (Global) data.
local function ProfileHasCore(profileName)
	local profiles = TRB.Functions.Profiles
	if profileName == nil then
		return false
	end
	local activeName = profiles:ResolveCoreProfileName()
	if profileName == activeName then
		return TRB.Data.settings.core ~= nil
	end
	local p = TRB.Data.settings.profiles
	return p ~= nil and p.list ~= nil and p.list[profileName] ~= nil
		and type(p.list[profileName].core) == "table"
end

-- Returns true if the given profile contains data for (className, specName).
local function ProfileHasSpec(profileName, className, specName)
	local profiles = TRB.Functions.Profiles
	if profileName == nil or className == nil or specName == nil then
		return false
	end
	local activeName = profiles:ResolveSpecProfileName(className, specName)
	if profileName == activeName then
		TRB.Functions.Character:EnsureSpecSettings(className)
		local cls = TRB.Data.settings[className]
		return cls ~= nil and cls[specName] ~= nil
	end
	local p = TRB.Data.settings.profiles
	return p ~= nil and p.list ~= nil and p.list[profileName] ~= nil
		and type(p.list[profileName][className]) == "table"
		and type(p.list[profileName][className][specName]) == "table"
end

-- Adds a "From profile -> [Global | Class -> Spec]" submenu under `parent` (a
-- menu description). Each leaf calls onPicked(profileName, className, specName)
-- where className == nil means "core / Global Options" for that profile.
-- Only profiles/classes/specs that actually have stored data are included.
-- `excludeKey` (string "<className>:<specName>") is omitted when present so
-- the user can't pick the same spec they are operating on.
local function IsExcludedCopyMenuSpec(profileName, className, specName, excludeKey)
	if profileName == nil or className == nil or specName == nil or excludeKey == nil then
		return false
	end
	if (className .. ":" .. specName) ~= excludeKey then
		return false
	end
	local activeName = TRB.Functions.Profiles:ResolveSpecProfileName(className, specName)
	return profileName == activeName
end

---@param label string
---@return string
local function GetCopyMenuNewTargetLabel(label)
	return string.format(L["CopyMenuNewTargetFormat"], label)
end

-- Adds a source submenu under `parent` (a menu description). Only profiles /
-- classes / specs that currently have readable data are included.
local function AddProfileClassSpecSubmenu(parent, onPicked, excludeKey, excludeCurrentCoreProfile)
	local profiles = TRB.Functions.Profiles
	local profileNames = profiles:GetProfileNames()
	local sortedClasses = GetSortedClassSpecs()
	local activeCoreName = excludeCurrentCoreProfile and profiles:ResolveCoreProfileName() or nil
	for _, profileName in ipairs(profileNames) do
		-- Pre-compute which classes have any present spec in this profile so
		-- empty profiles / empty class branches are not shown at all.
		local classesWithSpecs = {}
		local hasCore = ProfileHasCore(profileName) and profileName ~= activeCoreName
		local profileHasAnything = hasCore
		for _, classDef in ipairs(sortedClasses) do
			local className = classDef.classKey
			local prefix = className .. "_"
			local hasAny = false
			for _, specDef in ipairs(classDef.specs) do
				local specName = string.sub(specDef.compositeKey, #prefix + 1)
				if not IsExcludedCopyMenuSpec(profileName, className, specName, excludeKey)
					and ProfileHasSpec(profileName, className, specName) then
					hasAny = true
					break
				end
			end
			if hasAny then
				classesWithSpecs[className] = true
				profileHasAnything = true
			end
		end
		if profileHasAnything then
			---@diagnostic disable-next-line: redundant-parameter, missing-parameter
			local profileMenu = parent:CreateButton(profileName)
			if type(profileMenu) == "table" and type(profileMenu.CreateButton) == "function" then
				if hasCore then
					profileMenu:CreateButton(L["ProfileScopeLabelGlobal"], function()
						onPicked(profileName, nil, nil)
					end)
				end
				for _, classDef in ipairs(sortedClasses) do
					local className = classDef.classKey
					if classesWithSpecs[className] then
						---@diagnostic disable-next-line: redundant-parameter, missing-parameter
						local classMenu = profileMenu:CreateButton(classDef.classLabel)
						if type(classMenu) == "table" and type(classMenu.CreateButton) == "function" then
							local prefix = className .. "_"
							for _, specDef in ipairs(classDef.specs) do
								local specName = string.sub(specDef.compositeKey, #prefix + 1)
								if not IsExcludedCopyMenuSpec(profileName, className, specName, excludeKey)
									and ProfileHasSpec(profileName, className, specName) then
									classMenu:CreateButton(specDef.specLabel, function()
										onPicked(profileName, className, specName)
									end)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Adds a destination submenu under `parent` (a menu description). All
-- profiles, classes, and specs are included so Copy To can target any
-- destination. Specs that do not yet exist in the destination profile are
-- marked with a purple " {New}" suffix.
local function AddDestinationProfileClassSpecSubmenu(parent, onPicked, excludeKey, excludeCurrentCoreProfile)
	local profiles = TRB.Functions.Profiles
	local profileNames = profiles:GetProfileNames()
	local sortedClasses = GetSortedClassSpecs()
	local activeCoreName = excludeCurrentCoreProfile and profiles:ResolveCoreProfileName() or nil
	for _, profileName in ipairs(profileNames) do
		---@diagnostic disable-next-line: redundant-parameter, missing-parameter
		local profileMenu = parent:CreateButton(profileName)
		if type(profileMenu) == "table" and type(profileMenu.CreateButton) == "function" then
			if profileName ~= activeCoreName then
				local globalLabel = L["ProfileScopeLabelGlobal"]
				if not ProfileHasCore(profileName) then
					globalLabel = GetCopyMenuNewTargetLabel(globalLabel)
				end
				profileMenu:CreateButton(globalLabel, function()
					onPicked(profileName, nil, nil)
				end)
			end
			for _, classDef in ipairs(sortedClasses) do
				local className = classDef.classKey
				---@diagnostic disable-next-line: redundant-parameter, missing-parameter
				local classMenu = profileMenu:CreateButton(classDef.classLabel)
				if type(classMenu) == "table" and type(classMenu.CreateButton) == "function" then
					local prefix = className .. "_"
					for _, specDef in ipairs(classDef.specs) do
						local specName = string.sub(specDef.compositeKey, #prefix + 1)
						if not IsExcludedCopyMenuSpec(profileName, className, specName, excludeKey) then
							local specLabel = specDef.specLabel
							if not ProfileHasSpec(profileName, className, specName) then
								specLabel = GetCopyMenuNewTargetLabel(specLabel)
							end
							classMenu:CreateButton(specLabel, function()
								onPicked(profileName, className, specName)
							end)
						end
					end
				end
			end
		end
	end
end

-- Builds and shows the per-spec "Use Global" Copy context menu attached to
-- `owner`. classId/specId identify the destination spec.
local function ShowUseGlobalCopyMenu(owner, classId, specId, settingKey)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	if className == nil or specName == nil then
		return
	end
	local profiles = TRB.Functions.Profiles
	local def = globalSettingDefinitions[settingKey]
	local sectionLabel = (def and def.sectionLabel) or settingKey
	local excludeKey = className .. ":" .. specName
	local currentCoreProfileName = profiles:ResolveCoreProfileName() or profiles.DEFAULT_NAME

	local function MakeData(srcScope, srcProfileName, srcClassName, srcSpecName, dstScope, dstProfileName, dstClassName, dstSpecName)
		return {
			settingKey      = settingKey,
			srcScope        = srcScope,
			srcProfileName  = srcProfileName,
			srcClassName    = srcClassName,
			srcSpecName     = srcSpecName,
			dstScope        = dstScope,
			dstProfileName  = dstProfileName,
			dstClassName    = dstClassName,
			dstSpecName     = dstSpecName,
		}
	end

	MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:CreateTitle(string.format(L["CopyMenuTitleFormat"], sectionLabel))

		---@diagnostic disable-next-line: redundant-parameter, missing-parameter
		local copyTo = rootDescription:CreateButton(L["CopyMenuCopyTo"])
		if type(copyTo) == "table" and type(copyTo.CreateButton) == "function" then
			copyTo:CreateTitle(L["CopyMenuCopyTo"])
			copyTo:CreateDivider()
			copyTo:CreateButton(string.format(L["CopyMenuUseAsCurrentGlobalProfileFormat"], currentCoreProfileName), function()
				PromptCopyConfirm(MakeData("spec", nil, className, specName, "core", nil, nil, nil))
			end)
			copyTo:CreateDivider()
			copyTo:CreateTitle(L["ProfileMenuHeaderProfiles"])
			AddDestinationProfileClassSpecSubmenu(copyTo, function(profileName, dstClass, dstSpec)
				if dstClass == nil then
					PromptCopyConfirm(MakeData("spec", nil, className, specName, "core", profileName, nil, nil))
				else
					PromptCopyConfirm(MakeData("spec", nil, className, specName, "spec", profileName, dstClass, dstSpec))
				end
			end, excludeKey, false)
		end

		---@diagnostic disable-next-line: redundant-parameter, missing-parameter
		local copyFrom = rootDescription:CreateButton(L["CopyMenuCopyFrom"])
		if type(copyFrom) == "table" and type(copyFrom.CreateButton) == "function" then
			copyFrom:CreateTitle(L["CopyMenuCopyFrom"])
			copyFrom:CreateDivider()
			copyFrom:CreateButton(string.format(L["CopyMenuUseFromCurrentGlobalProfileFormat"], currentCoreProfileName), function()
				PromptCopyConfirm(MakeData("core", nil, nil, nil, "spec", nil, className, specName))
			end)
			copyFrom:CreateDivider()
			copyFrom:CreateTitle(L["ProfileMenuHeaderProfiles"])
			AddProfileClassSpecSubmenu(copyFrom, function(profileName, srcClass, srcSpec)
				if srcClass == nil then
					-- "Global" pick: copy that profile's core into this spec
					PromptCopyConfirm(MakeData("core", profileName, nil, nil, "spec", nil, className, specName))
				else
					PromptCopyConfirm(MakeData("spec", profileName, srcClass, srcSpec, "spec", nil, className, specName))
				end
			end, excludeKey, true)
		end
	end)
end

---@param checkbox CheckButton
---@param button Button
local function PositionCopyButtonLeftOfCheckbox(checkbox, button)
	local point, relativeTo, relativePoint, xOfs, yOfs = checkbox:GetPoint(1)
	if point ~= nil then
		checkbox:ClearAllPoints()
		checkbox:SetPoint(point, relativeTo, relativePoint, (xOfs or 0) + 78, yOfs or 0)
		button:SetPoint(point, relativeTo, relativePoint, xOfs or 0, yOfs or 0)
	else
		button:SetPoint("RIGHT", checkbox, "LEFT", -4, 0)
	end
	-- Final visual order:
	--   [Copy...] [x] Use global settings
end

-- Builds the "Copy..." button next to a per-spec "Use Global" checkbox.
---@param checkbox CheckButton The "Use Global" checkbox to attach the button to
---@param classId integer The class ID of the destination spec
---@param specId integer The spec ID of the destination spec
---@param settingKey string A key from globalSettingDefinitions
function TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(checkbox, classId, specId, settingKey)
	if checkbox == nil or globalSettingDefinitions[settingKey] == nil then
		return nil
	end
	-- Bar Text section is intentionally excluded from the Copy menu.
	if settingKey == "globalBarText" then
		return nil
	end
	local button = CreateFrame("Button", nil, checkbox, "UIPanelButtonTemplate")
	button:SetText(L["CopyMenuButton"])
	button:SetSize(70, 20)
	PositionCopyButtonLeftOfCheckbox(checkbox, button)
	button.tooltip = L["CopyMenuButtonTooltip"]
	button:SetScript("OnEnter", function(self)
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
---@diagnostic disable-next-line: param-type-mismatch
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", function(self)
		ShowUseGlobalCopyMenu(self, classId, specId, settingKey)
	end)
	return button
end

-- Builds and shows the Global panel bulk-toggle Copy context menu attached
-- to `owner`. Source/destination semantics are inverted relative to the
-- per-spec menu: pick one or push/pull from one spec at a time.
local function ShowBulkGlobalCopyMenu(owner, settingKey)
	local def = globalSettingDefinitions[settingKey]
	local sectionLabel = (def and def.sectionLabel) or settingKey

	MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:CreateTitle(string.format(L["CopyMenuTitleFormat"], sectionLabel))

		---@diagnostic disable-next-line: redundant-parameter, missing-parameter
		local copyTo = rootDescription:CreateButton(L["CopyMenuCopyTo"])
		if type(copyTo) == "table" and type(copyTo.CreateButton) == "function" then
			copyTo:CreateTitle(L["CopyMenuCopyTo"])
			copyTo:CreateDivider()
			copyTo:CreateTitle(L["ProfileMenuHeaderProfiles"])
			AddDestinationProfileClassSpecSubmenu(copyTo, function(profileName, dstClass, dstSpec)
				PromptCopyConfirm({
					settingKey      = settingKey,
					srcScope        = "core",
					srcProfileName  = nil,
					srcClassName    = nil,
					srcSpecName     = nil,
					dstScope        = (dstClass == nil) and "core" or "spec",
					dstProfileName  = profileName,
					dstClassName    = dstClass,
					dstSpecName     = dstSpec,
				})
			end, nil, false)
		end

		---@diagnostic disable-next-line: redundant-parameter, missing-parameter
		local copyFrom = rootDescription:CreateButton(L["CopyMenuCopyFrom"])
		if type(copyFrom) == "table" and type(copyFrom.CreateButton) == "function" then
			copyFrom:CreateTitle(L["CopyMenuCopyFrom"])
			copyFrom:CreateDivider()
			copyFrom:CreateTitle(L["ProfileMenuHeaderProfiles"])
			AddProfileClassSpecSubmenu(copyFrom, function(profileName, srcClass, srcSpec)
				PromptCopyConfirm({
					settingKey      = settingKey,
					srcScope        = (srcClass == nil) and "core" or "spec",
					srcProfileName  = profileName,
					srcClassName    = srcClass,
					srcSpecName     = srcSpec,
					dstScope        = "core",
					dstProfileName  = nil,
					dstClassName    = nil,
					dstSpecName     = nil,
				})
			end, nil, true)
		end
	end)
end

-- Builds a "Copy..." button next to a Global-panel bulk-toggle checkbox.
---@param bulkCheckbox CheckButton The bulk-toggle checkbox to attach the button to
---@param settingKey string A key from globalSettingDefinitions
function TRB.Functions.OptionsUi:BuildGlobalBulkCopyButton(bulkCheckbox, settingKey)
	if bulkCheckbox == nil or globalSettingDefinitions[settingKey] == nil then
		return nil
	end
	-- Bar Text section is intentionally excluded from the Copy menu.
	if settingKey == "globalBarText" then
		return nil
	end
	local button = CreateFrame("Button", nil, bulkCheckbox, "UIPanelButtonTemplate")
	button:SetText(L["CopyMenuButton"])
	button:SetSize(70, 20)
	PositionCopyButtonLeftOfCheckbox(bulkCheckbox, button)
	button.tooltip = L["CopyMenuButtonTooltip"]
	button:SetScript("OnEnter", function(self)
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
---@diagnostic disable-next-line: param-type-mismatch
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", function(self)
		ShowBulkGlobalCopyMenu(self, settingKey)
	end)
	return button
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

local backgrounds = {}
local backgroundsList = {}
local backgroundPairs = {}
local backgroundPairsByName = {}
---Populates the background texture cache from LibSharedMedia if not already filled.
local function FillBackgroundCache()
	if TRB.Functions.Table:Length(backgrounds) == 0 then
		backgrounds = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
		backgroundsList = TRB.Details.addonData.libs.SharedMedia:List("background")

		local x = 1
		for k, v in pairs(backgroundsList) do
			table.insert(backgroundPairs, { v, backgrounds[v] })
			backgroundPairsByName[backgrounds[v]] = v
			x = x + 1
		end
	end
end

local borders = {}
local bordersList = {}
local borderPairs = {}
local borderPairsByName = {}
---Populates the border texture cache from LibSharedMedia if not already filled.
local function FillBorderCache()
	if TRB.Functions.Table:Length(borders) == 0 then
		borders = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
		bordersList = TRB.Details.addonData.libs.SharedMedia:List("border")

		local x = 1
		for k, v in pairs(bordersList) do
			table.insert(borderPairs, { v, borders[v] })
			borderPairsByName[borders[v]] = v
			x = x + 1
		end
	end
end

local statusbars = {}
local statusbarsList = {}
local statusbarPairs = {}
local statusbarPairsByName = {}
---Populates the status bar texture cache from LibSharedMedia if not already filled.
local function FillStatusbarCache()
	if TRB.Functions.Table:Length(statusbars) == 0 then
		statusbars = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
		statusbarsList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")

		local x = 1
		for k, v in pairs(statusbarsList) do
			table.insert(statusbarPairs, { v, statusbars[v] })
			statusbarPairsByName[statusbars[v]] = v
			x = x + 1
		end
	end
end

---Refreshes a WowStyle1DropdownTemplate control by re-invoking its stored GeneratorFunction.
---@param control DropdownButton # The dropdown control with a GeneratorFunction field
local function DropdownSetupMenuWrapper(control)
	control:SetupMenu(control.GeneratorFunction)
end

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18

---Creates a slider control with +/- buttons, an editable text box, a title label, and min/max labels.
---@param parent Frame
---@param title string
---@param minValue number
---@param maxValue number
---@param defaultValue number
---@param stepValue number
---@param numDecimalPlaces integer
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minValue, maxValue)
	f:SetValueStep(stepValue)
	f:SetSize(sizeX-36, sizeY)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
	f:SetOrientation("HORIZONTAL")
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
	   bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	   edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	   tile = true,
	   edgeSize = 8,
	   tileSize = 8,
	   insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	end)
	f:SetScript("OnValueChanged", function(self, value)
		self.EditBox:SetText(value)
	end)
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minValue)
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MaxLabel:SetText(maxValue)
	---@diagnostic disable-next-line: inject-field
	f.Title = f:CreateFontString(nil, "OVERLAY")
	f.Title:SetFontObject(GameFontNormal)
	f.Title:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.Title:SetWordWrap(false)
	f.Title:SetPoint("BOTTOM", f, "TOP")
	f.Title:SetText(title)
	---@diagnostic disable-next-line: inject-field
	f.Thumb = f:CreateTexture(nil, "ARTWORK")
	f.Thumb:SetSize(32, 32)
	f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
	eb:EnableMouseWheel(true)
	eb:SetAutoFocus(false)
	eb:SetNumeric(false)
	eb:SetJustifyH("CENTER")
	eb:SetFontObject(GameFontHighlightSmall)
	eb:SetSize(50, 14)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetPoint("Top", f, "Bottom", 0, -1)
	eb:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	eb:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	eb:SetBackdropColor(0, 0, 0, 1)
	eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	eb:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	eb:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	eb:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			f:SetValue(f:GetValue() + f:GetValueStep())
		else
			f:SetValue(f:GetValue() - f:GetValueStep())
		end
	end)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if value then
			local min, max = f:GetMinMaxValues()
			if value >= min and value <= max then
				f:SetValue(value)
			elseif value < min then
				f:SetValue(min)
			elseif value > max then
				f:SetValue(max)
			end
			value = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
			eb:SetText(value)
		else
			f:SetValue(f:GetValue())
		end
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	---@diagnostic disable-next-line: inject-field
	f.Plus = CreateFrame("Button", nil, f)
	f.Plus:SetSize(18, 18)
	f.Plus:RegisterForClicks("AnyUp")
	f.Plus:SetPoint("LEFT", f, "RIGHT", 0, 0)
	f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Plus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() + f:GetValueStep())
	end)
	---@diagnostic disable-next-line: inject-field
	f.Minus = CreateFrame("Button", nil, f)
	f.Minus:SetSize(18, 18)
	f.Minus:RegisterForClicks("AnyUp")
	f.Minus:SetPoint("RIGHT", f, "LEFT", 0, 0)
	f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Minus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	f:SetValue(defaultValue)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(defaultValue)
	eb:SetCursorPosition(0)

	return f
end

---Builds a slider that displays and accepts percentage values but stores decimal values.
---For example, displays "30%" but stores 0.30 internally.
---@param parent Frame
---@param title string
---@param minPercent number # Minimum value in percentage (e.g., 0 for 0%)
---@param maxPercent number # Maximum value in percentage (e.g., 100 for 100%, or 1000 for 1000%)
---@param defaultDecimalValue number # Default value as a decimal (e.g., 0.30 for 30%)
---@param stepPercent number # Step size in percentage (e.g., 1 for 1%)
---@param numDecimalPlaces integer # Decimal places to show in the percentage display (e.g., 0 for "30%", 2 for "30.00%")
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi:BuildPercentageSlider(parent, title, minPercent, maxPercent, defaultDecimalValue, stepPercent, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minPercent, maxPercent)
	f:SetValueStep(stepPercent)
	f:SetSize(sizeX-36, sizeY)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
	f:SetOrientation("HORIZONTAL")
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
	   bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	   edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	   tile = true,
	   edgeSize = 8,
	   tileSize = 8,
	   insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	end)
	f:SetScript("OnValueChanged", function(self, value)
		-- Display as percentage with % suffix
		local displayValue = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
		self.EditBox:SetText(displayValue .. "%")
	end)
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minPercent .. "%")
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MaxLabel:SetText(maxPercent .. "%")
	---@diagnostic disable-next-line: inject-field
	f.Title = f:CreateFontString(nil, "OVERLAY")
	f.Title:SetFontObject(GameFontNormal)
	f.Title:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.Title:SetWordWrap(false)
	f.Title:SetPoint("BOTTOM", f, "TOP")
	f.Title:SetText(title)
	---@diagnostic disable-next-line: inject-field
	f.Thumb = f:CreateTexture(nil, "ARTWORK")
	f.Thumb:SetSize(32, 32)
	f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
	eb:EnableMouseWheel(true)
	eb:SetAutoFocus(false)
	eb:SetNumeric(false)
	eb:SetJustifyH("CENTER")
	eb:SetFontObject(GameFontHighlightSmall)
	eb:SetSize(50, 14)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetPoint("Top", f, "Bottom", 0, -1)
	eb:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	eb:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	eb:SetBackdropColor(0, 0, 0, 1)
	eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	eb:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	eb:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	eb:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			f:SetValue(f:GetValue() + f:GetValueStep())
		else
			f:SetValue(f:GetValue() - f:GetValueStep())
		end
	end)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function(self)
		-- Parse the input, stripping any % suffix and converting to number
		local inputText = self:GetText()
		inputText = inputText:gsub("%%", "") -- Remove % sign if present
		local value = tonumber(inputText)
		if value then
			local min, max = f:GetMinMaxValues()
			if value >= min and value <= max then
				f:SetValue(value)
			elseif value < min then
				f:SetValue(min)
			elseif value > max then
				f:SetValue(max)
			end
			value = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(value .. "%")
		else
			-- Invalid input, reset to current value
			local currentValue = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(currentValue .. "%")
		end
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	---@diagnostic disable-next-line: inject-field
	f.Plus = CreateFrame("Button", nil, f)
	f.Plus:SetSize(18, 18)
	f.Plus:RegisterForClicks("AnyUp")
	f.Plus:SetPoint("LEFT", f, "RIGHT", 0, 0)
	f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Plus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() + f:GetValueStep())
	end)
	---@diagnostic disable-next-line: inject-field
	f.Minus = CreateFrame("Button", nil, f)
	f.Minus:SetSize(18, 18)
	f.Minus:RegisterForClicks("AnyUp")
	f.Minus:SetPoint("RIGHT", f, "LEFT", 0, 0)
	f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Minus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	-- Set initial value (convert decimal to percentage for display)
	local initialPercent = defaultDecimalValue * 100
	f:SetValue(initialPercent)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(TRB.Functions.Number:RoundTo(initialPercent, numDecimalPlaces) .. "%")
	eb:SetCursorPosition(0)

	return f
end

---Creates a single-line text input box with standard backdrop styling and keyboard behavior.
---@param parent Frame # The parent frame to attach the text box to
---@param text string # The initial text to display
---@param maxLetters integer # Maximum number of characters allowed
---@param width number # Width of the text box in pixels
---@param height number # Height of the text box in pixels
---@param xPos number # X offset from parent's TOPLEFT
---@param yPos number # Y offset from parent's TOPLEFT
---@return EditBox|BackdropTemplate
function TRB.Functions.OptionsUi:BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
	local f = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	f:SetPoint("TOPLEFT", xPos, yPos)
	f:SetAutoFocus(false)
	f:SetMaxLetters(maxLetters)
	f:SetJustifyH("LEFT")
	f:SetFontObject(GameFontHighlight)
	f:SetSize(width, height)
	f:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	f:SetBackdropColor(0, 0, 0, 1)
	f:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	f:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	f:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	f:SetText(text)
	f:SetCursorPosition(0)

	return f
end

---Clamps a numeric value to a slider's min/max range and updates its EditBox text display.
---@param box Slider # The slider frame (with an EditBox child) returned by BuildSlider
---@param value number # The value to set
---@return number # The clamped value
function TRB.Functions.OptionsUi:EditBoxSetTextMinMax(box, value)
	local min, max = box:GetMinMaxValues()
	if value > max then
		value = max
	elseif value < min then
		value = min
	end
	box.EditBox:SetText(value)
	return value
end

---Opens the WoW color picker dialog pre-filled with the given RGBA values.
---@param r number # Red component (0-1)
---@param g number # Green component (0-1)
---@param b number # Blue component (0-1)
---@param a number # Alpha component (0-1, where 1 is fully opaque)
---@param callback function # Called when the color is changed or cancelled
function TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame:SetupColorPickerAndShow({
		swatchFunc = callback,
		opacityFunc = callback,
		cancelFunc = callback,--cancelCallback,
		r = r,
		g = g,
		b = b,
		opacity = 1-a,
		hasOpacity = (a ~= nil)
	})
end

---Extracts RGBA color values from a color picker callback argument or directly from the ColorPickerFrame.
---@param color table? # The color table passed to the callback (nil if reading directly from the frame)
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
---@return number a # Alpha component (0-1)
function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
	local r, g, b, a
	if color then
		r = color.r
		g = color.g
		b = color.b
		a = color.a
	else
		r, g, b = ColorPickerFrame:GetColorRGB()
		a = ColorPickerFrame:GetColorAlpha()
	end
	return r, g, b, a
end

---Handles mouse-down on a color picker swatch: opens the color picker and applies changes to the bar and settings.
---@param button string # The mouse button pressed (e.g., "LeftButton")
---@param colorTable table # The settings table containing the color entry
---@param colorControlsTable table # The controls table containing the color picker frame
---@param key string # The key into colorTable/colorControlsTable for the color entry
---@param frameType string? # The type of frame to update ("backdrop", "border", "bar", "threshold", or "health")
---@param frame Frame|table|nil # The frame(s) to update live, or nil for health-type updates
---@param classId integer? # Class ID for the panel being edited
---@param specId integer? # Spec ID for the panel being edited
function TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId)
	if button == "LeftButton" then
		-- Handle both table format { color = "FFRRGGBB" } and direct string format "FFRRGGBB"
		local colorValue = colorTable[key]
		local isNestedTable = type(colorValue) == "table" and colorValue.color ~= nil
		local colorString = isNestedTable and colorValue.color or colorValue

		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
		TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			local newColorString = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			-- Update the color in the appropriate format
			if isNestedTable then
				colorTable[key].color = newColorString
			else
				colorTable[key] = newColorString
			end

			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				if frame ~= nil then
					if frameType == "backdrop" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropColor(f, nil, r_1, g_1, b_1, a_1)
							end
						else
							TRB.Functions.Color:SetBackdropColor(frame, nil, r_1, g_1, b_1, a_1)
						end
					elseif frameType == "border" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(f, nil, newColorString)
							end
						else
							TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, nil, newColorString)
						end
					elseif frameType == "bar" then
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, nil, newColorString)
					elseif frameType == "threshold" then
						TRB.Functions.Color:SetThresholdColor(frame, newColorString, true, classId, specId)
					end
				elseif frameType == "health" then
					TRB.Functions.Character:UpdateHealthValues()
				end

				-- Clear color caches and trigger resource bar update to apply correct spec colors
				TRB.Data.cache.colors.backdrop = {}
				TRB.Data.cache.colors.border = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
	end
end

---Gets the primary bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi:GetPrimaryBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			return primaryNode:GetFrame()
		end
	end
	return nil
end

---Gets all secondary bar container frames (combo points, etc.) for use in color picker callbacks
---@return table<number, Frame>
function TRB.Functions.OptionsUi:GetSecondaryBackdropFrames()
	local frames = {}
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.secondary then
		local nodeCount = barGroups.secondary:GetNodeCount()
		for i = 1, nodeCount do
			local node = barGroups.secondary:GetNode(i)
			if node then
				local containerFrame = node:GetFrame()
				if containerFrame then
					table.insert(frames, containerFrame)
				end
			end
		end
	end
	return frames
end

---Gets the health bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi:GetHealthBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.health then
		local healthNode = barGroups.health:GetNode(1)
		if healthNode then
			return healthNode:GetFrame()
		end
	end
	return nil
end

---Creates a color picker button with a colored texture swatch and a descriptive text label.
---@param parent Frame # The parent frame
---@param description string # Text label displayed next to the color swatch
---@param settingsEntry string # ARGB hex color string (e.g., "FF00FF00") used to set the initial swatch color
---@param sizeTotal number # Total width reserved for the color picker and label combined
---@param sizeFrame number # Width and height of the color swatch square
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Button|BackdropTemplate
function TRB.Functions.OptionsUi:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
	local f = CreateFrame("Button", nil, parent, "BackdropTemplate")
	f:SetSize(sizeFrame, sizeFrame)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize=4,
		edgeSize=12
	})
	---@diagnostic disable-next-line: inject-field
	f.Texture = f:CreateTexture(nil)
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settingsEntry, true))
	f:EnableMouse(true)
	---@diagnostic disable-next-line: inject-field
	f.Font = f:CreateFontString(nil)
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
	---@diagnostic disable-next-line: redundant-parameter
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

local function NormalizeGradientColorEntry(colorEntry)
	if colorEntry == nil then
		return
	end

	if colorEntry.color2 == nil then
		colorEntry.color2 = colorEntry.color
	end

	if gradientDirectionAbbrevLabels[colorEntry.gradientDirection] == nil then
		colorEntry.gradientDirection = "disabled"
	end
end

---Builds a gradient-aware color picker with two swatches and a direction cycle button.
---The first swatch controls `colorEntry.color`, the second controls `colorEntry.color2`.
---The cycle button rotates through Disabled / Horizontal / Vertical gradient directions.
---When direction is "disabled", the second swatch is grayed out and non-interactive.
---@param parent Frame
---@param description string # Label text beside the swatches
---@param colorEntry table # Table with `color`, plus optional `color2` and `gradientDirection` fields
---@param sizeTotal number # Total width reserved for the widget and label combined
---@param sizeFrame number # Width and height of each color swatch square
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param tooltipNote string? # Optional tooltip text shown on the direction button
---@return Frame # Container frame with .Swatch1, .Swatch2, .DirectionButton, .Font children
function TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, description, colorEntry, sizeTotal, sizeFrame, posX, posY, tooltipNote)
	NormalizeGradientColorEntry(colorEntry)

	local swatchSize = sizeFrame - 8
	local gap = 2
	local btnWidth = 22
	local btnGap = 4

	local container = CreateFrame("Frame", nil, parent)
	container:SetSize(sizeTotal, sizeFrame)
	container:SetPoint("TOPLEFT", posX, posY)

	-- Swatch 1 (primary color)
	local s1 = CreateFrame("Button", nil, container, "BackdropTemplate")
	s1:SetSize(swatchSize, swatchSize)
	s1:SetPoint("TOPLEFT", 0, -math.floor((sizeFrame - swatchSize) / 2))
	s1:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10
	})
	---@diagnostic disable-next-line: inject-field
	s1.Texture = s1:CreateTexture(nil)
	s1.Texture:ClearAllPoints()
	s1.Texture:SetPoint("TOPLEFT", 3, -3)
	s1.Texture:SetPoint("BOTTOMRIGHT", -3, 3)
	s1.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color, true))
	s1:EnableMouse(true)

	-- Swatch 2 (secondary color)
	local s2 = CreateFrame("Button", nil, container, "BackdropTemplate")
	s2:SetSize(swatchSize, swatchSize)
	s2:SetPoint("LEFT", s1, "RIGHT", gap, 0)
	s2:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10
	})
	---@diagnostic disable-next-line: inject-field
	s2.Texture = s2:CreateTexture(nil)
	s2.Texture:ClearAllPoints()
	s2.Texture:SetPoint("TOPLEFT", 3, -3)
	s2.Texture:SetPoint("BOTTOMRIGHT", -3, 3)
	s2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color2, true))
	s2:EnableMouse(true)

	-- Direction cycle button
	local btn = CreateFrame("Button", nil, container, "BackdropTemplate")
	btn:SetSize(btnWidth, swatchSize)
	btn:SetPoint("LEFT", s2, "RIGHT", btnGap, 0)
	btn:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 4, edgeSize = 10,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
	})
	btn:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
	---@diagnostic disable-next-line: inject-field
	btn.Font = btn:CreateFontString(nil)
	btn.Font:SetPoint("CENTER", 0, 0)
	btn.Font:SetFontObject(GameFontHighlightSmall)
	btn.Font:SetText(gradientDirectionAbbrevLabels[colorEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
	btn:EnableMouse(true)

	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["GradientDirectionButtonTooltip"], 1, 1, 1)
		if tooltipNote then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(tooltipNote, 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Label
	---@diagnostic disable-next-line: inject-field
	container.Font = container:CreateFontString(nil)
	container.Font:SetPoint("LEFT", btn, "RIGHT", 10, 0)
	container.Font:SetFontObject(GameFontHighlight)
	container.Font:SetText(description)
	---@diagnostic disable-next-line: redundant-parameter
	container.Font:SetWordWrap(true)
	container.Font:SetJustifyH("LEFT")
	local labelWidth = sizeTotal - (swatchSize * 2 + gap + btnGap + btnWidth + 35)
	container.Font:SetSize(labelWidth, sizeFrame)

	-- Apply initial disabled state to swatch 2
	local function UpdateSwatch2State()
		if colorEntry.gradientDirection == "disabled" then
			s2:SetAlpha(0.35)
			s2:EnableMouse(false)
		else
			s2:SetAlpha(1.0)
			s2:EnableMouse(true)
		end
		btn.Font:SetText(gradientDirectionAbbrevLabels[colorEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
	end
	UpdateSwatch2State()

	-- Expose child references for external use
	---@diagnostic disable-next-line: inject-field
	container.Swatch1 = s1
	---@diagnostic disable-next-line: inject-field
	container.Swatch2 = s2
	---@diagnostic disable-next-line: inject-field
	container.DirectionButton = btn
	-- Alias for compatibility: callers that read .Texture (like ToggleColorPickerEnabled) will find it on Swatch1
	---@diagnostic disable-next-line: inject-field
	container.Texture = s1.Texture
	---@diagnostic disable-next-line: inject-field
	container.UpdateSwatch2State = UpdateSwatch2State

	-- Direction cycle click handler
	btn:SetScript("OnMouseDown", function(self, mouseButton)
		if mouseButton == "LeftButton" then
			local currentIdx = 1
			for idx, dir in ipairs(gradientDirectionCycle) do
				if dir == colorEntry.gradientDirection then
					currentIdx = idx
					break
				end
			end
			local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
			colorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
			UpdateSwatch2State()
			TRB.Data.cache.colors.gradient = {}
			TRB.Data.cache.colors.bar = {}
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	return container
end

---Handles mouse-down on a gradient color picker's secondary swatch: opens the color picker for `color2`.
---@param button string # The mouse button pressed
---@param colorEntry table # The settings entry with `color`, `color2`, `gradientDirection`
---@param swatch2 Button|BackdropTemplate # The second swatch frame (to update its texture)
---@param classId integer? # Class ID for the panel being edited
---@param specId integer? # Spec ID for the panel being edited
function TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorEntry, swatch2, classId, specId)
	NormalizeGradientColorEntry(colorEntry)

	if button == "LeftButton" and colorEntry.gradientDirection ~= "disabled" then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color2, true)
		TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1 - a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
			swatch2.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			colorEntry.color2 = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)

			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Data.cache.colors.gradient = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
	end
end

---Builds standard TRB color picker with an optional enable/disable checkbox
---@param parent frame
---@param controls table
---@param controlType string
---@param colorTable table
---@param namePrefix string
---@param value TRB.Classes.OptionsUi.Color
---@param yCoord number
---@return number
---@return table|BackdropTemplate|Button
---@return CheckButton
function TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, controlType, colorTable, namePrefix, value)
	local fCheckbox = nil
	local fColor = nil

	controls.colors[controlType] = controls.colors[controlType] or {}

	yCoord = yCoord - 30
	if value.hasEnabledCheckbox == true then
		fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_threshold" .. value.name, parent, "ChatConfigCheckButtonTemplate")
		controls.checkBoxes["threshold" .. value.name] = fCheckbox
		fCheckbox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(fCheckbox:GetName() .. 'Text'):SetText(value.enabledCheckboxLocalization)
		fCheckbox.tooltip = value.enabledCheckboxTooltipLocalization
		fCheckbox:SetChecked(colorTable[value.name].enabled)
		fCheckbox:SetScript("OnClick", function(self, ...)
			colorTable[value.name].enabled = self:GetChecked()
		end)
	end

	controls.colors.threshold[value.name] = TRB.Functions.OptionsUi:BuildColorPicker(parent, value.colorLocalization, colorTable[value.name].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	fColor = controls.colors.threshold[value.name]

	if value.colorScript ~= nil and type(value.colorScript) == "function" then
		fColor:SetScript("OnMouseDown", value.colorScript(self, button))
	else
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, controls.colors[controlType], value.name)
		end)
	end

	return yCoord, fColor, fCheckbox
end

---Creates a section header frame with a large font title string.
---@param parent Frame # The parent frame
---@param title string # Header text to display
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@return Frame
function TRB.Functions.OptionsUi:BuildSectionHeader(parent, title, posX, posY)
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

---Creates a two-part help entry: a right-aligned variable name and a left-aligned description below it.
---@param parent Frame # The parent frame
---@param var string # The variable name or label (displayed right-aligned)
---@param desc string # The description text (displayed below the variable)
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param offset number # Width of the variable label column
---@param width number # Total width of the help entry
---@param height number? # Height of the variable label row (default 30)
---@param height2 number? # Height of the description area (default height * 3)
---@param justifyH string? # Horizontal justification for the description text (default "LEFT")
---@param fontFile string? # Optional font file path for the description text
---@return Frame
function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2, justifyH, fontFile)
	height = height or 30
	height2 = height2 or (height * 3)
	justifyH = justifyH or "LEFT"
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 20)
	f.font:SetJustifyH("RIGHT")
	f.font:SetJustifyV("TOP")
	f.font:SetSize(offset, height)
	f.font:SetText(var)

---@diagnostic disable-next-line: inject-field
	f.description = CreateFrame("Frame", nil, parent)
	local fd = f.description
	fd:ClearAllPoints()
	fd:SetPoint("TOPLEFT", parent)
	fd:SetPoint("TOPLEFT", posX+10, posY-height)
	fd:SetWidth(width-5)
	fd:SetHeight(height2)
	---@diagnostic disable-next-line: inject-field
	fd.font = fd:CreateFontString(nil)
	fd.font:SetFontObject(GameFontHighlight)

	if fontFile ~= nil then
		fd.font:SetFont(fontFile, 12)
	end

	fd.font:SetPoint("LEFT", fd, "LEFT")
	fd.font:SetSize(0, 16)
	fd.font:SetJustifyH(justifyH)
	fd.font:SetJustifyV("TOP")
	fd.font:SetSize(width, height2)
	fd.font:SetText(desc)
---@diagnostic disable-next-line: redundant-parameter
	fd.font:SetWordWrap(true)

	return f
end

---Creates a standard button with normal, highlight, and pushed textures.
---@param parent Frame # The parent frame
---@param text string # Button label text
---@param posX number # X offset from parent's TOPLEFT
---@param posY number # Y offset from parent's TOPLEFT
---@param width number # Button width in pixels
---@param height number # Button height in pixels
---@return Button
function TRB.Functions.OptionsUi:BuildButton(parent, text, posX, posY, width, height)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	f:SetText(text)
---@diagnostic disable-next-line: param-type-mismatch
	f:SetNormalFontObject("GameFontNormal")
	---@diagnostic disable-next-line: inject-field
	f.ntex = f:CreateTexture()
	f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.ntex:SetAllPoints()
	f:SetNormalTexture(f.ntex)
	---@diagnostic disable-next-line: inject-field
	f.htex = f:CreateTexture()
	f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.htex:SetAllPoints()
	f:SetHighlightTexture(f.htex)
	---@diagnostic disable-next-line: inject-field
	f.ptex = f:CreateTexture()
	f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.ptex:SetAllPoints()
	f:SetPushedTexture(f.ptex)

	return f
end

---Builds an export button anchored to the top-right corner of its parent panel.
---Used for "Export Bar Display", "Export Thresholds", "Export Bar Text", etc.
---@param parent Frame The parent panel
---@param text string Button label text
---@param yCoord number Vertical offset from parent's top
---@param height? number Button height (default 25)
---@return Button
function TRB.Functions.OptionsUi:BuildExportButton(parent, text, yCoord, height)
	height = height or 25
	local f = TRB.Functions.OptionsUi:BuildButton(parent, text, 0, 0, 225, height)
	f:ClearAllPoints()
	f:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, yCoord)
	return f
end

-- ============================================================================
-- Profile management dropdown (Phase 2B + 2C)
-- ============================================================================

---Returns a deep-copied spec piece from the class's LoadDefaultSettings, so
---"Use Baseline" gets a fresh default table not shared with runtime state.
---@param className string # lowercase
---@param specName string
---@return table?
local function GetBaselineSpecPiece(className, specName)
	local capitalized = TRB.Functions.Character:GetClassModuleName(className)
	if capitalized == nil then
		return nil
	end
	local classOptions = TRB.Options and TRB.Options[capitalized]
	if classOptions == nil or type(classOptions.LoadDefaultSettings) ~= "function" then
		return nil
	end
	local full = classOptions.LoadDefaultSettings(true)
	if type(full) ~= "table" then
		return nil
	end
	local classBucket = full[className]
	if type(classBucket) ~= "table" then
		return nil
	end
	return classBucket[specName]
end

---Returns a fresh baseline core piece.
---@return table?
local function GetBaselineCorePiece()
	if TRB.Functions.Settings == nil or type(TRB.Functions.Settings.LoadDefaultSettings) ~= "function" then
		return nil
	end
	local settings = TRB.Functions.Settings:LoadDefaultSettings()
	return settings and settings.core
end

---Returns the live spec piece for the given class+spec, or nil if not loaded.
---@param className string
---@param specName string
---@return table?
local function GetCurrentSpecPiece(className, specName)
	if TRB.Data.settings == nil then
		return nil
	end
	local bucket = TRB.Data.settings[className]
	if type(bucket) ~= "table" then
		return nil
	end
	return bucket[specName]
end

---Returns the live core piece, or nil if not loaded.
---@return table?
local function GetCurrentCorePiece()
	return TRB.Data.settings and TRB.Data.settings.core
end

---Returns the currently active profile name for the given scope.
---@param scope "spec"|"core"
---@param className string?
---@param specName string?
---@return string
local function GetActiveProfileName(scope, className, specName)
	local Profiles = TRB.Functions.Profiles
	if scope == "core" then
		return Profiles:ResolveCoreProfileName() or Profiles.DEFAULT_NAME
	end
	return Profiles:ResolveSpecProfileName(className, specName) or Profiles.DEFAULT_NAME
end

---Returns the cached, sorted profile-name list for the given scope.
---@param scope "spec"|"core"
---@param className string?
---@param specName string?
---@return string[]
local function GetProfileList(scope, className, specName)
	local Profiles = TRB.Functions.Profiles
	if scope == "core" then
		return Profiles:GetCoreListFromCache()
	end
	return Profiles:GetSpecListFromCache(className, specName)
end

---@param scope "spec"|"core"
---@param className string?
---@param specName string?
---@return string
local function GetProfileDropdownFrameName(scope, className, specName)
	local namePrefix = "TwintopResourceBar_ProfileDropdown"
	if scope == "spec" then
		return namePrefix .. "_" .. tostring(className) .. "_" .. tostring(specName)
	end
	return namePrefix .. "_Core"
end

---@param scope "spec"|"core"
---@param className string?
---@param specName string?
RefreshProfileDropdownForScope = function(scope, className, specName)
	local dropdown = _G[GetProfileDropdownFrameName(scope, className, specName)]
	if dropdown == nil then
		return
	end
	if dropdown.UpdateButtonText then
		dropdown:UpdateButtonText()
	end
	if dropdown.SetupMenu and dropdown.GeneratorFunction then
		dropdown:SetupMenu(dropdown.GeneratorFunction)
	end
	if dropdown.RefreshLayout then
		dropdown:RefreshLayout()
	end
end

---Writes a new profile piece and switches the character to it. Flow:
---  - If `sourceMode == "baseline"`, copies baseline defaults.
---  - If `sourceMode == "current"`, copies the live settings piece.
---After writing, updates the character's active-profile ref and writes through.
---If `reload` is true, prompts a UI reload.
---@param scope "spec"|"core"
---@param className string?
---@param specName string?
---@param profileName string
---@param sourceMode "current"|"baseline"
---@param reload boolean
local function ApplyNewProfile(scope, className, specName, profileName, sourceMode, reload)
	local Profiles = TRB.Functions.Profiles
	local source
	if scope == "core" then
		source = sourceMode == "baseline" and GetBaselineCorePiece() or GetCurrentCorePiece()
		if type(source) ~= "table" then
			return
		end
		Profiles:CreateCoreProfile(profileName, source)
		Profiles:SetActiveCoreProfile(profileName)
	else
		source = sourceMode == "baseline" and GetBaselineSpecPiece(className, specName) or GetCurrentSpecPiece(className, specName)
		if type(source) ~= "table" then
			return
		end
		Profiles:CreateSpecProfile(profileName, className, specName, source)
		Profiles:SetActiveSpecProfile(specName, profileName)
	end
	-- Only "baseline" source requires a reload: the live in-memory settings
	-- still hold the previous profile's values, so we need to reload to
	-- re-resolve them from the freshly-created baseline piece. With "current",
	-- the new profile is a copy of what's already loaded — just updating the
	-- active-profile pointer is sufficient and no reload is needed.
	if reload and sourceMode == "baseline" then
		-- Suppress the PLAYER_LOGOUT flush: we just wrote baseline defaults
		-- into the new profile. Without this, FlushActive would overwrite
		-- those defaults with the current (old) runtime data during reload.
		TRB.Functions.Profiles.suppressLogoutFlush = true
		C_UI.Reload()
	end
end

-- Lazy registration of all profile-management popup dialogs. Called on first
-- `BuildProfileDropdown` invocation. Each popup's `data` field carries the
-- scope/class/spec triplet plus operation-specific fields (attempted name,
-- source mode, etc.) so the same popup can serve both core and spec scopes.
local profilePopupsRegistered = false
local function EnsureProfilePopupsRegistered()
	if profilePopupsRegistered then
		return
	end
	profilePopupsRegistered = true

	-- Helper: build a human-friendly label for "this scope" used in popup text.
	local function ScopeLabel(data)
		if data == nil or data.scope == "core" then
			return L["ProfileScopeLabelGlobal"]
		end
		return data.specLabel or ""
	end

	local function ExportPieceLabel(data)
		if data ~= nil and type(data.pieceLabel) == "string" and data.pieceLabel ~= "" then
			return data.pieceLabel
		end
		return ScopeLabel(data)
	end

	local function HumanizeInternalToken(token)
		if type(token) ~= "string" or token == "" then
			return ""
		end

		local spaced = token:gsub("(%l)(%u)", "%1 %2")
		return (spaced:gsub("(%a)([%w']*)", function(first, rest)
			return string.upper(first) .. string.lower(rest)
		end))
	end

	local function GetImportSlotDisplayLabel(className, specName)
		if className == nil or specName == nil then
			return ""
		end

		local classId, specId = TRB.Functions.IO:GetClassSpecIdsByName(className, specName)
		local localizedClass = classId ~= nil and GetClassInfo and GetClassInfo(classId) or nil
		local classLabel = localizedClass or HumanizeInternalToken(className)

		local specLabel
		if classId ~= nil and specId ~= nil and GetSpecializationInfoForClassID ~= nil then
			local _, localizedSpec = GetSpecializationInfoForClassID(classId, specId)
			specLabel = localizedSpec
		end
		specLabel = specLabel or HumanizeInternalToken(specName)

		if specLabel ~= "" and classLabel ~= "" then
			return string.format("%s %s", specLabel, classLabel)
		end
		return specLabel ~= "" and specLabel or classLabel
	end

	StaticPopupDialogs["TwintopResourceBar_Profile_NewName"] = {
		text = "",
		button1 = L["ProfileButtonUseCurrent"],
		button2 = L["ProfileButtonUseBaseline"],
		button3 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupNewNameText"], ScopeLabel(data))
			local eb = self:GetEditBox()
			if eb ~= nil then
				eb:SetText(data and data.initialName or "")
				eb:HighlightText()
				eb:SetAutoFocus(true)
			end
		end,
		OnAccept = function(self, data)
			local name = self:GetEditBox():GetText() or ""
			name = name:gsub("^%s+", ""):gsub("%s+$", "")
			if name == "" then
				return
			end
			data.attemptedName = name
			data.sourceMode = "current"
			local exists
			if data.scope == "core" then
				exists = TRB.Functions.Profiles:ProfileExistsForCore(name)
			else
				exists = TRB.Functions.Profiles:ProfileExistsForSpec(name, data.className, data.specName)
			end
			if exists then
				local captured = data
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_OverwriteConfirm", ScopeLabel(captured), name, captured)
				end)
			else
				ApplyNewProfile(data.scope, data.className, data.specName, name, "current", true)
				if data.refresh then data.refresh() end
			end
		end,
		-- button2 = Use Baseline. OnCancel also fires when the user presses
		-- Escape (hideOnEscape); guard on `reason == "clicked"` so Escape
		-- doesn't accidentally create a baseline profile.
		OnCancel = function(self, data, reason)
			if reason ~= "clicked" then
				return
			end
			local name = self:GetEditBox():GetText() or ""
			name = name:gsub("^%s+", ""):gsub("%s+$", "")
			if name == "" then
				return
			end
			data.attemptedName = name
			data.sourceMode = "baseline"
			local exists
			if data.scope == "core" then
				exists = TRB.Functions.Profiles:ProfileExistsForCore(name)
			else
				exists = TRB.Functions.Profiles:ProfileExistsForSpec(name, data.className, data.specName)
			end
			if exists then
				local captured = data
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_OverwriteConfirm", ScopeLabel(captured), name, captured)
				end)
			else
				ApplyNewProfile(data.scope, data.className, data.specName, name, "baseline", true)
				if data.refresh then data.refresh() end
			end
		end,
		-- button3 = Cancel. No handler needed; popup closes on click.
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			StaticPopup_OnClick(self:GetParent(), 1)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_OverwriteConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		button3 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupOverwriteText"], data and data.attemptedName or "", ScopeLabel(data))
		end,
		OnAccept = function(self, data)
			-- Yes: proceed with overwrite using the chosen source mode.
			ApplyNewProfile(data.scope, data.className, data.specName, data.attemptedName, data.sourceMode or "current", true)
			if data.refresh then data.refresh() end
		end,
		OnCancel = function(self, data)
			-- button2 = No: re-show the name prompt pre-filled with the attempted name.
			if data ~= nil then
				local followup = { scope = data.scope, className = data.className, specName = data.specName, specLabel = data.specLabel, initialName = data.attemptedName, refresh = data.refresh }
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_NewName", nil, nil, followup)
				end)
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_UseConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupUseConfirmText"], data and data.profileName or "", ScopeLabel(data))
		end,
		OnAccept = function(self, data)
			TRB.Functions.Profiles:FlushAndSuppressLogout()
			if data.scope == "core" then
				TRB.Functions.Profiles:SetActiveCoreProfile(data.profileName)
			else
				TRB.Functions.Profiles:SetActiveSpecProfile(data.specName, data.profileName)
			end
			if data.refresh then data.refresh() end
			C_UI.Reload()
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_DeleteConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			local fmt = (data and data.isActive) and L["ProfilePopupDeleteActiveText"] or L["ProfilePopupDeleteInactiveText"]
			self:SetFormattedText(fmt, data and data.profileName or "", ScopeLabel(data))
		end,
		OnAccept = function(self, data)
			if data.scope == "core" then
				TRB.Functions.Profiles:DeleteCoreProfile(data.profileName)
			else
				TRB.Functions.Profiles:DeleteSpecProfile(data.profileName, data.className, data.specName)
			end
			if data.refresh then data.refresh() end
			if data.isActive then
				C_UI.Reload()
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_DeleteReload"] = {
		text = L["ProfilePopupDeleteReloadMessage"],
		button1 = L["OK"],
		OnAccept = function(self)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_CopyName"] = {
		text = "",
		button1 = L["OK"],
		button2 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupCopyText"], data and data.sourceName or "", ScopeLabel(data))
			local eb = self:GetEditBox()
			if eb ~= nil then
				eb:SetText(data and data.initialName or "")
				eb:HighlightText()
				eb:SetAutoFocus(true)
			end
		end,
		OnAccept = function(self, data)
			local name = self:GetEditBox():GetText() or ""
			name = name:gsub("^%s+", ""):gsub("%s+$", "")
			if name == "" or name == data.sourceName then
				return
			end
			data.attemptedName = name
			local exists
			if data.scope == "core" then
				exists = TRB.Functions.Profiles:ProfileExistsForCore(name)
			else
				exists = TRB.Functions.Profiles:ProfileExistsForSpec(name, data.className, data.specName)
			end
			if exists then
				-- Reuse overwrite popup; its OnAccept ApplyNewProfile path doesn't fit here,
				-- so use a distinct copy-overwrite popup via a tailored flow.
				local captured = data
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_CopyOverwriteConfirm", name, ScopeLabel(captured), captured)
				end)
			else
				local ok
				if data.scope == "core" then
					ok = TRB.Functions.Profiles:CopyCoreProfile(data.sourceName, name)
				else
					ok = TRB.Functions.Profiles:CopySpecProfile(data.sourceName, name, data.className, data.specName)
				end
				if data.refresh then data.refresh() end
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			StaticPopup_OnClick(self:GetParent(), 1)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_CopyOverwriteConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		button3 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupOverwriteText"], data and data.attemptedName or "", ScopeLabel(data))
		end,
		OnAccept = function(self, data)
			if data.scope == "core" then
				TRB.Functions.Profiles:CopyCoreProfile(data.sourceName, data.attemptedName)
			else
				TRB.Functions.Profiles:CopySpecProfile(data.sourceName, data.attemptedName, data.className, data.specName)
			end
			if data.refresh then data.refresh() end
		end,
		OnCancel = function(self, data)
			if data ~= nil then
				local followup = { scope = data.scope, className = data.className, specName = data.specName, specLabel = data.specLabel, sourceName = data.sourceName, initialName = data.attemptedName, refresh = data.refresh }
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_CopyName", nil, nil, followup)
				end)
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_RenameName"] = {
		text = "",
		button1 = L["OK"],
		button2 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupRenameText"], data and data.profileName or "", ScopeLabel(data))
			local eb = self:GetEditBox()
			if eb ~= nil then
				eb:SetText(data and (data.initialName or data.profileName) or "")
				eb:HighlightText()
				eb:SetAutoFocus(true)
			end
		end,
		OnAccept = function(self, data)
			local name = self:GetEditBox():GetText() or ""
			name = name:gsub("^%s+", ""):gsub("%s+$", "")
			if name == "" or name == data.profileName then
				return
			end
			local exists
			if data.scope == "core" then
				exists = TRB.Functions.Profiles:ProfileExistsForCore(name)
			else
				exists = TRB.Functions.Profiles:ProfileExistsForSpec(name, data.className, data.specName)
			end
			if exists then
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_RenameCollision", name)
				end)
				return
			end
			local isActive = (name ~= data.profileName) and (GetActiveProfileName(data.scope, data.className, data.specName) == data.profileName)
			if data.scope == "core" then
				TRB.Functions.Profiles:RenameCoreProfile(data.profileName, name)
			else
				TRB.Functions.Profiles:RenameSpecProfile(data.profileName, name, data.className, data.specName)
			end
			if isActive then
				-- Rename of the active profile already updates character refs; no reload needed.
			end
			if data.refresh then data.refresh() end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			StaticPopup_OnClick(self:GetParent(), 1)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_RenameCollision"] = {
		text = "",
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupRenameCollisionText"], data or "")
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportExportStub"] = {
		text = L["ProfilePopupImportExportStubText"],
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}

	-- ------------------------------------------------------------------
	-- Phase 3: Profile Import/Export popups
	-- ------------------------------------------------------------------
	-- Applies a parsed import into profiles.list under the given name.
	-- Writes every valid spec piece and (optionally) the core piece found in
	-- the payload, then shows a success popup that lets the user choose
	-- whether to activate the imported profile and reload.
	local function ApplyImportedProfile(name, parsed, onComplete)
		if type(name) ~= "string" or name == "" or parsed == nil then
			return
		end
		local writtenSpecs = {}
		for _, slot in ipairs(parsed.validSpecs or {}) do
			local piece = parsed.profileBody and parsed.profileBody[slot.className] and parsed.profileBody[slot.className][slot.specName]
			if type(piece) == "table" then
				TRB.Functions.Profiles:CreateSpecProfile(name, slot.className, slot.specName, piece)
				table.insert(writtenSpecs, { className = slot.className, specName = slot.specName })
			end
		end
		local wroteCore = false
		if parsed.hasCore and type(parsed.profileBody.core) == "table" then
			TRB.Functions.Profiles:CreateCoreProfile(name, parsed.profileBody.core)
			wroteCore = true
		end

		-- Normalise the imported entry against the current settings schema so
		-- cross-version imports land in a shape the rest of the addon expects.
		local p = TRB.Data.settings and TRB.Data.settings.profiles
		if p ~= nil and p.list ~= nil and p.list[name] ~= nil then
			if TRB.Functions.Settings and TRB.Functions.Settings.PortForwardProfile then
				TRB.Functions.Settings:PortForwardProfile(p.list[name])
			end
		end

		TRB.Functions.Profiles:InvalidateCache()
		C_Timer.After(0, function()
			if type(onComplete) == "function" then
				onComplete(name)
			end
			-- If any slot we just wrote is the currently-active profile for
			-- this character, the runtime content has changed under us; a
			-- reload is mandatory and the "do you want to start using this
			-- profile" prompt would be misleading (they're already on it).
			local reloadRequired = false
			if wroteCore and TRB.Functions.Profiles:ResolveCoreProfileName() == name then
				reloadRequired = true
			end
			if not reloadRequired then
				for _, slot in ipairs(writtenSpecs) do
					if TRB.Functions.Profiles:ResolveSpecProfileName(slot.className, slot.specName) == name then
						reloadRequired = true
						break
					end
				end
			end
			if reloadRequired then
				-- The imported profile name matches the currently-active
				-- profile for this character. Do NOT call FlushActive here:
				-- the live runtime has not picked up the imported contents
				-- yet, so flushing would DeepCopy stale runtime over the
				-- freshly-written profile and destroy the import. Just
				-- suppress the PLAYER_LOGOUT flush and reload.
				TRB.Functions.Profiles:SuppressLogoutFlush()
				StaticPopup_Show("TwintopResourceBar_Profile_ImportReload", nil, nil, name)
				return
			end
			StaticPopup_Show("TwintopResourceBar_Profile_ImportSuccess", nil, nil, {
				profileName = name,
				writtenSpecs = writtenSpecs,
				wroteCore = wroteCore,
			})
		end)
	end

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportSuccess"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupImportSuccessText"], (data and data.profileName) or "")
		end,
		OnAccept = function(self, data)
			if data == nil then return end
			local p = TRB.Data.settings and TRB.Data.settings.profiles
			if p == nil then
				C_UI.Reload()
				return
			end
			-- Activate the imported profile for every slot the payload covered.
			-- Current character gets direct overrides (so the reload picks up
			-- the new active profile immediately). Class/spec defaults are also
			-- updated so other characters of those classes inherit the import.
			TRB.Functions.Profiles:FlushAndSuppressLogout()
			if data.wroteCore then
				TRB.Functions.Profiles:SetActiveCoreProfile(data.profileName)
				p.default.core = data.profileName
			end
			if data.writtenSpecs ~= nil then
				for _, slot in ipairs(data.writtenSpecs) do
					TRB.Functions.Profiles:SetActiveSpecProfile(slot.specName, data.profileName)
					p.default[slot.className] = p.default[slot.className] or {}
					p.default[slot.className][slot.specName] = data.profileName
				end
			end
			C_UI.Reload()
		end,
	}

	-- Shown when an imported profile's name matches the currently-active
	-- profile for this character. The active profile's contents have just
	-- changed under the runtime, so a reload is mandatory.
	StaticPopupDialogs["TwintopResourceBar_Profile_ImportReload"] = {
		text = "",
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupImportReloadText"], data or "")
		end,
		OnAccept = function()
			C_UI.Reload()
		end,
		OnCancel = function()
			C_UI.Reload()
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ExportIncludeCore"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		button3 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfilePopupExportIncludeCoreTargetText"], ExportPieceLabel(data), (data and data.profileName) or "")
		end,
		OnAccept = function(self, data)
			if data == nil then return end
			local output, err
			if data.specId ~= nil then
				output, err = TRB.Functions.IO:ExportSpecProfile(data.profileName, data.classId, data.specId, true)
			else
				output, err = TRB.Functions.IO:ExportClassProfile(data.profileName, data.classId, true)
			end
			if output == nil then
				local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
				end)
				return
			end
			local exportData = {
				message = string.format(L["ProfileExportMessageTargetFormat"], ExportPieceLabel(data), data.profileName),
				exportString = output,
			}
			C_Timer.After(0, function()
				StaticPopup_Show("TwintopResourceBar_Export", nil, nil, exportData)
			end)
		end,
		OnCancel = function(self, data, reason)
			-- button2 = No (OnCancel fires with reason=="clicked"). Escape also
			-- triggers OnCancel; treat only explicit No as "export without core".
			if reason ~= "clicked" then return end
			if data == nil then return end
			local output, err
			if data.specId ~= nil then
				output, err = TRB.Functions.IO:ExportSpecProfile(data.profileName, data.classId, data.specId, false)
			else
				output, err = TRB.Functions.IO:ExportClassProfile(data.profileName, data.classId, false)
			end
			if output == nil then
				local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
				end)
				return
			end
			local exportData = {
				message = string.format(L["ProfileExportMessageTargetFormat"], ExportPieceLabel(data), data.profileName),
				exportString = output,
			}
			C_Timer.After(0, function()
				StaticPopup_Show("TwintopResourceBar_Export", nil, nil, exportData)
			end)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportPaste"] = {
		text = L["ProfileImportPastePrompt"],
		button1 = L["Import"],
		button2 = L["Cancel"],
		hasEditBox = true,
		hasWideEditBox = true,
		editBoxWidth = 500,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnAccept = function(self)
			local text = self:GetEditBox():GetText() or ""
			local parsed, err = TRB.Functions.IO:ParseProfileImport(text)
			local popupData = self.data
			if parsed == nil then
				local msg
				if err == -6 then
					msg = L["ProfileImportErrorMultipleProfiles"]
				elseif err == -7 then
					msg = L["ProfileImportErrorEmptyWrapper"]
				elseif err == -4 then
					msg = L["ProfileImportErrorNoValid"]
				elseif err == -1 or err == -2 or err == -3 then
					msg = L["ProfileImportErrorDecode"]
				else
					msg = L["ProfileImportErrorGeneric"]
				end
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
				end)
				return
			end
			local nameData = {
				parsed = parsed,
				initialName = parsed.suggestedName or "",
				onComplete = popupData and popupData.onComplete,
			}
			-- Explicitly hide the paste popup and defer the name popup so WoW's
			-- StaticPopup slot is fully free. A 0-frame C_Timer.After was not
			-- enough to avoid slot collisions; bump to a small positive delay.
			StaticPopup_Hide("TwintopResourceBar_Profile_ImportPaste")
			C_Timer.After(0.05, function()
				StaticPopup_Show("TwintopResourceBar_Profile_ImportName", nil, nil, nameData)
			end)
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportName"] = {
		text = L["ProfileImportNamePrompt"],
		button1 = L["OK"],
		button2 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			local eb = self:GetEditBox()
			if eb ~= nil then
				eb:SetText((data and data.initialName) or "")
				eb:HighlightText()
				eb:SetAutoFocus(true)
			end
		end,
		OnAccept = function(self, data)
			if data == nil or data.parsed == nil then return end
			local name = self:GetEditBox():GetText() or ""
			name = name:gsub("^%s+", ""):gsub("%s+$", "")
			if name == "" then
				return
			end

			-- Detect per-slot collisions with existing stored pieces.
			local collisions = {}
			for _, slot in ipairs(data.parsed.validSpecs or {}) do
				if TRB.Functions.Profiles:ProfileExistsForSpec(name, slot.className, slot.specName) then
					collisions[#collisions + 1] = GetImportSlotDisplayLabel(slot.className, slot.specName)
				end
			end
			if data.parsed.hasCore and TRB.Functions.Profiles:ProfileExistsForCore(name) then
				collisions[#collisions + 1] = L["ProfileScopeLabelGlobal"]
			end

			if #collisions > 0 then
				local confirmData = {
					parsed = data.parsed,
					attemptedName = name,
					collisionList = table.concat(collisions, ", "),
					onComplete = data.onComplete,
				}
				C_Timer.After(0, function()
					StaticPopup_Show("TwintopResourceBar_Profile_ImportOverwriteConfirm", nil, nil, confirmData)
				end)
			else
				ApplyImportedProfile(name, data.parsed, data.onComplete)
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			-- WoW's StaticPopup_OnClick(self, "accept") is the correct way to
			-- trigger button1 from an edit box.  Calling parent.OnAccept directly
			-- bypasses StaticPopup's data-passing and cleanup logic.
			StaticPopup_OnClick(parent, 1)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportOverwriteConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		button3 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfileImportOverwriteConfirmPrompt"], (data and data.attemptedName) or "", (data and data.collisionList) or "")
		end,
		OnAccept = function(self, data)
			if data == nil then return end
			ApplyImportedProfile(data.attemptedName, data.parsed, data.onComplete)
		end,
		OnCancel = function(self, data, reason)
			if reason ~= "clicked" then return end
			if data == nil then return end
			-- button2 = No: re-prompt for a new name with the previous name prefilled.
			local nameData = {
				parsed = data.parsed,
				initialName = data.attemptedName,
				onComplete = data.onComplete,
			}
			C_Timer.After(0, function()
				StaticPopup_Show("TwintopResourceBar_Profile_ImportName", nil, nil, nameData)
			end)
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_ImportError"] = {
		text = "",
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText("%s", (data and data.message) or L["ProfileImportErrorGeneric"])
		end,
	}

	-- ── Bar-wide (whole-profile) management dialogs ────────────────────────

	StaticPopupDialogs["TwintopResourceBar_Profile_DeleteProfile_Confirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			if data and data.profileName == TRB.Functions.Profiles.DEFAULT_NAME then
				self:SetFormattedText("%s", L["ProfileManagerResetDefaultConfirm"])
			else
				self:SetFormattedText(L["ProfileManagerDeleteProfileConfirm"], (data and data.profileName) or "")
			end
		end,
		OnAccept = function(self)
			local data = self.data
			if data and data.profileName then
				local Profiles = TRB.Functions.Profiles
				local reloadRequired = Profiles:ShouldReloadAfterProfileRemoval(data.profileName)
				local didDelete = Profiles:DeleteProfile(data.profileName)
				if didDelete and reloadRequired then
					Profiles:SuppressLogoutFlush()
					C_UI.Reload()
					return
				end
				if didDelete and data.onComplete then
					data.onComplete()
				end
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_DeletePiece_Confirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			if data then
				local isDefault = data.profileName == TRB.Functions.Profiles.DEFAULT_NAME
				if data.specName then
					if isDefault then
						self:SetFormattedText(L["ProfileManagerResetPieceConfirm"], data.pieceLabel or data.specName)
					else
						self:SetFormattedText(L["ProfileManagerDeletePieceConfirm"], data.pieceLabel or data.specName, data.profileName or "")
					end
				elseif data.className then
					if isDefault then
						self:SetFormattedText(L["ProfileManagerResetClassConfirm"], data.pieceLabel or data.className)
					else
						self:SetFormattedText(L["ProfileManagerDeleteClassConfirm"], data.pieceLabel or data.className, data.profileName or "")
					end
				elseif data.isCore then
					if isDefault then
						self:SetFormattedText(L["ProfileManagerResetPieceConfirm"], L["ProfileScopeLabelGlobal"])
					else
						self:SetFormattedText(L["ProfileManagerDeletePieceConfirm"], L["ProfileScopeLabelGlobal"], data.profileName or "")
					end
				end
			end
		end,
		OnAccept = function(self)
			local data = self.data
			if data == nil then return end
			local Profiles = TRB.Functions.Profiles
			local reloadRequired = false
			local didDelete = false
			if data.specName then
				reloadRequired = Profiles:ShouldReloadAfterSpecRemoval(data.profileName, data.className, data.specName)
				didDelete = Profiles:DeleteSpecProfile(data.profileName, data.className, data.specName)
			elseif data.className then
				reloadRequired = Profiles:ShouldReloadAfterClassRemoval(data.profileName, data.className)
				didDelete = Profiles:DeleteClassFromProfile(data.profileName, data.className)
			elseif data.isCore then
				reloadRequired = Profiles:ShouldReloadAfterCoreRemoval(data.profileName)
				didDelete = Profiles:DeleteCoreProfile(data.profileName)
			end
			if didDelete and reloadRequired then
				Profiles:SuppressLogoutFlush()
				C_UI.Reload()
				return
			end
			if didDelete and data.onComplete then
				data.onComplete()
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_RenameBarWide_Name"] = {
		text = "",
		button1 = L["ProfileManagerButtonRename"],
		button2 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:GetEditBox():SetText((data and data.profileName) or "")
			self:GetEditBox():SetAutoFocus(true)
			self:GetEditBox():HighlightText()
			self:SetFormattedText(L["ProfileManagerRenameBarWidePrompt"], (data and data.profileName) or "")
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			local text = self:GetText()
			if type(text) == "string" and text ~= "" then
				StaticPopup_OnClick(parent, 1)
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		OnAccept = function(self)
			local data = self.data
			local newName = self:GetEditBox():GetText()
			if type(newName) ~= "string" or newName == "" then return end
			newName = newName:match("^%s*(.-)%s*$")
			local p = TRB.Data.settings and TRB.Data.settings.profiles
			if p and p.list and p.list[newName] ~= nil then
				local d = StaticPopup_Show("TwintopResourceBar_Profile_RenameBarWide_Collision", nil, nil,
					{ profileName = data and data.profileName, collidingName = newName, onComplete = data and data.onComplete })
				-- d may be nil if max popups are showing; ignore
			else
				TRB.Functions.Profiles:RenameProfileBarWide(data and data.profileName, newName)
				if data and data.onComplete then data.onComplete(newName) end
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_RenameBarWide_Collision"] = {
		text = "",
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfileManagerRenameBarWideCollision"], (data and data.collidingName) or "")
		end,
		OnAccept = function(self)
			local data = self.data
			StaticPopup_Show("TwintopResourceBar_Profile_RenameBarWide_Name", nil, nil,
				{ profileName = data and data.profileName, onComplete = data and data.onComplete })
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_CopyBarWide_Name"] = {
		text = "",
		button1 = L["ProfileManagerButtonCopy"],
		button2 = L["Cancel"],
		hasEditBox = true,
		editBoxWidth = 260,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			local suffix = L["ProfileCopyNameSuffix"]
			self:GetEditBox():SetText(((data and data.profileName) or "") .. " " .. suffix)
			self:GetEditBox():SetAutoFocus(true)
			self:GetEditBox():HighlightText()
			self:SetFormattedText(L["ProfileManagerCopyBarWidePrompt"], (data and data.profileName) or "")
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			local text = self:GetText()
			if type(text) == "string" and text ~= "" then
				StaticPopup_OnClick(parent, 1)
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		OnAccept = function(self)
			local data = self.data
			local newName = self:GetEditBox():GetText()
			if type(newName) ~= "string" or newName == "" then return end
			newName = newName:match("^%s*(.-)%s*$")
			local p = TRB.Data.settings and TRB.Data.settings.profiles
			if p and p.list and p.list[newName] ~= nil then
				StaticPopup_Show("TwintopResourceBar_Profile_CopyBarWide_OverwriteConfirm", nil, nil, {
					srcName = data and data.profileName,
					dstName = newName,
					mode = data and data.mode,
					selection = data and data.selection,
					onComplete = data and data.onComplete,
				})
			else
				if data and data.mode == "full" then
					TRB.Functions.Profiles:CopyProfileFull(data.profileName, newName)
				else
					TRB.Functions.Profiles:CopyProfileSelection(data and data.profileName, newName, (data and data.selection) or {})
				end
				if data and data.onComplete then data.onComplete(newName) end
			end
		end,
	}

	StaticPopupDialogs["TwintopResourceBar_Profile_CopyBarWide_OverwriteConfirm"] = {
		text = "",
		button1 = L["Yes"],
		button2 = L["No"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		OnShow = function(self, data)
			self:SetFormattedText(L["ProfileManagerCopyBarWideOverwrite"], (data and data.dstName) or "")
		end,
		OnAccept = function(self)
			local data = self.data
			if data == nil then return end
			if data.mode == "full" then
				TRB.Functions.Profiles:CopyProfileFull(data.srcName, data.dstName)
			else
				TRB.Functions.Profiles:CopyProfileSelection(data.srcName, data.dstName, data.selection or {})
			end
			if data.onComplete then data.onComplete(data.dstName) end
		end,
	}
end

---@param onComplete function? # Optional callback invoked after a profile import is written and caches are invalidated.
function TRB.Functions.OptionsUi:ShowProfileImportPopup(onComplete)
	EnsureProfilePopupsRegistered()
	StaticPopup_Show("TwintopResourceBar_Profile_ImportPaste", nil, nil, {
		onComplete = onComplete,
	})
end

---Builds a profile-management dropdown anchored to the top-right of `parent`.
---Used by both `BuildSpecTitleRow` (spec scope) and Global Options (core scope).
---@param parent Frame
---@param yCoord number # vertical offset from parent's top-right
---@param scope "spec"|"core"
---@param className string? # required when scope=="spec"
---@param specName string? # required when scope=="spec"
---@param specLabel string? # localized label used in popup text for spec scope
---@return DropdownButton dropdown
function TRB.Functions.OptionsUi:BuildProfileDropdown(parent, yCoord, scope, className, specName, specLabel)
	EnsureProfilePopupsRegistered()

	local namePrefix = "TwintopResourceBar_ProfileDropdown"
	if scope == "spec" then
		namePrefix = namePrefix .. "_" .. tostring(className) .. "_" .. tostring(specName)
	else
		namePrefix = namePrefix .. "_Core"
	end

	local dropdown = CreateFrame("DropdownButton", namePrefix, parent, "WowStyle1DropdownTemplate")
	dropdown:ClearAllPoints()
	dropdown:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, yCoord)
	dropdown:SetWidth(240)

	local function RefreshDropdown()
		if dropdown.UpdateButtonText then
			dropdown:UpdateButtonText()
		end
		-- Re-register the generator so the next open rebuilds the menu with
		-- the latest cached profile list.
		if dropdown.SetupMenu and dropdown.GeneratorFunction then
			dropdown:SetupMenu(dropdown.GeneratorFunction)
		end
	end

	local function MakeBaseData()
		return {
			scope = scope,
			className = className,
			specName = specName,
			specLabel = specLabel,
			pieceLabel = (scope == "core") and L["ProfileScopeLabelGlobal"] or specLabel,
			refresh = RefreshDropdown,
		}
	end

	local function OnNewClicked()
		local data = MakeBaseData()
		data.initialName = ""
		StaticPopup_Show("TwintopResourceBar_Profile_NewName", nil, nil, data)
	end

	local function OnImportClicked()
		TRB.Functions.OptionsUi:ShowProfileImportPopup()
	end

	local function OnUseClicked(profileName)
		local data = MakeBaseData()
		data.profileName = profileName
		StaticPopup_Show("TwintopResourceBar_Profile_UseConfirm", nil, nil, data)
	end

	local function OnCopyClicked(profileName)
		local data = MakeBaseData()
		data.sourceName = profileName
		data.initialName = profileName .. " " .. L["ProfileCopyNameSuffix"]
		StaticPopup_Show("TwintopResourceBar_Profile_CopyName", nil, nil, data)
	end

	local function OnCopyToProfileClicked(sourceName, destinationName)
		if sourceName == nil or destinationName == nil or sourceName == destinationName then
			return
		end

		local data = MakeBaseData()
		data.sourceName = sourceName
		data.attemptedName = destinationName

		local exists
		if data.scope == "core" then
			exists = TRB.Functions.Profiles:ProfileExistsForCore(destinationName)
		else
			exists = TRB.Functions.Profiles:ProfileExistsForSpec(destinationName, data.className, data.specName)
		end

		if exists then
			StaticPopup_Show("TwintopResourceBar_Profile_CopyOverwriteConfirm", destinationName, ScopeLabel(data), data)
			return
		end

		local ok
		if data.scope == "core" then
			ok = TRB.Functions.Profiles:CopyCoreProfile(sourceName, destinationName)
		else
			ok = TRB.Functions.Profiles:CopySpecProfile(sourceName, destinationName, data.className, data.specName)
		end
		if ok and data.refresh then
			data.refresh()
		end
	end

	local function OnRenameClicked(profileName)
		local data = MakeBaseData()
		data.profileName = profileName
		data.initialName = profileName
		StaticPopup_Show("TwintopResourceBar_Profile_RenameName", nil, nil, data)
	end

	local function OnDeleteClicked(profileName)
		local data = MakeBaseData()
		data.profileName = profileName
		data.isActive = (GetActiveProfileName(scope, className, specName) == profileName)
		StaticPopup_Show("TwintopResourceBar_Profile_DeleteConfirm", nil, nil, data)
	end

	local function OnExportClicked(profileName)
		if scope == "core" then
			local data = MakeBaseData()
			data.profileName = profileName
			local output, err = TRB.Functions.IO:ExportCoreProfile(profileName)
			if output == nil then
				local msg = (err == -2) and L["ProfileImportErrorEmpty"] or L["ProfileImportErrorGeneric"]
				StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = msg })
				return
			end
			StaticPopup_Show("TwintopResourceBar_Export", nil, nil, {
				message = string.format(L["ProfileExportMessageTargetFormat"], data.pieceLabel or L["ProfileScopeLabelGlobal"], profileName),
				exportString = output,
			})
		else
			local classId, specId = TRB.Functions.IO:GetClassSpecIdsByName(className, specName)
			if classId == nil or specId == nil then
				StaticPopup_Show("TwintopResourceBar_Profile_ImportError", nil, nil, { message = L["ProfileImportErrorGeneric"] })
				return
			end
			local data = MakeBaseData()
			data.profileName = profileName
			data.classId = classId
			data.specId = specId
			StaticPopup_Show("TwintopResourceBar_Profile_ExportIncludeCore", nil, nil, data)
		end
	end

	local function Generator(_, rootDescription)
		rootDescription:CreateTitle(L["ProfileMenuHeaderManage"])
		rootDescription:CreateButton(L["ProfileMenuNewProfile"], OnNewClicked)
		rootDescription:CreateButton(L["ProfileMenuImportProfile"], OnImportClicked)
		rootDescription:CreateDivider()
		rootDescription:CreateTitle(L["ProfileMenuHeaderProfiles"])

		local activeName = GetActiveProfileName(scope, className, specName)
		local names = GetProfileList(scope, className, specName)
		for _, profileName in ipairs(names) do
			local displayName = profileName
			if profileName == activeName then
				displayName = "|cff00ff00" .. profileName .. "|r"
			end
			local submenu = rootDescription:CreateButton(displayName)
			if type(submenu) == "table" and type(submenu.CreateButton) == "function" then
				local useButton = submenu:CreateButton(L["ProfileActionUse"], function()
					OnUseClicked(profileName)
				end)
				if profileName == activeName and type(useButton) == "table" and type(useButton.SetEnabled) == "function" then
					useButton:SetEnabled(false)
				end
				local copySubmenu = submenu:CreateButton(L["ProfileActionCopyMenu"])
				if type(copySubmenu) == "table" and type(copySubmenu.CreateButton) == "function" then
					copySubmenu:CreateButton(L["ProfileActionCopyToNew"], function()
						OnCopyClicked(profileName)
					end)
					local allProfileNames = TRB.Functions.Profiles:GetProfileNames()
					local addedAnyProfileTargets = false
					for _, destinationName in ipairs(allProfileNames) do
						if destinationName ~= profileName then
							if not addedAnyProfileTargets and type(copySubmenu.CreateDivider) == "function" then
								copySubmenu:CreateDivider()
							end
							addedAnyProfileTargets = true
							copySubmenu:CreateButton(destinationName, function()
								OnCopyToProfileClicked(profileName, destinationName)
							end)
						end
					end
				else
					submenu:CreateButton(L["ProfileActionCopyToNew"], function()
						OnCopyClicked(profileName)
					end)
				end
				if profileName ~= TRB.Functions.Profiles.DEFAULT_NAME then
					submenu:CreateButton(L["ProfileActionRename"], function() OnRenameClicked(profileName) end)
					submenu:CreateButton(L["ProfileActionDelete"], function() OnDeleteClicked(profileName) end)
				end
				---@diagnostic disable-next-line: redundant-parameter
				submenu:CreateButton(L["ProfileActionExport"], function() OnExportClicked(profileName) end)
			end
		end
	end

	dropdown.GeneratorFunction = Generator
	dropdown:SetupMenu(Generator)

	-- Apply the inline button label ("Profile: {name}") using the active name.
	local function UpdateButtonText()
		local activeName = GetActiveProfileName(scope, className, specName)
		local text = string.format(L["ProfileDropdownButtonFormat"], activeName)
		if type(dropdown.SetDefaultText) == "function" then
			dropdown:SetDefaultText(text)
		elseif dropdown.Text ~= nil and type(dropdown.Text.SetText) == "function" then
			dropdown.Text:SetText(text)
		end
	end
	dropdown.UpdateButtonText = UpdateButtonText
	UpdateButtonText()

	-- Refresh the button label whenever the menu closes (a CRUD op may have
	-- changed the active profile name).
	dropdown:HookScript("OnHide", UpdateButtonText)

	return dropdown
end

-- Register all profile-related static popup dialogs at load time so they are
-- available even before the first call to BuildProfileDropdown.
EnsureProfilePopupsRegistered()

---Builds the spec title row: header + enabled checkbox + profile dropdown,
---all anchored from the right side of the parent so they stay right-aligned on resize.
---@param parent Frame The spec display panel
---@param controls table The controls table for this spec
---@param specLabel string Localized spec name (e.g. L["PriestDisciplineFull"])
---@param enabledSettingRef table Reference table where .enabled lives (e.g. TRB.Data.settings.core.enabled.priest)
---@param enabledKey string Key into enabledSettingRef (e.g. "discipline")
---@param checkboxName string Global checkbox frame name (e.g. "TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled")
---@param checkboxControlKey string Key in controls.checkBoxes (e.g. "disciplinePriestEnabled")
---@param className string Lowercase class name (e.g. "priest")
---@param specName string Lowercase spec name (e.g. "discipline")
---@return number yCoord The updated yCoord after the title row
function TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, specLabel, enabledSettingRef, enabledKey, checkboxName, checkboxControlKey, className, specName)
	local yCoord = 0

	-- Section header (left-aligned)
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, specLabel, oUi.xCoord, yCoord - 5)

	-- Profile dropdown (rightmost, anchored to parent's top-right)
	controls.profileDropdown = TRB.Functions.OptionsUi:BuildProfileDropdown(parent, yCoord - 10, "spec", className, specName, specLabel)
	local dropdown = controls.profileDropdown

	-- Enabled checkbox (anchored to left of dropdown, with gap for label text)
	controls.checkBoxes[checkboxControlKey] = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
	local cb = controls.checkBoxes[checkboxControlKey]
	getglobal(cb:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	cb.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], specLabel)
	cb:SetChecked(enabledSettingRef[enabledKey])
	cb:SetScript("OnClick", function(self, ...)
		enabledSettingRef[enabledKey] = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)
		if TRB.Options.OptionsFrame then
			TRB.Options.OptionsFrame:RefreshNav()
		end
	end)
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)

	-- Position checkbox: anchor its right edge left of the dropdown, leaving room for the label text.
	cb:SetPoint("RIGHT", dropdown, "LEFT", -75, 0)

	return yCoord - 37
end

---Builds a Label object for the Options UI
---@param parent frame
---@param text string
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param fontObject Font?
---@param hAlign string?
---@return table|Frame
function TRB.Functions.OptionsUi:BuildLabel(parent, text, posX, posY, width, height, fontObject, hAlign)
	if fontObject == nil then
		fontObject = GameFontNormal
	end

	if hAlign == nil or (string.upper(hAlign) ~= "LEFT" and string.upper(hAlign) ~= "CENTER" and string.upper(hAlign) ~= "RIGHT") then
		hAlign = "LEFT"
	end

	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(fontObject)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetJustifyH(hAlign)
	f.font:SetSize(width, height)
	f.font:SetText(text)

	return f
end

---Creates a scroll frame container with a child frame for scrollable options content.
---@param name string # Global frame name for the scroll frame
---@param parent Frame # The parent frame
---@param width number? # Width of the scroll frame (default 560)
---@param height number? # Height of the scroll frame (default 540)
---@param scrollChild Frame? # Optional pre-existing child frame; a new one is created if nil
---@return ScrollFrame
function TRB.Functions.OptionsUi:CreateScrollFrameContainer(name, parent, width, height, scrollChild)
	width = width or 560
	height = height or 540
	local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	sf:SetWidth(width)
	sf:SetHeight(height)
	if scrollChild then
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = scrollChild
	else
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = CreateFrame("Frame")
	end
	sf.scrollChild:SetWidth(width)
	sf.scrollChild:SetHeight(height-10)
	sf:SetScrollChild(sf.scrollChild)
	return sf
end

---Creates a bordered tab content frame with an optional embedded scroll frame.
---@param name string # Global frame name for the container
---@param parent Frame # The parent frame
---@param width number? # Width of the container (nil to fill parent width)
---@param height number? # Height of the container (nil to fill parent height)
---@param isManualScrollFrame boolean? # If true, skips creating the embedded scroll frame
---@return Frame|BackdropTemplate
function TRB.Functions.OptionsUi:CreateTabFrameContainer(name, parent, width, height, isManualScrollFrame)
	local fillParent = (width == nil and height == nil)
	width = width or 652
	height = height or 523
	local cf = CreateFrame("Frame", name, parent, "BackdropTemplate")
	cf:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	})
	cf:SetBackdropColor(0, 0, 0, 0.5)

	if fillParent then
		-- Caller sets TOPLEFT; stretch to bottom-right of parent, mirroring the TOPLEFT x-padding
		cf:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -5, 0)
	else
		cf:SetWidth(width)
		cf:SetHeight(height)
		cf:SetPoint("TOPLEFT", 0, 0)
	end

	if not isManualScrollFrame then
		---@diagnostic disable-next-line: inject-field
		cf.scrollFrame = TRB.Functions.OptionsUi:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8)
		cf.scrollFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -5)
		if fillParent then
			cf.scrollFrame:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", -25, 5)
			-- Keep scrollChild width in sync with the resolved scrollFrame width
			cf.scrollFrame:HookScript("OnSizeChanged", function(self, w, h)
				if self.scrollChild then
					self.scrollChild:SetWidth(w)
				end
			end)
		end
	end
	return cf
end

---Hides every registered Bar Text Variables panel and clears the active panel reference.
function TRB.Functions.OptionsUi:HideAllBarTextVariablesPanels()
	local registry = TRB.Frames.barTextVariablesPanelRegistry
	if registry ~= nil then
		for _, panel in pairs(registry) do
			if panel ~= nil then
				panel:Hide()
			end
		end
	end

	if TRB.Frames.barTextVariablesPanel ~= nil then
		TRB.Frames.barTextVariablesPanel:Hide()
	end

	TRB.Frames.barTextVariablesPanel = nil
end

---Shows the Bar Text Variables panel associated with the given scroll child.
---@param scrollChild Frame|nil
function TRB.Functions.OptionsUi:ActivateBarTextVariablesPanel(scrollChild)
	self:HideAllBarTextVariablesPanels()

	if scrollChild ~= nil and scrollChild.barTextVariablesPanel ~= nil then
		TRB.Frames.barTextVariablesPanel = scrollChild.barTextVariablesPanel
		TRB.Frames.barTextVariablesPanel:Show()
		if TRB.Frames.barTextVariablesPanel.variablesTable ~= nil then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end
end

---Switches the visible tab in a multi-tab options panel, updating visual states and toggling the bar text variables flyout.
---@param self Button # The tab button that was clicked
---@param tabId string # The key of the tab to switch to
function TRB.Functions.OptionsUi:SwitchTab(self, tabId)
	local parent = self:GetParent()
	if parent.lastTab then
		parent.lastTab:Hide()
		local lastTab = parent.tabs[parent.lastTabId]
		lastTab.Text:SetFontObject(TRB.Options.fonts.options.tabNormalSmall)
		lastTab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
		lastTab.bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
	end

	-- Lazy construction: build the tab content on first visit
	if parent.tabConstructors and parent.tabConstructors[tabId] then
		parent.tabConstructors[tabId](parent.tabsheets[tabId].constructorFrame)
		parent.tabConstructors[tabId] = nil
	end

	parent.tabsheets[tabId]:Show()
	local activeTab = parent.tabs[tabId]
	activeTab.Text:SetFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	activeTab:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	activeTab.bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
	parent.lastTab = parent.tabsheets[tabId]
	parent.lastTabId = tabId

	-- Show/hide the Bar Text Variables flyout based on active tab
	if tabId == "barText" then
		-- Swap to the correct spec's variables panel via the tabsheet's scrollChild
		local barTextSheet = parent.tabsheets and parent.tabsheets["barText"]
		local scrollChild = barTextSheet and barTextSheet.scrollFrame and barTextSheet.scrollFrame.scrollChild
		TRB.Functions.OptionsUi:ActivateBarTextVariablesPanel(scrollChild)
	else
		TRB.Functions.OptionsUi:HideAllBarTextVariablesPanels()
		-- Clear active edit box tracking when leaving the Bar Text tab
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
	end
end

---Creates a clickable tab button with hover highlighting, backdrop styling, and a bottom cover for the tab effect.
---@param name string # Global frame name for the tab button
---@param displayText string # Label text shown on the tab
---@param id string # Unique tab identifier key
---@param parent Frame # The parent frame that owns the tab set
---@param width number? # Tab width in pixels (default 100)
---@return Button|BackdropTemplate
function TRB.Functions.OptionsUi:CreateTab(name, displayText, id, parent, width)
	width = width or 100
	local tabHeight = 20
	local tab = CreateFrame("Button", name, parent, "BackdropTemplate")
	---@diagnostic disable-next-line: inject-field
	tab.id = id
	tab:SetSize(width, tabHeight)

	-- Border + background via backdrop
	tab:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

	-- Bottom cover: hides the bottom border to create a tab effect.
	-- Extends slightly below the frame to also cover the top border of what's beneath.
	local bottomCover = tab:CreateTexture(nil, "OVERLAY")
	bottomCover:SetHeight(6)
	bottomCover:SetPoint("BOTTOMLEFT", 1, -1)
	bottomCover:SetPoint("BOTTOMRIGHT", -1, -1)
	bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
	---@diagnostic disable-next-line: inject-field
	tab.bottomCover = bottomCover

	-- Label
	local label = tab:CreateFontString(nil, "OVERLAY")
	label:SetFontObject(TRB.Options.fonts.options.tabNormalSmall)
	label:SetPoint("CENTER", 0, 1)
	label:SetText(displayText)
	---@diagnostic disable-next-line: inject-field
	tab.Text = label

	-- Hover highlight
	tab:SetScript("OnEnter", function(self)
		if parent.lastTabId ~= self.id then
			self:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
			self.bottomCover:SetColorTexture(0.35, 0.35, 0.35, 1.0)
		end
	end)
	tab:SetScript("OnLeave", function(self)
		if parent.lastTabId ~= self.id then
			self:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
			self.bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
		end
	end)

	tab:SetScript("OnClick", function(self)
		TRB.Functions.OptionsUi:SwitchTab(self, self.id)
	end)

	return tab
end

---Switches to a specific tab by key for a given class/spec's options panel.
---@param classId integer
---@param specId integer
---@param tabKey string The tab key to switch to (e.g., "barText", "barDisplay")
function TRB.Functions.OptionsUi:SwitchToTabByClassSpec(classId, specId, tabKey)
	local namePrefix
	if classId == nil then
		namePrefix = "Global"
	else
		local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		namePrefix = className .. "_" .. specName
	end
	local tab = _G["TwintopResourceBar_Options_" .. namePrefix .. "_Tab_" .. tabKey]
	if tab then
		TRB.Functions.OptionsUi:SwitchTab(tab, tab.id)
	end
end

---Switches to the Bar Text tab for a given class/spec. Convenience wrapper around SwitchToTabByClassSpec.
---@param classId integer
---@param specId integer
function TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	TRB.Functions.OptionsUi:SwitchToTabByClassSpec(classId, specId, "barText")
end

---Standard tab key constants used across all options panels.
TRB.Functions.OptionsUi.TabKeys = {
	BarDisplay = "barDisplay",
	Thresholds = "thresholds",
	FontText = "fontText",
	AudioTracking = "audioTracking",
	BarText = "barText",
	Miscellaneous = "miscellaneous",
	ResetDefaults = "resetDefaults",
	EnergyBar = "energyBar",
	StaggerBar = "staggerBar",
	HealthBar = "healthBar",
	BarTextures = "barTextures",
	BarVisibility = "barVisibility",
}

---Builds a dynamic set of tabs and tabsheets for an options panel.
---Tabs automatically wrap to multiple rows when they would exceed the parent frame's width.
---@param parent Frame The parent frame to attach tabs to (e.g., the spec display panel)
---@param namePrefix string The naming prefix (e.g., "Priest_Shadow")
---@param tabDefinitions table[] Ordered list of tab definitions: { [1]=key:string, [2]=label:string, [3]=width:number, [4]=constructor:function(scrollChild) }
---@param yCoord number The starting y coordinate for the tabs row. Will be adjusted internally.
---@return number yCoord The adjusted yCoord after tabs are placed (for further content below if needed)
function TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
	local optionsUiFuncs = TRB.Functions.OptionsUi

	-- Normalize: support both positional { key, label, width, constructor, isManualScrollFrame } and named
	for i, def in ipairs(tabDefinitions) do
		if def[1] == nil and def.key ~= nil then
			def[1] = def.key
			def[2] = def.label
			def[3] = def.width
			def[4] = def.constructor
			def[5] = def.isManualScrollFrame
		end
	end

	local tabs = {}
	local tabsheets = {}
	local tabOrder = {}

	local leftPadding = 15
	local rightPadding = 15
	local tabRowHeight = 20
	local borderOverlap = 0 -- rows overlap by this amount so borders touch
	local tabSpacing = 5 -- horizontal gap between tabs
	local maxWidth = parent:GetWidth() - leftPadding - rightPadding

	-- Pass 1: Break definitions into rows based on available width (accounting for spacing)
	local rows = { {} }
	local rowWidths = { 0 }
	local currentRow = 1

	for i, def in ipairs(tabDefinitions) do
		local width = def[3]
		local numInRow = #rows[currentRow]
		local totalWithNew = rowWidths[currentRow] + width + (numInRow > 0 and tabSpacing or 0)
		if numInRow > 0 and totalWithNew > maxWidth then
			currentRow = currentRow + 1
			rows[currentRow] = {}
			rowWidths[currentRow] = 0
		end
		local n = #rows[currentRow]
		rows[currentRow][n + 1] = def
		rowWidths[currentRow] = rowWidths[currentRow] + width + (n > 0 and tabSpacing or 0)
	end

	local numRows = #rows

	-- Pass 2: Create tabs, distribute extra width evenly, and position left-aligned per row
	for rowIndex, rowDefs in ipairs(rows) do
		local rowY = yCoord - ((rowIndex - 1) * (tabRowHeight - borderOverlap))
		local numTabs = #rowDefs
		local totalSpacing = (numTabs - 1) * tabSpacing
		local baseRowWidth = 0
		for _, def in ipairs(rowDefs) do
			baseRowWidth = baseRowWidth + def[3]
		end
		local extraSpace = maxWidth - baseRowWidth - totalSpacing
		local extraPerTab = math.floor(extraSpace / numTabs)
		local remainder = extraSpace - (extraPerTab * numTabs)

		local prevTab = nil
		for colIndex, def in ipairs(rowDefs) do
			local key = def[1]
			local label = def[2]
			local width = def[3] + extraPerTab + (colIndex <= remainder and 1 or 0)
			local frameName = "TwintopResourceBar_Options_" .. namePrefix .. "_Tab_" .. key
			tabs[key] = optionsUiFuncs:CreateTab(frameName, label, key, parent, width)
			tabOrder[#tabOrder + 1] = key

			if colIndex == 1 then
				tabs[key]:SetPoint("TOPLEFT", parent, "TOPLEFT", leftPadding, rowY)
			else
				tabs[key]:SetPoint("LEFT", prevTab, "RIGHT", tabSpacing, 0)
			end

			prevTab = tabs[key]
		end
	end

	-- Offset yCoord past all tab rows
	yCoord = yCoord - (numRows * tabRowHeight) + ((numRows) * borderOverlap)

	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		local isManual = def[5] or def.isManualScrollFrame
		tabsheets[key] = optionsUiFuncs:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel_" .. key, parent, nil, nil, isManual)
		tabsheets[key]:Hide()
		tabsheets[key]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		---@diagnostic disable-next-line: inject-field
		tabsheets[key].constructorFrame = (not isManual and tabsheets[key].scrollFrame) and tabsheets[key].scrollFrame.scrollChild or tabsheets[key]
	end

	-- Show the first tab by default
	local firstKey = tabOrder[1]
	tabsheets[firstKey]:Show()
	---@diagnostic disable-next-line: inject-field
	tabsheets[firstKey].selected = true
	tabs[firstKey].Text:SetFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	tabs[firstKey]:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	tabs[firstKey].bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
---@diagnostic disable-next-line: inject-field
	parent.tabs = tabs
---@diagnostic disable-next-line: inject-field
	parent.tabsheets = tabsheets
---@diagnostic disable-next-line: inject-field
	parent.lastTab = tabsheets[firstKey]
---@diagnostic disable-next-line: inject-field
	parent.lastTabId = firstKey
---@diagnostic disable-next-line: inject-field
	parent.tabOrder = tabOrder

	-- Store constructors for lazy tab construction.
	-- Only the first (visible) tab is built eagerly; the rest are deferred until first shown.
	---@diagnostic disable-next-line: inject-field
	parent.tabConstructors = {}
	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		local constructor = def[4]
		if constructor then
			parent.tabConstructors[key] = constructor
		end
	end

	-- Eagerly construct only the first tab (it's already visible)
	if firstKey and parent.tabConstructors[firstKey] then
		parent.tabConstructors[firstKey](tabsheets[firstKey].constructorFrame)
		parent.tabConstructors[firstKey] = nil
	end

	return yCoord
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

---Creates a LibSharedMedia dropdown for selecting a statusbar, background, or border texture.
---@param parent Frame # The parent frame
---@param dropDowns table # Table to store the created dropdown control
---@param section table # The settings table containing the current texture selection (e.g., spec.textures)
---@param classId integer # The WoW class ID
---@param specId integer # The WoW specialization ID
---@param xCoord number # X position for the dropdown
---@param yCoord number # Y position for the dropdown label
---@param lsmType string # The LibSharedMedia type ("statusbar", "background", or "border")
---@param varName string # The key in the section table for this texture setting
---@param sectionHeaderText string # Label text displayed above the dropdown
---@param dropdownInfoText string # Informational text for the dropdown (unused in current implementation)
---@param setSelectedFunc function # Callback invoked when a new texture is selected
function TRB.Functions.OptionsUi:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText, setSelectedFunc)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local lsmPairs
	local lsmPairsByName

	if lsmType == "statusbar" then
		FillStatusbarCache()
		lsmPairs = statusbarPairs
		lsmPairsByName = statusbarPairs
	elseif lsmType == "background" then
		FillBackgroundCache()
		lsmPairs = backgroundPairs
		lsmPairsByName = backgroundPairs
	elseif lsmType == "border" then
		FillBorderCache()
		lsmPairs = borderPairs
		lsmPairsByName = borderPairs
	end

	dropDowns[varName] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. varName .. "_" .. lsmType, parent, "WowStyle1DropdownTemplate")
	dropDowns[varName]:SetWidth(oUi.sliderWidth)
	dropDowns[varName].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
	dropDowns[varName].label.font:SetFontObject(GameFontNormal)
	dropDowns[varName].varName = varName
	dropDowns[varName].lsmPairs = lsmPairs
	dropDowns[varName].lsmPairsByName = lsmPairsByName

	local function IsSelected(value)
		return value == section[varName]
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(lsmPairs) do
			local radio = rootDescription:CreateRadio(v[1], IsSelected, setSelectedFunc, v[2])
			radio:AddInitializer(function(button, description, menu)
				local rightTexture = button:AttachTexture()
				rightTexture:SetSize(1, 18)
				rightTexture:SetPoint("RIGHT")
				local fontString = button.fontString

				local bgTexture = button:AttachTexture()
				bgTexture:SetTexture(v[2])
				bgTexture:SetDrawLayer("BACKGROUND")
				bgTexture:SetPoint("LEFT", button.fontString, "LEFT")
				bgTexture:SetPoint("RIGHT", rightTexture, "LEFT")
				bgTexture:SetSize(button.fontString:GetUnboundedStringWidth(), 16)

				-- Ensure text is drawn on top of the texture
				fontString:SetDrawLayer("OVERLAY")

				-- Manual calculation required to accomodate aligned text.
				local pad = 0
				local width = pad + fontString:GetUnboundedStringWidth() + rightTexture:GetWidth()
				local height = 20
				return width, height
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	dropDowns[varName].GeneratorFunction = Generator
	dropDowns[varName]:SetupMenu(Generator)
	dropDowns[varName]:SetPoint("TOPLEFT", xCoord, yCoord-30)
end

---Enables or disables a ChatConfigCheckButton checkbox and grays out its label text when disabled.
---@param checkbox CheckButton # The checkbox frame to toggle
---@param enable boolean # Whether to enable (true) or disable (false) the checkbox
function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(checkbox, enable)
	if enable then
		checkbox:Enable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 1, 1)
	else
		checkbox:Disable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
	end
end

---Enables or disables a slider built with BuildSlider, including its EditBox and labels.
---@param slider Slider # The slider frame returned by BuildSlider
---@param enable boolean # Whether to enable or disable the slider
function TRB.Functions.OptionsUi:ToggleSliderEnabled(slider, enable)
	if enable then
		slider:Enable()
		slider:SetAlpha(1.0)
		slider:EnableMouseWheel(true)
		if slider.EditBox then
			slider.EditBox:Enable()
			slider.EditBox:EnableMouseWheel(true)
		end
		if slider.Plus then
			slider.Plus:Enable()
		end
		if slider.Minus then
			slider.Minus:Enable()
		end
		if slider.Title then
			slider.Title:SetFontObject(GameFontNormal)
		end
		if slider.MinLabel then
			slider.MinLabel:SetFontObject(GameFontHighlightSmall)
		end
		if slider.MaxLabel then
			slider.MaxLabel:SetFontObject(GameFontHighlightSmall)
		end
	else
		slider:Disable()
		slider:SetAlpha(0.5)
		slider:EnableMouseWheel(false)
		if slider.EditBox then
			slider.EditBox:Disable()
			slider.EditBox:EnableMouseWheel(false)
		end
		if slider.Plus then
			slider.Plus:Disable()
		end
		if slider.Minus then
			slider.Minus:Disable()
		end
		if slider.Title then
			slider.Title:SetFontObject(GameFontDisable)
		end
		if slider.MinLabel then
			slider.MinLabel:SetFontObject(GameFontDisableSmall)
		end
		if slider.MaxLabel then
			slider.MaxLabel:SetFontObject(GameFontDisableSmall)
		end
	end
end

---Enables or disables a dropdown button and grays out its section label when disabled.
---@param dropdown Button # The dropdown button frame to toggle
---@param enable boolean # Whether to enable or disable the dropdown
function TRB.Functions.OptionsUi:ToggleDropdownEnabled(dropdown, enable)
	if enable then
		dropdown:Enable()
		dropdown:SetAlpha(1.0)
		if dropdown.label and dropdown.label.font then
			dropdown.label.font:SetFontObject(GameFontNormal)
		end
	else
		dropdown:Disable()
		dropdown:SetAlpha(0.5)
		if dropdown.label and dropdown.label.font then
			dropdown.label.font:SetFontObject(GameFontDisable)
		end
	end
end

---Enables or disables a color picker button and grays out its label when disabled.
---@param colorPicker Button # The color picker button returned by BuildColorPicker
---@param enable boolean # Whether to enable or disable the control
function TRB.Functions.OptionsUi:ToggleColorPickerEnabled(colorPicker, enable)
	if enable then
		if colorPicker.Enable then colorPicker:Enable() end
		colorPicker:SetAlpha(1.0)
		colorPicker:EnableMouse(true)
		if colorPicker.Font then
			colorPicker.Font:SetFontObject(GameFontHighlight)
		end
		if colorPicker.Swatch1 then
			colorPicker.Swatch1:EnableMouse(true)
			colorPicker.DirectionButton:EnableMouse(true)
			if colorPicker.UpdateSwatch2State then colorPicker.UpdateSwatch2State() end
		end
	else
		if colorPicker.Disable then colorPicker:Disable() end
		colorPicker:SetAlpha(0.5)
		colorPicker:EnableMouse(false)
		if colorPicker.Font then
			colorPicker.Font:SetFontObject(GameFontDisable)
		end
		if colorPicker.Swatch1 then
			colorPicker.Swatch1:EnableMouse(false)
			colorPicker.Swatch2:EnableMouse(false)
			colorPicker.DirectionButton:EnableMouse(false)
		end
	end
end

---Sets a checkbox label to green (enabled) or red (disabled) and optionally changes the label text.
---@param checkbox CheckButton # The checkbox frame to style
---@param enable boolean # Whether the checkbox represents an enabled state
---@param changeText boolean? # If true, also changes the label text to "Enabled" or "Disabled"
function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(checkbox, enable, changeText)
	if enable then
		getglobal(checkbox:GetName().."Text"):SetTextColor(0, 1, 0)

		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Enabled"])
		end
	else
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 0, 0)

		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Disabled"])
		end
	end
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
		local globalSettingDef = globalSettingDefinitions[globalSettingKey]
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
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "regenerating", barTypeDef.key)
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
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", barTypeDef.key)
			end)
			f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.bar, self, classId, specId)
			end)
		else
			local barColorValue = type(colorSettings.bar) == "table" and colorSettings.bar.color or colorSettings.bar
			colorControls.bar = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), barColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", barTypeDef.key)
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
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", barTypeDef.key .. "_node")
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
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", barTypeDef.key .. "_node")
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
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", barTypeDef.key .. "_node")
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
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", barTypeDef.key .. "_node")
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
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", barTypeDef.key)
		end)
		yCoord = yCoord - 30
	end

	-- Background Color
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", barTypeDef.key)
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
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, barTypeDef.key)
				end)
				f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings[thresholdKey], self, classId, specId)
				end)
			else
				colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorLabel, colorSettings[thresholdKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
				f = colorControls[thresholdKey]
				f:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, barTypeDef.key)
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
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", barTypeDef.key)
		end)
		yCoord2 = yCoord2 - 30
	end

	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", barTypeDef.key)
		end)
		yCoord2 = yCoord2 - 30
	end

	return math.min(yCoord, yCoord2)
end

---Synchronizes all statusbar texture dropdowns when a texture value changes, respecting texture lock.
---@param controls table Dropdown control references
---@param textures table Texture settings to update
---@param newValue string The new texture value
---@param variable string The texture variable being changed (e.g., "resource", "casting")
---@param includeComboPoints boolean? Whether to sync combo point bar texture
---@param includeManaBar boolean? Whether to sync mana bar texture
---@param customBars TRB.Classes.BarTypeDefinition[]? Custom bar definitions to sync
---@param includeComboPointsCastingOverlay boolean? Whether to sync secondary casting overlay texture
function TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls, textures, newValue, variable, includeComboPoints, includeManaBar, customBars, includeComboPointsCastingOverlay)
	local newName = statusbarPairsByName[newValue]
	if includeComboPoints == nil then
		includeComboPoints = false
	end
	if includeComboPointsCastingOverlay == nil then
		includeComboPointsCastingOverlay = false
	end
	if includeManaBar == nil then
		includeManaBar = false
	end
	if customBars == nil then
		customBars = {}
	end

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	DropdownSetupMenuWrapper(controls[variable.."Bar"])
	if textures.textureLock then
		textures.resourceBar = newValue
		textures.resourceBarName = newName
		DropdownSetupMenuWrapper(controls.resourceBar)

		if includeComboPoints then
			textures.comboPointsBar = newValue
			textures.comboPointsBarName = newName
			DropdownSetupMenuWrapper(controls.comboPointsBar)

			if includeComboPointsCastingOverlay then
				textures.comboPointsCastingBar = newValue
				textures.comboPointsCastingBarName = newName
				DropdownSetupMenuWrapper(controls.comboPointsCastingBar)
			end
		end

		if includeManaBar then
			textures.manaBarBar = newValue
			textures.manaBarBarName = newName
			DropdownSetupMenuWrapper(controls.manaBarBar)
		end

		-- Sync custom bar textures
		for _, barTypeDef in ipairs(customBars) do
			local barKey = barTypeDef.key .. "Bar"
			textures[barKey] = newValue
			textures[barKey .. "Name"] = newName
			DropdownSetupMenuWrapper(controls[barKey])
		end

		textures.healthBar = newValue
		textures.healthBarName = newName
		DropdownSetupMenuWrapper(controls.healthBar)

		textures.castingBar = newValue
		textures.castingBarName = newName
		DropdownSetupMenuWrapper(controls.castingBar)
	end

	TRB.Functions.Character:ResetCaches()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end
end

---Synchronizes all overlay texture dropdowns when an overlay texture value changes, respecting texture lock.
---@param controls table Dropdown control references
---@param textures table Texture settings to update
---@param newValue string The new texture value
---@param variable string The overlay variable being changed (e.g., "absorb", "incomingHeal")
function TRB.Functions.OptionsUi:UpdateOverlayDropdowns(controls, textures, newValue, variable)
	local newName = statusbarPairsByName[newValue]

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	DropdownSetupMenuWrapper(controls[variable.."Bar"])
	if textures.textureLock then
		-- Sync all overlay textures to the changed value.
		textures.absorbBar = newValue
		textures.absorbBarName = newName
		DropdownSetupMenuWrapper(controls.absorbBar)
		textures.incomingHealBar = newValue
		textures.incomingHealBarName = newName
		DropdownSetupMenuWrapper(controls.incomingHealBar)
	end

	TRB.Functions.Character:ResetCaches()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end
end

---Generates the bar textures options panel with statusbar, overlay, border, and background texture dropdowns.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param includeComboPoints boolean? Whether to include combo point bar textures
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@param includeManaBar boolean? Whether to include mana bar textures
---@param customBars TRB.Classes.BarTypeDefinition[]? Custom bar definitions to include
---@param includeComboPointsCastingOverlay boolean? Whether to include secondary casting overlay texture
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString, includeManaBar, customBars, includeComboPointsCastingOverlay)
	if includeComboPoints == nil then
		includeComboPoints = false
	end
	if includeComboPointsCastingOverlay == nil then
		includeComboPointsCastingOverlay = false
	end
	if includeManaBar == nil then
		includeManaBar = false
	end
	if customBars == nil then
		customBars = {}
	end

	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.textBarTexturesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarTexturesHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalTextures = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_textures", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalTextures
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "barTextures")
		f.tooltip = L["CheckboxUseGlobalTooltip_Textures"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textures)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].textures = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				end
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("textures")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "textures")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllTextures", "textures", yCoord)
	end

	controls.dropDown.textures = {}

	yCoord = yCoord - 30

	---Applies a new statusbar texture value and syncs all related dropdowns via UpdateStatusbarDropdowns.
	---@param variable string The texture variable being changed (e.g., "resource", "casting")
	---@param newValue string The new texture value
	local function StatusbarSetValue(variable, newValue)
		TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls.dropDown.textures, spec.textures, newValue, variable, includeComboPoints, includeManaBar, customBars, includeComboPointsCastingOverlay)
	end

	---Applies a new overlay texture value and syncs all related dropdowns via UpdateOverlayDropdowns.
	---@param variable string The overlay variable being changed (e.g., "absorb", "incomingHeal")
	---@param newValue string The new texture value
	local function OverlaySetValue(variable, newValue)
		TRB.Functions.OptionsUi:UpdateOverlayDropdowns(controls.dropDown.textures, spec.textures, newValue, variable)
	end

	---Refreshes bar layout and appearance after a texture option change if editing the active spec.
	local function RefreshBar()
		if not TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			return
		end
		TRB.Functions.Character:ResetCaches()
		if TRB.Frames.barGroups ~= nil then
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	-- ===== BAR TEXTURES SUBSECTION =====
---@diagnostic disable-next-line: param-type-mismatch
	controls.barTexturesSubsection = TRB.Functions.OptionsUi:BuildLabel(parent, L["BarTexturesSectionHeader"], oUi.xCoord, yCoord, 500, 20, GameFontNormalMed2)

	yCoord = yCoord - 20

	-- Row 1: Primary Bar (left), Health Bar (right)
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "resourceBar", L["MainBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("resource", newValue)
		end)

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "castingBar", L["CastingBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("casting", newValue)
		end)

	-- Collect remaining bar texture items, then place in two-column layout (left-to-right fill)
	local barTextureItems = {}
	table.insert(barTextureItems, { key = "healthBar", label = L["HealthBarTexture"], callback = function(newValue) StatusbarSetValue("health", newValue) end })
	if includeComboPoints then
		table.insert(barTextureItems, { key = "comboPointsBar", label = string.format(L["SecondaryBarTexture"], secondaryResourceString), callback = function(newValue) StatusbarSetValue("comboPoints", newValue) end })
		if includeComboPointsCastingOverlay then
			table.insert(barTextureItems, { key = "comboPointsCastingBar", label = string.format(L["SecondaryCastingOverlayTexture"], secondaryResourceString), callback = function(newValue) StatusbarSetValue("comboPointsCasting", newValue) end })
		end
	end
	if includeManaBar then
		table.insert(barTextureItems, { key = "manaBarBar", label = L["ManaBarTexture"], callback = function(newValue) StatusbarSetValue("manaBar", newValue) end })
	end
	for _, barTypeDef in ipairs(customBars) do
		local barKey = barTypeDef.key .. "Bar"
		table.insert(barTextureItems, { key = barKey, label = string.format(L["CustomBarTextureBar"], barTypeDef.displayName), callback = function(newValue) StatusbarSetValue(barTypeDef.key, newValue) end })
	end

	for i, item in ipairs(barTextureItems) do
		if i % 2 == 1 then
			yCoord = yCoord - 60
		end
		local xPos = (i % 2 == 1) and oUi.xCoord or oUi.xCoord2
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "statusbar", item.key, item.label, L["StatusBarTextures"], item.callback)
	end

	yCoord = yCoord - 70

	-- ===== OVERLAY TEXTURES SUBSECTION =====
---@diagnostic disable-next-line: param-type-mismatch
	controls.overlayTexturesSubsection = TRB.Functions.OptionsUi:BuildLabel(parent, L["OverlayTexturesSectionHeader"], oUi.xCoord, yCoord, 500, 20, GameFontNormalMed2)

	yCoord = yCoord - 20

	-- Row 1: Absorb Overlay + Incoming Heal Overlay
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "absorbBar", L["AbsorbBarTexture"], L["StatusBarTextures"],
		function(newValue)
			OverlaySetValue("absorb", newValue)
		end)

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "incomingHealBar", L["IncomingHealBarTexture"], L["StatusBarTextures"],
		function(newValue)
			OverlaySetValue("incomingHeal", newValue)
		end)

	yCoord = yCoord - 70

	-- ===== BORDER TEXTURES SUBSECTION =====
---@diagnostic disable-next-line: param-type-mismatch
	controls.borderTexturesSubsection = TRB.Functions.OptionsUi:BuildLabel(parent, L["BorderTexturesSectionHeader"], oUi.xCoord, yCoord, 500, 20, GameFontNormalMed2)

	yCoord = yCoord - 20

	-- Row 1: Primary Bar (left), Health Bar (right)
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "border", L["BorderTexture"], L["BorderTextures"],
		function(newValue)
			local newName = borderPairsByName[newValue]
			spec.textures.border = newValue
			spec.textures.borderName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.border)

			if spec.textures.textureLock then
				if includeComboPoints then
					spec.textures.comboPointsBorder = newValue
					spec.textures.comboPointsBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
				end
				if includeManaBar then
					spec.textures.manaBarBorder = newValue
					spec.textures.manaBarBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)
				end
				-- Sync custom bar borders
				for _, barTypeDef in ipairs(customBars) do
					local borderKey = barTypeDef.key .. "Border"
					spec.textures[borderKey] = newValue
					spec.textures[borderKey .. "Name"] = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures[borderKey])
				end
				spec.textures.healthBorder = newValue
				spec.textures.healthBorderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)
			end

			RefreshBar()
		end)

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "border", "healthBorder", L["HealthBorderTexture"], L["BorderTextures"],
		function(newValue)
			local newName = borderPairsByName[newValue]
			spec.textures.healthBorder = newValue
			spec.textures.healthBorderName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)

			if spec.textures.textureLock then
				spec.textures.border = newValue
				spec.textures.borderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.border)
				if includeComboPoints then
					spec.textures.comboPointsBorder = newValue
					spec.textures.comboPointsBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
				end
				if includeManaBar then
					spec.textures.manaBarBorder = newValue
					spec.textures.manaBarBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)
				end
				-- Sync custom bar borders
				for _, barTypeDef in ipairs(customBars) do
					local borderKey = barTypeDef.key .. "Border"
					spec.textures[borderKey] = newValue
					spec.textures[borderKey .. "Name"] = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures[borderKey])
				end
			end

			RefreshBar()
		end)


	-- Collect remaining border texture items, then place in two-column layout (left-to-right fill)
	local borderItems = {}
	if includeComboPoints then
		table.insert(borderItems, { key = "comboPointsBorder", label = string.format(L["SecondaryBorderTexture"], secondaryResourceString), callback =
			function(newValue)
				local newName = borderPairsByName[newValue]
				spec.textures.comboPointsBorder = newValue
				spec.textures.comboPointsBorderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)

				if spec.textures.textureLock then
					spec.textures.border = newValue
					spec.textures.borderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.border)
					spec.textures.healthBorder = newValue
					spec.textures.healthBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)
					if includeManaBar then
						spec.textures.manaBarBorder = newValue
						spec.textures.manaBarBorderName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)
					end
					for _, barTypeDef in ipairs(customBars) do
						local bKey = barTypeDef.key .. "Border"
						spec.textures[bKey] = newValue
						spec.textures[bKey .. "Name"] = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures[bKey])
					end
				end

				RefreshBar()
			end })
	end
	if includeManaBar then
		table.insert(borderItems, { key = "manaBarBorder", label = L["ManaBarBorderTexture"], callback =
			function(newValue)
				local newName = borderPairsByName[newValue]
				spec.textures.manaBarBorder = newValue
				spec.textures.manaBarBorderName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)

				if spec.textures.textureLock then
					spec.textures.border = newValue
					spec.textures.borderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.border)
					spec.textures.healthBorder = newValue
					spec.textures.healthBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)
					if includeComboPoints then
						spec.textures.comboPointsBorder = newValue
						spec.textures.comboPointsBorderName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
					end
					for _, barTypeDef in ipairs(customBars) do
						local bKey = barTypeDef.key .. "Border"
						spec.textures[bKey] = newValue
						spec.textures[bKey .. "Name"] = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures[bKey])
					end
				end

				RefreshBar()
			end })
	end
	for _, barTypeDef in ipairs(customBars) do
		local borderKey = barTypeDef.key .. "Border"
		local borderLabel = string.format(L["CustomBarTextureBorder"], barTypeDef.displayName)
		table.insert(borderItems, { key = borderKey, label = borderLabel, callback =
			function(newValue)
				local newName = borderPairsByName[newValue]
				spec.textures[borderKey] = newValue
				spec.textures[borderKey .. "Name"] = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures[borderKey])

				if spec.textures.textureLock then
					spec.textures.border = newValue
					spec.textures.borderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.border)
					spec.textures.healthBorder = newValue
					spec.textures.healthBorderName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)
					if includeComboPoints then
						spec.textures.comboPointsBorder = newValue
						spec.textures.comboPointsBorderName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
					end
					if includeManaBar then
						spec.textures.manaBarBorder = newValue
						spec.textures.manaBarBorderName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)
					end
					for _, otherBarTypeDef in ipairs(customBars) do
						if otherBarTypeDef.key ~= barTypeDef.key then
							local otherBorderKey = otherBarTypeDef.key .. "Border"
							spec.textures[otherBorderKey] = newValue
							spec.textures[otherBorderKey .. "Name"] = newName
							DropdownSetupMenuWrapper(controls.dropDown.textures[otherBorderKey])
						end
					end
				end

				RefreshBar()
			end })
	end

	for i, item in ipairs(borderItems) do
		if i % 2 == 1 then
			yCoord = yCoord - 60
		end
		local xPos = (i % 2 == 1) and oUi.xCoord or oUi.xCoord2
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "border", item.key, item.label, L["BorderTextures"], item.callback)
	end

	yCoord = yCoord - 70

	-- ===== BACKGROUND TEXTURES SUBSECTION =====
---@diagnostic disable-next-line: param-type-mismatch
	controls.backgroundTexturesSubsection = TRB.Functions.OptionsUi:BuildLabel(parent, L["BackgroundTexturesSectionHeader"], oUi.xCoord, yCoord, 500, 20, GameFontNormalMed2)

	yCoord = yCoord - 20

	-- Row 1: Primary Bar (left), Health Bar (right)
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "background", "background", L["BackgroundTexture"], L["BackgroundTextures"],
		function(newValue)
			local newName = backgroundPairsByName[newValue]
			spec.textures.background = newValue
			spec.textures.backgroundName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.background)

			if spec.textures.textureLock then
				if includeComboPoints then
					spec.textures.comboPointsBackground = newValue
					spec.textures.comboPointsBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
				end
				if includeManaBar then
					spec.textures.manaBarBackground = newValue
					spec.textures.manaBarBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)
				end
				-- Sync custom bar backgrounds
				for _, barTypeDef in ipairs(customBars) do
					local bgKey = barTypeDef.key .. "Background"
					spec.textures[bgKey] = newValue
					spec.textures[bgKey .. "Name"] = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures[bgKey])
				end
				spec.textures.healthBackground = newValue
				spec.textures.healthBackgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)
			end

			RefreshBar()
		end)

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "background", "healthBackground", L["HealthBackgroundTexture"], L["BackgroundTextures"],
		function(newValue)
			local newName = backgroundPairsByName[newValue]
			spec.textures.healthBackground = newValue
			spec.textures.healthBackgroundName = newName
			DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)

			if spec.textures.textureLock then
				spec.textures.background = newValue
				spec.textures.backgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.background)
				if includeComboPoints then
					spec.textures.comboPointsBackground = newValue
					spec.textures.comboPointsBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
				end
				if includeManaBar then
					spec.textures.manaBarBackground = newValue
					spec.textures.manaBarBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)
				end
				-- Sync custom bar backgrounds
				for _, barTypeDef in ipairs(customBars) do
					local bgKey = barTypeDef.key .. "Background"
					spec.textures[bgKey] = newValue
					spec.textures[bgKey .. "Name"] = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures[bgKey])
				end
			end

			RefreshBar()
		end)


	-- Collect remaining background texture items, then place in two-column layout (left-to-right fill)
	local bgItems = {}
	if includeComboPoints then
		table.insert(bgItems, { key = "comboPointsBackground", label = string.format(L["SecondaryBackgroundTexture"], secondaryResourceString), callback =
			function(newValue)
				local newName = backgroundPairsByName[newValue]
				spec.textures.comboPointsBackground = newValue
				spec.textures.comboPointsBackgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)

				if spec.textures.textureLock then
					spec.textures.background = newValue
					spec.textures.backgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.background)
					spec.textures.healthBackground = newValue
					spec.textures.healthBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)
					if includeManaBar then
						spec.textures.manaBarBackground = newValue
						spec.textures.manaBarBackgroundName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)
					end
					for _, barTypeDef in ipairs(customBars) do
						local bKey = barTypeDef.key .. "Background"
						spec.textures[bKey] = newValue
						spec.textures[bKey .. "Name"] = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures[bKey])
					end
				end

				RefreshBar()
			end })
	end
	if includeManaBar then
		table.insert(bgItems, { key = "manaBarBackground", label = L["ManaBarBackgroundTexture"], callback =
			function(newValue)
				local newName = backgroundPairsByName[newValue]
				spec.textures.manaBarBackground = newValue
				spec.textures.manaBarBackgroundName = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)

				if spec.textures.textureLock then
					spec.textures.background = newValue
					spec.textures.backgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.background)
					spec.textures.healthBackground = newValue
					spec.textures.healthBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)
					if includeComboPoints then
						spec.textures.comboPointsBackground = newValue
						spec.textures.comboPointsBackgroundName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
					end
					for _, barTypeDef in ipairs(customBars) do
						local bKey = barTypeDef.key .. "Background"
						spec.textures[bKey] = newValue
						spec.textures[bKey .. "Name"] = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures[bKey])
					end
				end

				RefreshBar()
			end })
	end
	for _, barTypeDef in ipairs(customBars) do
		local bgKey = barTypeDef.key .. "Background"
		local bgLabel = string.format(L["CustomBarTextureBackground"], barTypeDef.displayName)
		table.insert(bgItems, { key = bgKey, label = bgLabel, callback =
			function(newValue)
				local newName = backgroundPairsByName[newValue]
				spec.textures[bgKey] = newValue
				spec.textures[bgKey .. "Name"] = newName
				DropdownSetupMenuWrapper(controls.dropDown.textures[bgKey])

				if spec.textures.textureLock then
					spec.textures.background = newValue
					spec.textures.backgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.background)
					spec.textures.healthBackground = newValue
					spec.textures.healthBackgroundName = newName
					DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)
					if includeComboPoints then
						spec.textures.comboPointsBackground = newValue
						spec.textures.comboPointsBackgroundName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
					end
					if includeManaBar then
						spec.textures.manaBarBackground = newValue
						spec.textures.manaBarBackgroundName = newName
						DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)
					end
					for _, otherBarTypeDef in ipairs(customBars) do
						if otherBarTypeDef.key ~= barTypeDef.key then
							local otherBgKey = otherBarTypeDef.key .. "Background"
							spec.textures[otherBgKey] = newValue
							spec.textures[otherBgKey .. "Name"] = newName
							DropdownSetupMenuWrapper(controls.dropDown.textures[otherBgKey])
						end
					end
				end

				RefreshBar()
			end })
	end

	for i, item in ipairs(bgItems) do
		if i % 2 == 1 then
			yCoord = yCoord - 60
		end
		local xPos = (i % 2 == 1) and oUi.xCoord or oUi.xCoord2
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "background", item.key, item.label, L["BackgroundTextures"], item.callback)
	end

	yCoord = yCoord - 70

	-- ===== TEXTURE LOCK CHECKBOX =====
	controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_TextureLock", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.textureLock
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	f:SetChecked(spec.textures.textureLock)
	getglobal(f:GetName() .. 'Text'):SetText(L["TextureLock"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["TextureLockTooltip"]

	f:SetScript("OnClick", function(self, ...)
		spec.textures.textureLock = self:GetChecked()
		if spec.textures.textureLock then
			-- Sync bar textures
			if includeComboPoints then
				spec.textures.comboPointsBar = spec.textures.resourceBar
				spec.textures.comboPointsBarName = spec.textures.resourceBarName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBar)
			end
			if includeManaBar then
				spec.textures.manaBarBar = spec.textures.resourceBar
				spec.textures.manaBarBarName = spec.textures.resourceBarName
				DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBar)
			end
			spec.textures.healthBar = spec.textures.resourceBar
			spec.textures.healthBarName = spec.textures.resourceBarName
			DropdownSetupMenuWrapper(controls.dropDown.textures.healthBar)

			spec.textures.castingBar = spec.textures.resourceBar
			spec.textures.castingBarName = spec.textures.resourceBarName
			DropdownSetupMenuWrapper(controls.dropDown.textures.castingBar)

			-- Sync overlay textures
			spec.textures.absorbBar = spec.textures.resourceBar
			spec.textures.absorbBarName = spec.textures.resourceBarName
			DropdownSetupMenuWrapper(controls.dropDown.textures.absorbBar)
			spec.textures.incomingHealBar = spec.textures.resourceBar
			spec.textures.incomingHealBarName = spec.textures.resourceBarName
			DropdownSetupMenuWrapper(controls.dropDown.textures.incomingHealBar)

			-- Sync border textures
			if includeComboPoints then
				spec.textures.comboPointsBorder = spec.textures.border
				spec.textures.comboPointsBorderName = spec.textures.borderName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBorder)
			end
			if includeManaBar then
				spec.textures.manaBarBorder = spec.textures.border
				spec.textures.manaBarBorderName = spec.textures.borderName
				DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBorder)
			end
			spec.textures.healthBorder = spec.textures.border
			spec.textures.healthBorderName = spec.textures.borderName
			DropdownSetupMenuWrapper(controls.dropDown.textures.healthBorder)

			-- Sync background textures
			if includeComboPoints then
				spec.textures.comboPointsBackground = spec.textures.background
				spec.textures.comboPointsBackgroundName = spec.textures.backgroundName
				DropdownSetupMenuWrapper(controls.dropDown.textures.comboPointsBackground)
			end
			if includeManaBar then
				spec.textures.manaBarBackground = spec.textures.background
				spec.textures.manaBarBackgroundName = spec.textures.backgroundName
				DropdownSetupMenuWrapper(controls.dropDown.textures.manaBarBackground)
			end
			spec.textures.healthBackground = spec.textures.background
			spec.textures.healthBackgroundName = spec.textures.backgroundName
			DropdownSetupMenuWrapper(controls.dropDown.textures.healthBackground)

			-- Sync custom bar textures (using flat keys like staggerBar, staggerBorder, staggerBackground)
			for _, barTypeDef in ipairs(customBars) do
				local barKey = barTypeDef.key .. "Bar"
				local borderKey = barTypeDef.key .. "Border"
				local bgKey = barTypeDef.key .. "Background"

				spec.textures[barKey] = spec.textures.resourceBar
				spec.textures[barKey .. "Name"] = spec.textures.resourceBarName
				DropdownSetupMenuWrapper(controls.dropDown.textures[barKey])

				spec.textures[borderKey] = spec.textures.border
				spec.textures[borderKey .. "Name"] = spec.textures.borderName
				DropdownSetupMenuWrapper(controls.dropDown.textures[borderKey])

				spec.textures[bgKey] = spec.textures.background
				spec.textures[bgKey .. "Name"] = spec.textures.backgroundName
				DropdownSetupMenuWrapper(controls.dropDown.textures[bgKey])
			end

			RefreshBar()
		end
	end)

	return yCoord
end

---Generates the flash/pulse animation options section (alpha, period, enable checkbox).
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID
---@param specId integer? Spec ID
---@param yCoord number Starting Y coordinate
---@param flashAlphaName string Full localized name of the flash event (used in slider labels)
---@param flashAlphaNameShort string Short localized name (used in checkbox text)
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateFlashOptions(parent, controls, spec, classId, specId, yCoord, flashAlphaName, flashAlphaNameShort)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.flashSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FlashSectionHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["FlashAlpha"], flashAlphaName)
	controls.flashAlpha = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.bar.flashAlpha = value
	end)

	title = string.format(L["FlashPeriod"], flashAlphaName)
	controls.flashPeriod = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.05, 2, spec.colors.bar.flashPeriod, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.bar.flashPeriod = value
	end)

	yCoord = yCoord - 50
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_FlashEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.flashEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["FlashBar"], flashAlphaNameShort))
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format(L["FlashBarTooltip"], flashAlphaName)
	f:SetChecked(spec.colors.bar.flashEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.flashEnabled = self:GetChecked()
	end)

	return yCoord
end

---Creates extra Show Bar When threshold options for a specific bar.
---@param displayBarKey string The displayBar key that should expose these options
---@param thresholdTypes table[] Threshold definitions to attach to the bar
---@return table[] thresholdTypes Extra threshold definitions for GenerateBarVisibilityOptions
function TRB.Functions.OptionsUi:CreateBarVisibilityThresholdTypes(displayBarKey, thresholdTypes)
	local results = {}
	for _, thresholdType in ipairs(thresholdTypes or {}) do
		table.insert(results, {
			displayBarKey = displayBarKey,
			barKey = thresholdType.barKey,
			key = thresholdType.key,
			label = thresholdType.label,
			comparisonLabel = thresholdType.comparisonLabel,
			valueLabel = thresholdType.valueLabel,
			isPercent = thresholdType.isPercent,
			header = thresholdType.header,
			maxValue = thresholdType.maxValue,
		})
	end
	return results
end

---Generates the bar visibility options panel with per-bar condition dropdowns, alpha/fade sliders, and smooth checkbox.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param primaryResourceString string? Localized primary resource name
---@param showWhenCategory string? Legacy parameter, no longer used
---@param includeSecondaryVisibility boolean? Whether to include secondary resource bar visibility
---@param secondaryResourceString string? Localized secondary resource name
---@param includeHealthVisibility boolean? Whether to include health bar visibility
---@param includeManaBarVisibility boolean? Whether to include mana bar visibility
---@param customBars TRB.Classes.BarTypeDefinition[]? Custom bar definitions to include
---@param extraThresholdTypes table[]? Extra threshold condition definitions to include for matching bars
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeSecondaryVisibility, secondaryResourceString, includeHealthVisibility, includeManaBarVisibility, customBars, extraThresholdTypes)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_barVisibility"
	local f = nil
	if customBars == nil then
		customBars = {}
	end
	if extraThresholdTypes == nil then
		extraThresholdTypes = {}
	end

	-- Forward-declare so the checkbox OnClick (defined before the table) can call it
	local RefreshTableForGlobalToggle = nil

	---Returns true when this is a spec options panel and the "Use global settings" checkbox is checked for displayBar.
	local function IsUsingGlobalDisplayBar()
		if classId == nil or specId == nil then
			return false
		end
		local lc = string.lower(className)
		return TRB.Data.settings.core.global[lc][specName].displayBar == true
	end

	controls.barDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes = controls.checkBoxes or {}
		controls.checkBoxes.useGlobalDisplayBar = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_displayBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalDisplayBar
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "barVisibility")
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDisplay"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayBar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayBar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				end
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("displayBar")
			if RefreshTableForGlobalToggle then
				RefreshTableForGlobalToggle()
			end
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "displayBar")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayBar", "displayBar", yCoord)
	end

	yCoord = yCoord - 30

	-- Condition definitions for multi-select bar visibility
	local conditionKeys = { "inCombat", "inVehicle", "hasFriendlyTarget", "hasUnfriendlyTarget", "isMountedAny", "isMountedGround", "isSkyriding", "isSteadyFlight", "inGroup", "inRaid", "inInstance", "inDungeon", "inRaidInstance", "inBattleground", "inArena", "inDelve", "isPvpFlagged", "isWarMode" }
	local conditionLabels = {
		inCombat = L["ShowBarVisibilityConditionInCombat"],
		inVehicle = L["ShowBarVisibilityConditionInVehicle"],
		hasFriendlyTarget = L["ShowBarVisibilityConditionFriendlyTarget"],
		hasUnfriendlyTarget = L["ShowBarVisibilityConditionUnfriendlyTarget"],
		isMountedAny = L["ShowBarVisibilityConditionIsMountedAny"],
		isMountedGround = L["ShowBarVisibilityConditionIsMountedGround"],
		isSkyriding = L["ShowBarVisibilityConditionIsSkyriding"],
		isSteadyFlight = L["ShowBarVisibilityConditionIsSteadyFlight"],
		inGroup = L["ShowBarVisibilityConditionInGroup"],
		inRaid = L["ShowBarVisibilityConditionInRaidGroup"],
		inInstance = L["ShowBarVisibilityConditionInInstance"],
		inDungeon = L["ShowBarVisibilityConditionInDungeon"],
		inRaidInstance = L["ShowBarVisibilityConditionInRaidInstance"],
		inBattleground = L["ShowBarVisibilityConditionInBattleground"],
		inArena = L["ShowBarVisibilityConditionInArena"],
		inDelve = L["ShowBarVisibilityConditionInDelve"],
		isPvpFlagged = L["ShowBarVisibilityConditionIsPvpFlagged"],
		isWarMode = L["ShowBarVisibilityConditionIsWarMode"],
	}

	-- Grouped condition sections for the dropdown
	local conditionGroups = {
		{
			title = L["ShowBarVisibilityGroupGeneral"],
			keys = { "inCombat", "inVehicle", "hasFriendlyTarget", "hasUnfriendlyTarget" },
		},
		{
			title = L["ShowBarVisibilityGroupMounting"],
			keys = { "isMountedAny", "isMountedGround", "isSkyriding", "isSteadyFlight" },
		},
		{
			title = L["ShowBarVisibilityGroupSocial"],
			keys = { "inGroup", "inRaid" },
		},
		{
			title = L["ShowBarVisibilityGroupLocation"],
			keys = { "inInstance", "inDungeon", "inRaidInstance", "inDelve", "inArena", "inBattleground" },
		},
		{
			title = L["ShowBarVisibilityGroupPvP"],
			keys = { "isPvpFlagged", "isWarMode" },
		},
	}

	local hideConditionKeys = { "isMountedAny", "isMountedGround", "isMountedFlying", "isSkyriding", "inVehicle", "inPetBattle", "onTaxi" }
	local hideConditionLabels = {
		isMountedAny = L["ShowBarVisibilityConditionIsMountedAny"],
		isMountedGround = L["ShowBarVisibilityConditionIsMountedGround"],
		isMountedFlying = L["ShowBarVisibilityConditionIsSteadyFlight"],
		isSkyriding = L["ShowBarVisibilityConditionIsSkyriding"],
		inVehicle = L["ShowBarVisibilityConditionInVehicle"],
		inPetBattle = L["ShowBarVisibilityConditionInPetBattle"],
		onTaxi = L["ShowBarVisibilityConditionOnTaxi"],
	}
	local hideConditionGroups = {
		{
			title = L["ShowBarVisibilityGroupGeneral"],
			keys = { "inVehicle", "inPetBattle", "onTaxi" },
		},
		{
			title = L["ShowBarVisibilityGroupMounting"],
			keys = { "isMountedAny", "isMountedGround", "isSkyriding", "isMountedFlying" },
		},
	}

	-- Labels for resource/health threshold condition types (used in dropdown and summary)
	-- Ordered array so dropdown items render in a deterministic, logical order.
	local baseThresholdTypes = {
		{ key = "resourcePercent", label = L["BarVisibilityThresholdResourcePercent"], comparisonLabel = L["BarVisibilityThresholdResourcePercentComparison"], valueLabel = L["BarVisibilityThresholdResourcePercentValue"], isPercent = true },
		{ key = "resourceValue",   label = L["BarVisibilityThresholdResourceValue"],   comparisonLabel = L["BarVisibilityThresholdResourceValueComparison"],   valueLabel = L["BarVisibilityThresholdResourceValueValue"],   isPercent = false },
		{ key = "healthPercent",   label = L["BarVisibilityThresholdHealthPercent"],   comparisonLabel = L["BarVisibilityThresholdHealthPercentComparison"],   valueLabel = L["BarVisibilityThresholdHealthPercentValue"],   isPercent = true },
		{ key = "healthValue",     label = L["BarVisibilityThresholdHealthValue"],     comparisonLabel = L["BarVisibilityThresholdHealthValueComparison"],     valueLabel = L["BarVisibilityThresholdHealthValueValue"],     isPercent = false },
	}
	local thresholdTypeDefinitions = {}
	for _, tt in ipairs(baseThresholdTypes) do
		thresholdTypeDefinitions[tt.key] = tt
	end
	for _, tt in ipairs(extraThresholdTypes) do
		thresholdTypeDefinitions[tt.key] = tt
	end

	local function GetThresholdTypesForBarEntry(barEntry)
		local types = {}
		for _, tt in ipairs(baseThresholdTypes) do
			table.insert(types, tt)
		end

		if barEntry ~= nil then
			for _, tt in ipairs(extraThresholdTypes) do
				local matchesDisplayBarKey = tt.displayBarKey == nil or tt.displayBarKey == barEntry.displayBarKey
				local matchesBarKey = tt.barKey == nil or tt.barKey == barEntry.key
				local hasRuntimeDefinition = spec.barVisibilityThresholds ~= nil and spec.barVisibilityThresholds[tt.key] ~= nil
				if matchesDisplayBarKey and matchesBarKey and hasRuntimeDefinition then
					table.insert(types, tt)
				end
			end
		end

		return types
	end

	---Builds a compact summary from a set of boolean conditions.
	---@param selectedLabels string[] The selected condition labels
	---@return string displayName The summary display text
	local function GetConditionDisplayName(selectedLabels)
		if #selectedLabels == 0 then
			return string.format(L["ShowBarVisibilitySelectedCount"], 0)
		end
		if #selectedLabels == 1 then
			return selectedLabels[1]
		end
		return string.format(L["ShowBarVisibilitySelectedCount"], #selectedLabels)
	end

	---Builds a localized summary string describing the show side of a visibility entry.
	---@param entry table The visibility settings entry
	---@return string displayName The show summary display text
	local function GetShowVisibilityDisplayName(entry)
		if entry.neverShow then
			return L["ShowBarVisibilityNever"]
		end
		if entry.alwaysShow then
			return L["ShowBarVisibilityAlways"]
		end
		local conditions = entry.conditions
		if conditions == nil then
			-- Legacy fallback for unmigrated data
			if entry.visibility == "never" then return L["ShowBarVisibilityNever"] end
			if entry.visibility == "combat" then return L["ShowBarVisibilityCombat"] end
			return L["ShowBarVisibilityAlways"]
		end
		local selectedLabels = {}
		for _, key in ipairs(conditionKeys) do
			if conditions[key] then
				table.insert(selectedLabels, conditionLabels[key])
			end
		end
		-- Include resource/health threshold as an additional condition in the summary
		local ct = entry.resourceConditionType
		if ct ~= nil and ct ~= "none" and thresholdTypeDefinitions[ct] ~= nil then
			table.insert(selectedLabels, thresholdTypeDefinitions[ct].label)
		end
		return GetConditionDisplayName(selectedLabels)
	end

	---Counts selected options in the show-condition dropdown.
	---@param entry table The visibility settings entry
	---@return number selectedCount The number of selected show options
	local function GetShowVisibilitySelectedCount(entry)
		if entry.neverShow or entry.alwaysShow then
			return 1
		end

		local conditions = entry.conditions
		if conditions == nil then
			return 1
		end

		local selectedCount = 0
		for _, key in ipairs(conditionKeys) do
			if conditions[key] then
				selectedCount = selectedCount + 1
			end
		end

		local ct = entry.resourceConditionType
		if ct ~= nil and ct ~= "none" then
			selectedCount = selectedCount + 1
		end

		return selectedCount
	end

	---Counts selected options in the hard-hide dropdown.
	---@param entry table The visibility settings entry
	---@return number selectedCount The number of selected hide options
	local function GetHideVisibilitySelectedCount(entry)
		local selectedCount = 0
		local hideConditions = entry.hideConditions
		if hideConditions ~= nil then
			for _, key in ipairs(hideConditionKeys) do
				if hideConditions[key] == true then
					selectedCount = selectedCount + 1
				end
			end
		end
		return selectedCount
	end

	---Builds a count display string using the standard "X Selected" format.
	---@param selectedCount number The number of selected options
	---@return string displayName The count display text
	local function GetSelectedCountDisplayName(selectedCount)
		return string.format(L["ShowBarVisibilitySelectedCount"], selectedCount)
	end

	---Builds the compact show summary used in the visibility table.
	---@param entry table The visibility settings entry
	---@return string displayName The table display text
	local function GetShowVisibilityTableDisplayName(entry)
		if entry.neverShow then
			return L["BarVisibilityTableShowNeverShown"]
		end
		if entry.alwaysShow then
			return L["ShowBarVisibilityAlways"]
		end
		return GetSelectedCountDisplayName(GetShowVisibilitySelectedCount(entry))
	end

	---Builds the compact hard-hide summary used in the visibility table.
	---@param entry table The visibility settings entry
	---@return string displayName The table display text
	local function GetHideVisibilityTableDisplayName(entry)
		return GetSelectedCountDisplayName(GetHideVisibilitySelectedCount(entry))
	end

	---Builds a localized summary string describing the hard-hide side of a visibility entry.
	---@param entry table The visibility settings entry
	---@return string displayName The hide summary display text
	---@return number selectedCount The number of selected hide conditions
	local function GetHideVisibilityDisplayName(entry)
		local selectedLabels = {}
		local hideConditions = entry.hideConditions
		if hideConditions ~= nil then
			for _, key in ipairs(hideConditionKeys) do
				if hideConditions[key] == true then
					table.insert(selectedLabels, hideConditionLabels[key])
				end
			end
		end
		return GetConditionDisplayName(selectedLabels), GetHideVisibilitySelectedCount(entry)
	end

	local dropdownOriginalSetText = setmetatable({}, { __mode = "k" })
	local dropdownGetTextFunc = setmetatable({}, { __mode = "k" })

	---Installs a SetText hook on a dropdown so its display text is always replaced with a custom summary.
	---@param dropdown DropdownButton The dropdown button to hook
	local function InstallDropdownDisplayTextHook(dropdown)
		if dropdownOriginalSetText[dropdown] == nil then
			dropdownOriginalSetText[dropdown] = dropdown.SetText
			dropdown.SetText = function(self, text)
				local originalSetText = dropdownOriginalSetText[self]
				local getTextFunc = dropdownGetTextFunc[self]
				if originalSetText == nil then
					return
				end
				if getTextFunc then
					originalSetText(self, getTextFunc())
				else
					originalSetText(self, text)
				end
			end
		end
	end

	---Updates the display text function for a hooked dropdown and forces an immediate visual refresh.
	---@param dropdown DropdownButton The dropdown button to update
	---@param getTextFunc fun(): string A function that returns the current display text
	local function UpdateDropdownDisplayText(dropdown, getTextFunc)
		dropdownGetTextFunc[dropdown] = getTextFunc
		-- Force an immediate visual refresh via the original SetText
		if dropdownOriginalSetText[dropdown] then
			dropdownOriginalSetText[dropdown](dropdown, getTextFunc())
		end
	end

	---Adds a hover tooltip to a dropdown button.
	---@param dropdown DropdownButton The dropdown button to attach a tooltip to
	---@param tooltipText string The localized tooltip text
	local function SetDropdownTooltip(dropdown, tooltipText)
		dropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltipText, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		dropdown:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end

	---Refreshes the spec/global cache and re-evaluates bar visibility after visibility settings change.
	local function RefreshVisibilitySettings()
		if classId ~= nil and specId ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		else
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	---Refreshes the spec/global cache, reapplies bar appearance, and re-evaluates visibility for changes affecting custom bars.
	local function RefreshVisibilityAndAppearance()
		if classId ~= nil and specId ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				else
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
				end
			end
		else
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	---Populates the show-condition dropdown menu.
	---@param rootDescription table The root menu description to add items to
	---@param entry table The visibility settings entry to read/write conditions on
	---@param thresholdTypesForBar table[] The threshold condition types available for the selected bar
	---@param onChange function Callback invoked after any condition is toggled
	local function BuildShowVisibilityDropdownItems(rootDescription, entry, thresholdTypesForBar, onChange)
		if rootDescription.SetScrollMode then
			rootDescription:SetScrollMode(400)
		end

		entry.conditions = entry.conditions or {}

		rootDescription:CreateCheckbox(
			L["ShowBarVisibilityAlwaysShow"],
			function() return entry.alwaysShow == true end,
			function()
				if entry.alwaysShow then
					entry.alwaysShow = false
				else
					entry.alwaysShow = true
					entry.neverShow = false
				end
				onChange()
			end
		)

		rootDescription:CreateCheckbox(
			L["ShowBarVisibilityNeverShow"],
			function() return entry.neverShow or false end,
			function()
				entry.neverShow = not entry.neverShow
				if entry.neverShow then
					entry.alwaysShow = false
				end
				onChange()
			end
		)

		for _, group in ipairs(conditionGroups) do
			local groupTitle = group.title
			local groupKeys = group.keys
			rootDescription:CreateDivider()
			rootDescription:CreateTitle(groupTitle)
			for _, key in ipairs(groupKeys) do
				local capturedKey = key
				local checkbox = rootDescription:CreateCheckbox(
					conditionLabels[capturedKey],
					function()
						return entry.conditions and entry.conditions[capturedKey] or false
					end,
					function()
						entry.conditions = entry.conditions or {}
						if entry.conditions[capturedKey] then
							entry.conditions[capturedKey] = nil
						else
							entry.conditions[capturedKey] = true
						end
						onChange()
					end
				)
				checkbox:SetEnabled(function() return not entry.neverShow and not entry.alwaysShow end)
			end
		end

		local thresholdHeader = L["BarVisibilityThresholdHeader"]
		for _, tt in ipairs(thresholdTypesForBar) do
			if tt.header ~= nil then
				thresholdHeader = tt.header
				break
			end
		end

		rootDescription:CreateDivider()
		rootDescription:CreateTitle(thresholdHeader)
		for _, tt in ipairs(thresholdTypesForBar) do
			local capturedKey = tt.key
			local capturedLabel = tt.label
			local checkbox = rootDescription:CreateCheckbox(
				capturedLabel,
				function() return entry.resourceConditionType == capturedKey end,
				function()
					if entry.resourceConditionType == capturedKey then
						entry.resourceConditionType = "none"
					else
						entry.resourceConditionType = capturedKey
					end
					onChange()
				end
			)
			checkbox:SetEnabled(function() return not entry.neverShow and not entry.alwaysShow end)
		end
	end

	---Populates the hard-hide dropdown menu.
	---@param rootDescription table The root menu description to add items to
	---@param entry table The visibility settings entry to read/write hide conditions on
	---@param onChange function Callback invoked after any condition is toggled
	local function BuildHideVisibilityDropdownItems(rootDescription, entry, onChange)
		if rootDescription.SetScrollMode then
			rootDescription:SetScrollMode(400)
		end

		entry.hideConditions = entry.hideConditions or TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()

		for groupIndex, group in ipairs(hideConditionGroups) do
			local groupTitle = group.title
			local groupKeys = group.keys
			rootDescription:CreateTitle(groupTitle)
			for _, key in ipairs(groupKeys) do
				local capturedKey = key
				rootDescription:CreateCheckbox(
					hideConditionLabels[capturedKey],
					function()
						return entry.hideConditions and entry.hideConditions[capturedKey] == true
					end,
					function()
						entry.hideConditions = entry.hideConditions or {}
						entry.hideConditions[capturedKey] = not (entry.hideConditions[capturedKey] == true)
						onChange()
					end
				)
			end
			if groupIndex < #hideConditionGroups then
				rootDescription:CreateDivider()
			end
		end
	end

	-- Build list of bar entries for the table
	local barEntries = {}

	local coreDisplayBar = TRB.Data.settings.core.displayBar

	-- Primary bar (always present)
	table.insert(barEntries, {
		key = "primary",
		displayBarKey = "primary",
		label = string.format(L["BarVisibilityBarNamePrimary"], primaryResourceString or L["ResourceMana"]),
		globalLabel = string.format(L["BarVisibilityBarNamePrimary"], L["Resource"]),
		isCustomBar = false,
		isGlobal = (classId ~= nil and coreDisplayBar["primary"] ~= nil),
	})

	-- Health bar
	if includeHealthVisibility and spec.displayBar.health ~= nil then
		table.insert(barEntries, {
			key = "health",
			displayBarKey = "health",
			label = L["BarVisibilityBarNameHealth"],
			globalLabel = L["BarVisibilityBarNameHealth"],
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["health"] ~= nil),
		})
	end

	-- Secondary resource
	if includeSecondaryVisibility then
		table.insert(barEntries, {
			key = "secondary",
			displayBarKey = "secondary",
			label = string.format(L["ShowBarVisibilitySecondary"], secondaryResourceString or L["ResourceComboPoints"]),
			globalLabel = string.format(L["ShowBarVisibilitySecondary"], L["ResourceComboPoints"]),
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["secondary"] ~= nil),
		})
	end

	-- Mana bar (secondary)
	if includeManaBarVisibility and spec.displayBar.mana ~= nil then
		table.insert(barEntries, {
			key = "mana",
			displayBarKey = "mana",
			label = L["BarVisibilityBarNameMana"],
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["mana"] ~= nil),
		})
	end

	-- Custom bars (stagger, defensives, utility, etc.)
	for _, barTypeDef in ipairs(customBars) do
		if spec.displayBar and spec.displayBar[barTypeDef.visibilityKey] ~= nil then
			local globalDisplayName = barTypeDef.displayName
			local registryDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barTypeDef.visibilityKey)
			if registryDef then
				globalDisplayName = registryDef.displayName
			end
			table.insert(barEntries, {
				key = barTypeDef.key,
				displayBarKey = barTypeDef.visibilityKey,
				label = string.format(L["ShowBarVisibilityCustom"], barTypeDef.displayName),
				globalLabel = string.format(L["ShowBarVisibilityCustom"], globalDisplayName),
				isCustomBar = true,
				isGlobal = (classId ~= nil and coreDisplayBar[barTypeDef.visibilityKey] ~= nil),
			})
		end
	end

	-- Create the LibScrollingTable for bar selection
	local columns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = L["BarVisibilityTableHeaderBar"],
			["width"] = 200,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderShow"],
			["width"] = 95,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderAlwaysHide"],
			["width"] = 105,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderSettingsSource"],
			["width"] = 255,
			["align"] = "LEFT",
		},
	}

	controls.barVisibilityContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local bvc = controls.barVisibilityContainer
	bvc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	bvc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	local tableRowCount = math.max(#barEntries, 2)
	bvc:SetHeight(35 + (tableRowCount * 15))

	local barVisibilityTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, tableRowCount, 15, nil, bvc, false, false)

	-- Dynamically resize the Settings Source column to fill available width
	bvc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[4].width
		local newSettingsSourceWidth = math.max(180, w - fixedWidth - 30)
		columns[5].width = newSettingsSourceWidth
		barVisibilityTable:SetDisplayCols(columns)
	end)

	local globalDimColor = { r = 0.5, g = 0.5, b = 0.5, a = 0.7 }

	---Refreshes the scrolling table data from the current bar visibility settings.
	local function SetTableValues()
		local useGlobal = IsUsingGlobalDisplayBar()
		local dataTable = {}
		for _, entry in ipairs(barEntries) do
			local isControlledByGlobal = useGlobal and entry.isGlobal
			local visSettings
			if isControlledByGlobal then
				visSettings = coreDisplayBar[entry.displayBarKey]
			else
				visSettings = spec.displayBar[entry.displayBarKey]
			end
			local showText = ""
			local hideText = ""
			if visSettings then
				showText = GetShowVisibilityTableDisplayName(visSettings)
				hideText = GetHideVisibilityTableDisplayName(visSettings)
			end
			local rowData = {
				cols = {
					{ value = entry.key },
					{ value = entry.label },
					{ value = showText },
					{ value = hideText },
					{ value = (classId == nil or isControlledByGlobal) and (classId ~= nil and entry.globalLabel and string.format(L["BarVisibilitySettingsSourceGlobalNamed"], entry.globalLabel) or L["BarVisibilitySettingsSourceGlobal"]) or L["BarVisibilitySettingsSourceSpec"] },
				}
			}
			if isControlledByGlobal then
				rowData.color = globalDimColor
			end
			table.insert(dataTable, rowData)
		end
		barVisibilityTable:SetData(dataTable)
		barVisibilityTable:EnableSelection(true)
	end

	-- Detail panel below the table
	local detailHeight = 360
	controls.barVisibilityDetail = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarVisibilityDetail", parent, "BackdropTemplate")
	local detailFrame = controls.barVisibilityDetail
	detailFrame:SetPoint("TOPLEFT", bvc, "BOTTOMLEFT", 0, 0)
	detailFrame:SetPoint("TOPRIGHT", bvc, "BOTTOMRIGHT", 0, 0)
	detailFrame:SetHeight(detailHeight)
	detailFrame:Hide()

	local detailYCoord = 0
	local selectedBarKey = nil

	-- Detail panel contents: header, show/hide dropdowns, smooth checkbox, sliders
	local detailHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailFrame, "", oUi.xCoord, detailYCoord)

	detailYCoord = detailYCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.selectedBarVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedBarVisibility", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedBarVisibility:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedBarVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(detailFrame, L["ShowBarVisibilityShowColumnHeader"], oUi.xCoord, detailYCoord)
	controls.dropDown.selectedBarVisibility.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.selectedBarVisibility:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 30)
	InstallDropdownDisplayTextHook(controls.dropDown.selectedBarVisibility)
	SetDropdownTooltip(controls.dropDown.selectedBarVisibility, L["ShowBarVisibilityShowDropdownTooltip"])

	controls.dropDown.selectedHideVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedHideVisibility", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedHideVisibility:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedHideVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(detailFrame, L["ShowBarVisibilityForceHideColumnHeader"], oUi.xCoord2, detailYCoord)
	controls.dropDown.selectedHideVisibility.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.selectedHideVisibility:SetPoint("TOPLEFT", oUi.xCoord2, detailYCoord - 30)
	InstallDropdownDisplayTextHook(controls.dropDown.selectedHideVisibility)
	SetDropdownTooltip(controls.dropDown.selectedHideVisibility, L["ShowBarVisibilityForceHideDropdownTooltip"])

	-- Smooth checkbox (separate row below dropdowns)
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.selectedSmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedSmooth", detailFrame, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.selectedSmooth
	f:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 70)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
	f.tooltip = L["CheckboxSmoothBarTooltip"]

	-- Alpha/fade sliders
	controls.sliders = controls.sliders or {}

	detailYCoord = detailYCoord - 105
	controls.sliders.selectedActiveAlpha = TRB.Functions.OptionsUi:BuildSlider(detailFrame, L["ShowBarVisibilityActiveAlpha"],
		0, 100, 100, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.selectedActiveAlpha.MinLabel:SetText("0%")
	controls.sliders.selectedActiveAlpha.MaxLabel:SetText("100%")

	controls.sliders.selectedInactiveAlpha = TRB.Functions.OptionsUi:BuildSlider(detailFrame, L["ShowBarVisibilityInactiveAlpha"],
		0, 100, 0, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.selectedInactiveAlpha.MinLabel:SetText("0%")
	controls.sliders.selectedInactiveAlpha.MaxLabel:SetText("100%")

	detailYCoord = detailYCoord - 60
	controls.sliders.selectedFadeDuration = TRB.Functions.OptionsUi:BuildSlider(detailFrame, L["ShowBarVisibilityFadeDuration"],
		0, 10, 0, 0.25, 2,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)

	controls.sliders.selectedFadeDelay = TRB.Functions.OptionsUi:BuildSlider(detailFrame, L["ShowBarVisibilityFadeDelay"],
		0, 10, 0, 0.25, 2,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)

	-- Operator labels for the comparison dropdown
	local comparisonOperators = {
		{ operator = ">=", label = L["ComparisonGTE"] },
		{ operator = "<=", label = L["ComparisonLTE"] },
	}

	-- Helper to get display label for an operator
	local function GetComparisonLabel(op)
		for _, entry in ipairs(comparisonOperators) do
			if entry.operator == op then
				return entry.label
			end
		end
		return op
	end

	-- Dynamic controls: comparison dropdown + value slider (hidden when no threshold type selected)
	detailYCoord = detailYCoord - 50
	controls.dropDown.selectedThresholdComparison = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdComparison", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedThresholdComparison:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedThresholdComparison.label = detailFrame:CreateFontString(nil, "OVERLAY")
	controls.dropDown.selectedThresholdComparison.label:SetFontObject(GameFontNormal)
	controls.dropDown.selectedThresholdComparison.label:SetSize(oUi.sliderWidth, 14)
	controls.dropDown.selectedThresholdComparison.label:SetJustifyH("LEFT")
	controls.dropDown.selectedThresholdComparison.label:SetPoint("BOTTOMLEFT", controls.dropDown.selectedThresholdComparison, "TOPLEFT", 0, 6)
	controls.dropDown.selectedThresholdComparison.label:SetText(L["BarVisibilityThresholdComparison"])
	controls.dropDown.selectedThresholdComparison:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 20)
	controls.dropDown.selectedThresholdComparison:Hide()
	controls.dropDown.selectedThresholdComparison.label:Hide()

	detailYCoord = detailYCoord - 10
	controls.sliders.selectedThresholdValue = TRB.Functions.OptionsUi:BuildSlider(detailFrame, L["BarVisibilityThresholdValue"],
		0, 100, 0, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.selectedThresholdValue:Hide()

	local function GetThresholdValueMax(conditionType)
		if conditionType == "healthValue" then
			return 1000000
		end

		local thresholdDefinition = thresholdTypeDefinitions[conditionType]
		if thresholdDefinition ~= nil and type(thresholdDefinition.maxValue) == "number" then
			return thresholdDefinition.maxValue
		end

		local visibilityMaxValue = TRB.Functions.BarVisibility:GetVisibilityThresholdMaxValue(conditionType, spec)
		if visibilityMaxValue ~= nil and visibilityMaxValue > 0 and (conditionType ~= "resourceValue" or primaryResourceString ~= L["ResourceMana"]) then
			return visibilityMaxValue
		end

		if conditionType == "resourceValue" then
			if primaryResourceString == L["ResourceMana"] then
				return 275625
			end
			if spec.maxResource ~= nil and type(spec.maxResource.value) == "number" and spec.maxResource.value > 0 then
				return spec.maxResource.value
			end
			return 100
		end

		return 100
	end

	local function UpdateThresholdControlLabels(conditionType)
		local thresholdDefinition = thresholdTypeDefinitions[conditionType]
		if thresholdDefinition ~= nil then
			controls.dropDown.selectedThresholdComparison.label:SetText(thresholdDefinition.comparisonLabel)
			controls.sliders.selectedThresholdValue.Title:SetText(thresholdDefinition.valueLabel)
		else
			controls.dropDown.selectedThresholdComparison.label:SetText(L["BarVisibilityThresholdComparison"])
			controls.sliders.selectedThresholdValue.Title:SetText(L["BarVisibilityThresholdValue"])
		end
	end

	--- Shows or hides the threshold dynamic controls based on whether a threshold type is selected.
	---@param conditionType string # The current resourceConditionType ("none" or a valid type)
	---@param visSettings table|nil # The selected visibility settings entry
	local function ShowThresholdControls(conditionType, visSettings)
		local hideForOverrides = visSettings ~= nil and (visSettings.neverShow or visSettings.alwaysShow)

		if conditionType ~= "none" and conditionType ~= nil and not hideForOverrides then
			UpdateThresholdControlLabels(conditionType)
			controls.dropDown.selectedThresholdComparison:Show()
			controls.dropDown.selectedThresholdComparison.label:Show()
			controls.sliders.selectedThresholdValue:Show()

			-- Reconfigure slider range based on type
			local thresholdDefinition = thresholdTypeDefinitions[conditionType]
			local isPercent = thresholdDefinition ~= nil and thresholdDefinition.isPercent == true
			if isPercent then
				controls.sliders.selectedThresholdValue:SetMinMaxValues(0, 100)
				controls.sliders.selectedThresholdValue.MinLabel:SetText("0%")
				controls.sliders.selectedThresholdValue.MaxLabel:SetText("100%")
			else
				local maxVal = GetThresholdValueMax(conditionType)
				controls.sliders.selectedThresholdValue:SetMinMaxValues(0, maxVal)
				controls.sliders.selectedThresholdValue.MinLabel:SetText("0")
				controls.sliders.selectedThresholdValue.MaxLabel:SetText(tostring(maxVal))
			end
		else
			controls.dropDown.selectedThresholdComparison:Hide()
			controls.dropDown.selectedThresholdComparison.label:Hide()
			controls.sliders.selectedThresholdValue:Hide()
		end
	end

	---Populates the bar visibility detail panel with controls for the selected bar's visibility settings.
	---@param barKey string The key identifying which bar to display details for
	local function FillDetailPanel(barKey)
		selectedBarKey = barKey
		local barEntry = nil
		for _, e in ipairs(barEntries) do
			if e.key == barKey then
				barEntry = e
				break
			end
		end
		if barEntry == nil then
			detailFrame:Hide()
			return
		end

		local visSettings = spec.displayBar[barEntry.displayBarKey]
		if visSettings == nil then
			detailFrame:Hide()
			return
		end

		-- Update header
		detailHeader.font:SetText(string.format(L["BarVisibilityDetailHeader"], barEntry.label))

		-- Determine if this bar needs the appearance refresh (custom bars)
		local refreshFunc = barEntry.isCustomBar and RefreshVisibilityAndAppearance or RefreshVisibilitySettings

		-- Visibility dropdowns
		local function OnVisibilityChange()
			local displayText = GetShowVisibilityDisplayName(visSettings)
			controls.dropDown.selectedBarVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedBarVisibility:SetText(displayText)
			ShowThresholdControls(visSettings.resourceConditionType or "none", visSettings)
			refreshFunc()
			SetTableValues()
			-- Re-select the current row
			for i, e in ipairs(barEntries) do
				if e.key == barKey then
					barVisibilityTable:SetSelection(i)
					break
				end
			end
		end

		local function OnHideVisibilityChange()
			local displayText = GetHideVisibilityDisplayName(visSettings)
			controls.dropDown.selectedHideVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedHideVisibility:SetText(displayText)
			refreshFunc()
			SetTableValues()
			-- Re-select the current row
			for i, e in ipairs(barEntries) do
				if e.key == barKey then
					barVisibilityTable:SetSelection(i)
					break
				end
			end
		end

		local function VisibilityGenerator(dropdown, rootDescription)
			BuildShowVisibilityDropdownItems(rootDescription, visSettings, GetThresholdTypesForBarEntry(barEntry), OnVisibilityChange)
		end

		local function HideVisibilityGenerator(dropdown, rootDescription)
			BuildHideVisibilityDropdownItems(rootDescription, visSettings, OnHideVisibilityChange)
		end

		controls.dropDown.selectedBarVisibility:SetupMenu(VisibilityGenerator)
		UpdateDropdownDisplayText(controls.dropDown.selectedBarVisibility, function() return GetShowVisibilityDisplayName(visSettings) end)
		controls.dropDown.selectedHideVisibility:SetupMenu(HideVisibilityGenerator)
		UpdateDropdownDisplayText(controls.dropDown.selectedHideVisibility, function()
			local displayText = GetHideVisibilityDisplayName(visSettings)
			return displayText
		end)

		-- Smooth checkbox
		controls.checkBoxes.selectedSmooth:SetChecked(visSettings.smooth)
		controls.checkBoxes.selectedSmooth:SetScript("OnClick", function(self, ...)
			visSettings.smooth = self:GetChecked()
			refreshFunc()
		end)

		-- Alpha sliders â€” set scripts BEFORE values so SetValue doesn't write to the old entry
		controls.sliders.selectedActiveAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			visSettings.activeAlpha = value
			refreshFunc()
		end)
		controls.sliders.selectedActiveAlpha:SetValue(visSettings.activeAlpha or 100)

		controls.sliders.selectedInactiveAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			visSettings.inactiveAlpha = value
			refreshFunc()
		end)
		controls.sliders.selectedInactiveAlpha:SetValue(visSettings.inactiveAlpha or 0)

		controls.sliders.selectedFadeDuration:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			visSettings.fadeDuration = value
			refreshFunc()
		end)
		controls.sliders.selectedFadeDuration:SetValue(visSettings.fadeDuration or 0)

		controls.sliders.selectedFadeDelay:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			visSettings.fadeDelay = value
			refreshFunc()
		end)
		controls.sliders.selectedFadeDelay:SetValue(visSettings.fadeDelay or 0)

		-- Show/hide threshold controls based on current condition type
		ShowThresholdControls(visSettings.resourceConditionType or "none", visSettings)

		-- Comparison dropdown â€” set up menu and current selection using CreateRadio for proper text+indicator
		local function ThresholdComparisonIsSelected(operator)
			return (visSettings.resourceConditionOperator or ">=") == operator
		end

		local function ThresholdComparisonSetSelected(operator)
			visSettings.resourceConditionOperator = operator
			refreshFunc()
		end

		local function ThresholdComparisonGenerator(dropdown, rootDescription)
			for _, entry in ipairs(comparisonOperators) do
				rootDescription:CreateRadio(entry.label, ThresholdComparisonIsSelected, ThresholdComparisonSetSelected, entry.operator)
			end
		end

		controls.dropDown.selectedThresholdComparison:SetupMenu(ThresholdComparisonGenerator)
		local currentOp = visSettings.resourceConditionOperator or ">="
		controls.dropDown.selectedThresholdComparison:SetDefaultText(GetComparisonLabel(currentOp))
		controls.dropDown.selectedThresholdComparison:SetText(GetComparisonLabel(currentOp))

		-- Threshold value slider â€” set script BEFORE value
		controls.sliders.selectedThresholdValue:SetScript("OnValueChanged", function(self, value)
			-- Compute precision dynamically based on current condition type (may change after FillDetailPanel)
			local ct = visSettings.resourceConditionType or "none"
			local thresholdDefinition = thresholdTypeDefinitions[ct]
			local precision = (thresholdDefinition ~= nil and thresholdDefinition.isPercent == true) and 1 or 0
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, precision, nil, true)
			self.EditBox:SetText(value)
			visSettings.resourceConditionValue = value
			refreshFunc()
		end)
		controls.sliders.selectedThresholdValue:SetValue(visSettings.resourceConditionValue or 0)
		UpdateThresholdControlLabels(visSettings.resourceConditionType or "none")

		detailFrame:Show()
	end

	-- Table click handler
	barVisibilityTable:RegisterEvents({
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				if realrow ~= nil and realrow > 0 then
					local barKey = data[realrow].cols[1].value

					-- Reject selection if this bar is currently controlled by global settings
					if IsUsingGlobalDisplayBar() then
						for _, e in ipairs(barEntries) do
							if e.key == barKey and e.isGlobal then
								scrollingTable:ClearSelection()
								detailFrame:Hide()
								return
							end
						end
					end

					local currentSelection = scrollingTable:GetSelection()
					FillDetailPanel(barKey)
					C_Timer.After(0, function()
						C_Timer.After(0.05, function()
							local newSelection = scrollingTable:GetSelection()
							if newSelection == nil then
								barVisibilityTable:SetSelection(currentSelection)
							end
						end)
					end)
				end
			end
		end
	})

	-- Initial table population
	SetTableValues()

	-- Define the refresh function that the "Use global settings" checkbox calls
	-- to update the table state when the toggle changes.
	RefreshTableForGlobalToggle = function()
		SetTableValues()
		-- If the currently selected bar is now controlled by global, deselect it
		if IsUsingGlobalDisplayBar() and selectedBarKey ~= nil then
			for _, e in ipairs(barEntries) do
				if e.key == selectedBarKey and e.isGlobal then
					barVisibilityTable:ClearSelection()
					detailFrame:Hide()
					selectedBarKey = nil
					break
				end
			end
		end
	end

	yCoord = yCoord - (35 + (tableRowCount * 15)) - 10 - detailHeight

	return yCoord
end

---Generates a threshold list panel with a scrolling table showing all thresholds and a detail panel below for enabling/disabling them.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold configuration
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@param thresholdConfig table Configuration for threshold list display
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateThresholdListPanel(parent, controls, spec, classId, specId, yCoord, thresholdConfig)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	-- Category display names
	local categoryLabels = {
		offensive = L["ThresholdCategoryOffensive"],
		defensive = L["ThresholdCategoryDefensive"],
		utility = L["ThresholdCategoryUtility"],
		execute = L["ThresholdCategoryExecute"],
		custom = L["ThresholdCategoryCustom"],
		-- Spec specific categories (e.g., Druid shapeshift forms)
		metamorphosis = L["ThresholdCategoryMetamorphosis"],
	}

	-- Bar target display names (caller provides friendly resource names)
	local barTargetLabels = thresholdConfig.barTargetLabels or {
		primary = L["ThresholdBarTargetPrimary"],
		secondary = L["ThresholdBarTargetSecondary"],
	}

	-- Build the threshold entry list from the spec's cached spell data (not the runtime threshold cache,
	-- which only holds spells for the currently active spec and filters by talents).
	local thresholdEntries = {}
	local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local specCacheEntry = compositeKey and TRB.Data.specCache[compositeKey] or nil
	local specSpells = specCacheEntry and specCacheEntry.spellsData and specCacheEntry.spellsData.spells or nil
	local configLabels = thresholdConfig.labels
	if specSpells ~= nil then
		for _, v in pairs(specSpells) do
			if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v:IsValid() then
				local spell = v --[[@as TRB.Classes.SpellThreshold]]
				local settingKey = spell.settingKey
				if settingKey ~= nil and spec.thresholds.thresholdDictionary[settingKey] ~= nil then
					-- Check for linked thresholds (e.g., cleave/whirlwind in Arms)
					local linkedKeys = nil
					if thresholdConfig.linkedThresholds and thresholdConfig.linkedThresholds[settingKey] then
						linkedKeys = thresholdConfig.linkedThresholds[settingKey]
					end

					-- Use config label if provided, otherwise fall back to spell name
					local displayName = (configLabels and configLabels[settingKey]) or spell.name or settingKey

					table.insert(thresholdEntries, {
						settingKey = settingKey,
						name = displayName,
						icon = spell.icon or "",
						category = spell.category or "offensive",
						barTarget = spell.barTarget or "primary",
						tooltip = thresholdConfig.tooltips and thresholdConfig.tooltips[settingKey] or nil,
						linkedKeys = linkedKeys,
					})
				end
			end
		end
	end

	-- Also add custom thresholds if configured
	if spec.thresholds.customThresholds then
		for key, custom in pairs(spec.thresholds.customThresholds) do
			table.insert(thresholdEntries, {
				settingKey = key,
				name = custom.name or key,
				icon = "",
				category = "custom",
				barTarget = custom.barTarget or "primary",
				tooltip = custom.tooltip or nil,
				linkedKeys = nil,
			})
		end
	end

	-- Table columns
	local columns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = "",
			["width"] = 22,
			["align"] = "CENTER",
			["defaultsort"] = 1,
			["comparesort"] = function(st, rowa, rowb, sortbycol)
				-- Sort by name (column 3) value, using the icon column's sort direction
				local cella = st:GetCell(rowa, 3)
				local cellb = st:GetCell(rowb, 3)
				local a1 = type(cella) == "table" and cella.value or cella
				local b1 = type(cellb) == "table" and cellb.value or cellb
				if a1 == b1 then return false end
				local column = st.cols[sortbycol]
				local direction = column.sort or column.defaultsort or 2
				if direction == 1 then return a1 < b1 else return a1 > b1 end
			end,
		},
		{
			["name"] = L["ThresholdTableHeaderName"],
			["width"] = 100,
			["align"] = "LEFT",
			["sort"] = 1,
			["defaultsort"] = 1,
		},
		{
			["name"] = L["ThresholdTableHeaderCategory"],
			["width"] = 115,
			["align"] = "LEFT",
		},
		{
			["name"] = L["ThresholdTableHeaderBar"],
			["width"] = 115,
			["align"] = "LEFT",
		},
		{
			["name"] = "",
			["width"] = 16,
			["align"] = "CENTER",
			["sortnext"] = 3,
		},
		{
			["name"] = L["ThresholdTableHeaderEnabled"],
			["width"] = 60,
			["align"] = "LEFT",
		},
	}

	yCoord = yCoord - 3
	controls.thresholdOverridesSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdOverridesHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	-- Create table container
	controls.thresholdListContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local tlc = controls.thresholdListContainer
	tlc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tlc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	local tableRowCount = math.max(#thresholdEntries, 4)
	tableRowCount = math.min(tableRowCount, 6)
	tlc:SetHeight(35 + (tableRowCount * 15))

	local thresholdTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, tableRowCount, 15, nil, tlc, false, false)

	-- Dynamically resize the Name column to fill available width
	tlc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[4].width + columns[5].width + columns[6].width + columns[7].width
		local newNameWidth = math.max(100, w - fixedWidth - 30)
		columns[3].width = newNameWidth
		thresholdTable:SetDisplayCols(columns)
	end)

	local selectedSettingKey = nil
	local detailHasUnusable = false
	local detailHasOutOfRange = false
	local detailCanHaveAudio = true
	local detailHasThresholdIcon = true

	---Refreshes the scrolling table data from the current threshold settings.
	local function SetTableValues()
		local dataTable = {}
		for _, entry in ipairs(thresholdEntries) do
			local dictEntry = spec.thresholds.thresholdDictionary[entry.settingKey]
			local isEnabled = dictEntry and dictEntry.enabled or false

			-- For linked thresholds, check if any linked key is enabled
			if entry.linkedKeys then
				for _, lk in ipairs(entry.linkedKeys) do
					local lkEntry = spec.thresholds.thresholdDictionary[lk]
					if lkEntry and lkEntry.enabled then
						isEnabled = true
						break
					end
				end
			end

			local categoryLabel = categoryLabels[entry.category]
			local barTargetLabel = barTargetLabels[entry.barTarget]

			local enabledText = isEnabled and "|cFF00FF00Yes|r" or "|cFFFF0000No|r"

			local hasAudio = dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound and dictEntry.audio.sound ~= ""
			local audioIcon = hasAudio and "|TInterface\\Common\\VoiceChat-Speaker:12|t" or ""

			local rowData = {
				cols = {
					{ value = entry.settingKey },
					{ value = entry.icon },
					{ value = entry.name },
					{ value = categoryLabel },
					{ value = barTargetLabel },
					{ value = audioIcon },
					{ value = enabledText },
				}
			}
			table.insert(dataTable, rowData)
		end
		thresholdTable:SetData(dataTable)
		thresholdTable:EnableSelection(true)
	end

	-- Detail header below the table (outside the scrolling detail panel)
	local detailHeader = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "", oUi.xCoord, 0)
	detailHeader:SetPoint("TOPLEFT", tlc, "BOTTOMLEFT", oUi.xCoord, 0)
	detailHeader:Hide()

	-- Detail panel below the header, filling remaining space
	controls.thresholdListDetail = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_ThresholdListDetail", parent, "BackdropTemplate")
	local detailFrame = controls.thresholdListDetail
	detailFrame:SetPoint("TOPLEFT", detailHeader, "BOTTOMLEFT", -oUi.xCoord, 0)
	detailFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	detailFrame:Hide()

	-- Scroll frame inside the detail panel for overflow
	local detailScrollFrame = CreateFrame("ScrollFrame", "TwintopResourceBar_" .. namePrefix .. "_ThresholdDetailScroll", detailFrame, "UIPanelScrollFrameTemplate")
	detailScrollFrame:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, 0)
	detailScrollFrame:SetPoint("BOTTOMRIGHT", detailFrame, "BOTTOMRIGHT", -20, 0)
	local detailScrollChild = CreateFrame("Frame", nil, detailScrollFrame)
	detailScrollChild:SetSize(detailScrollFrame:GetWidth() or 600, 1)
	detailScrollFrame:SetScrollChild(detailScrollChild)

	-- Hook to keep scroll child width synchronized with the scroll frame
	detailScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		detailScrollChild:SetWidth(w)
	end)

	local detailYCoord = 0

	-- Detail panel contents: enabled checkbox
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.thresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdEnabled", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local enabledCheckbox = controls.checkBoxes.thresholdEnabled
	enabledCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(enabledCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailEnabledCheckbox"])
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, false, false)
	enabledCheckbox:Hide()

	-- ===== COLOR OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 30
	local colorsHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailColorsHeader"], oUi.xCoord, detailYCoord)
	colorsHeader.font:SetFontObject(GameFontNormalLarge)
	colorsHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	-- Helper to get effective mode from a color entry (backward compat with old boolean enabled field)
	local function GetColorMode(colorEntry)
		if colorEntry == nil then return "shared" end
		if colorEntry.mode ~= nil then return colorEntry.mode end
		if colorEntry.enabled then return "override" end
		return "shared"
	end

	-- Helper for OOR backward compat: old data used show/enabled booleans instead of mode
	local function GetOorColorMode(colorEntry)
		if colorEntry == nil then return "shared" end
		if colorEntry.mode ~= nil then return colorEntry.mode end
		-- Legacy: show=false means hidden, show=true+enabled=true means override, else shared
		if colorEntry.show == false then return "hidden" end
		if colorEntry.enabled then return "override" end
		return "shared"
	end

	controls.dropDown = controls.dropDown or {}

	-- Color Mode: Static / Dynamic dropdown
	controls.dropDown.thresholdColorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorModeDropdown = controls.dropDown.thresholdColorMode
	colorModeDropdown:SetWidth(oUi.sliderWidth)
	colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorModeDropdown:Hide()

	controls.colors.thresholdStatic = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorModeStaticColor"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdStatic:Hide()

	-- Under color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnderMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnderMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnderModeDropdown = controls.dropDown.thresholdColorUnderMode
	colorUnderModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnderModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnderModeDropdown:Hide()

	controls.colors.thresholdUnder = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnder"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnder:Hide()

	-- Over color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOverMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOverMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOverModeDropdown = controls.dropDown.thresholdColorOverMode
	colorOverModeDropdown:SetWidth(oUi.sliderWidth)
	colorOverModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOverModeDropdown:Hide()

	controls.colors.thresholdOver = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOver"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOver:Hide()

	-- Unusable color: mode dropdown + color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorUnusableMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorUnusableMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorUnusableModeDropdown = controls.dropDown.thresholdColorUnusableMode
	colorUnusableModeDropdown:SetWidth(oUi.sliderWidth)
	colorUnusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorUnusableModeDropdown:Hide()

	controls.colors.thresholdUnusable = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsUnusable"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdUnusable:Hide()

	-- Out of Range: mode dropdown + override color picker
	detailYCoord = detailYCoord - 30
	controls.dropDown.thresholdColorOorMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdColorOorMode", detailScrollChild, "WowStyle1DropdownTemplate")
	local colorOorModeDropdown = controls.dropDown.thresholdColorOorMode
	colorOorModeDropdown:SetWidth(oUi.sliderWidth)
	colorOorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	colorOorModeDropdown:Hide()

	controls.colors.thresholdOutOfRange = TRB.Functions.OptionsUi:BuildColorPicker(detailScrollChild, L["ThresholdDetailColorsOutOfRange"], "FFFFFFFF", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, detailYCoord)
	controls.colors.thresholdOutOfRange:Hide()

	-- ===== LINE OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 40
	local lineHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailLineHeader"], oUi.xCoord, detailYCoord)
	lineHeader.font:SetFontObject(GameFontNormalLarge)
	lineHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.checkBoxes.thresholdLineUseSpecific = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdLineUseSpecific", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local lineUseSpecificCheckbox = controls.checkBoxes.thresholdLineUseSpecific
	lineUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, detailYCoord)
	getglobal(lineUseSpecificCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailLineUseSpecific"])
	lineUseSpecificCheckbox.tooltip = L["ThresholdDetailLineUseSpecificTooltip"]
	lineUseSpecificCheckbox:Hide()

	detailYCoord = detailYCoord - 40
	controls.sliders = controls.sliders or {}
	controls.sliders.thresholdLineWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailLineWidth"], 1, 10, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdLineWidth:Hide()

	controls.checkBoxes.thresholdLineOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdLineOverlapBorder", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local lineOverlapBorderCheckbox = controls.checkBoxes.thresholdLineOverlapBorder
	lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(lineOverlapBorderCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailLineOverlapBorder"])
	lineOverlapBorderCheckbox.tooltip = L["ThresholdDetailLineOverlapBorderTooltip"]
	lineOverlapBorderCheckbox:Hide()

	-- ===== ICON OVERRIDE SECTION =====
	detailYCoord = detailYCoord - 50
	local iconHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconHeader"], oUi.xCoord, detailYCoord)
	iconHeader.font:SetFontObject(GameFontNormalLarge)
	iconHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.dropDown = controls.dropDown or {}
	controls.checkBoxes.thresholdIconUseSpecific = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconUseSpecific", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconUseSpecificCheckbox = controls.checkBoxes.thresholdIconUseSpecific
	iconUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, detailYCoord)
	getglobal(iconUseSpecificCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconUseSpecific"])
	iconUseSpecificCheckbox.tooltip = L["ThresholdDetailIconUseSpecificTooltip"]
	iconUseSpecificCheckbox:Hide()

	detailYCoord = detailYCoord - 20
	controls.dropDown.thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconRelativeTo", detailScrollChild, "WowStyle1DropdownTemplate")
	local iconRelativeToDropdown = controls.dropDown.thresholdIconRelativeTo
	iconRelativeToDropdown:SetWidth(oUi.sliderWidth)
	iconRelativeToDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailIconRelativePosition"], oUi.xCoord, detailYCoord)
	iconRelativeToDropdown.label.font:SetFontObject(GameFontNormal)
	iconRelativeToDropdown:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 30)
	iconRelativeToDropdown:Hide()

	controls.checkBoxes.thresholdIconShow = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconShow", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconShowCheckbox = controls.checkBoxes.thresholdIconShow
	iconShowCheckbox:SetPoint("TOPLEFT", oUi.xCoord2, detailYCoord - 30)
	getglobal(iconShowCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconShowCheckbox"])
	iconShowCheckbox.tooltip = L["ThresholdDetailIconShowCheckboxTooltip"]
	iconShowCheckbox:Hide()

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdIconDesaturated", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local iconDesaturateCheckbox = controls.checkBoxes.thresholdIconDesaturated
	iconDesaturateCheckbox:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding * 2, detailYCoord - 50)
	getglobal(iconDesaturateCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailIconDesaturate"])
	iconDesaturateCheckbox.tooltip = L["ThresholdDetailIconDesaturateTooltip"]
	iconDesaturateCheckbox:Hide()

	detailYCoord = detailYCoord - 100
	controls.sliders.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconWidth"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconWidth:Hide()

	controls.sliders.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconHeight"], 1, 128, 32, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconHeight:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconXPos = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconXPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconXPos:Hide()

	controls.sliders.thresholdIconYPos = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconYPos"], -128, 128, 0, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.thresholdIconYPos:Hide()

	detailYCoord = detailYCoord - 60
	controls.sliders.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(detailScrollChild, L["ThresholdDetailIconBorderWidth"], 0, 12, 2, 1, 0, oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.thresholdIconBorderWidth:Hide()

	-- ===== AUDIO CUE SECTION =====
	detailYCoord = detailYCoord - 50
	local audioHeader = TRB.Functions.OptionsUi:BuildSectionHeader(detailScrollChild, L["ThresholdDetailAudioHeader"], oUi.xCoord, detailYCoord)
	audioHeader.font:SetFontObject(GameFontNormalLarge)
	audioHeader.font:SetTextColor(1, 1, 1)
	detailYCoord = detailYCoord - 30

	controls.checkBoxes.thresholdAudioEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdAudioEnabled", detailScrollChild, "ChatConfigCheckButtonTemplate")
	local audioCheckbox = controls.checkBoxes.thresholdAudioEnabled
	audioCheckbox:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord)
	getglobal(audioCheckbox:GetName() .. 'Text'):SetText(L["ThresholdDetailAudioCheckbox"])
	audioCheckbox.tooltip = L["ThresholdDetailAudioCheckboxTooltip"]
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, false, true)
	audioCheckbox:Hide()

	controls.dropDown.thresholdAudioSound = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Detail_ThresholdAudioSound", detailScrollChild, "WowStyle1DropdownTemplate")
	local audioDropdown = controls.dropDown.thresholdAudioSound
	audioDropdown:SetWidth(oUi.sliderWidth)
	audioDropdown:SetPoint("TOPLEFT", oUi.xPadding2, detailYCoord - 20)
	audioDropdown:Hide()

	---Dynamically repositions all detail panel controls based on which sections
	---are currently visible, eliminating empty gaps from hidden controls.
	local function RepositionDetailControls()
		local y = 0
		local isEnabled = enabledCheckbox:GetChecked()

		-- Enabled checkbox
		enabledCheckbox:ClearAllPoints()
		enabledCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
		y = y - 30

		-- Color override section (hidden when threshold disabled)
		local isStaticMode = false
		if isEnabled then
			colorsHeader:Show()
			colorModeDropdown:Show()
			-- Determine if we're in static or dynamic mode
			if selectedSettingKey then
				local dictEntry = spec.thresholds.thresholdDictionary[selectedSettingKey]
				if dictEntry and dictEntry.colors and dictEntry.colors.colorMode == "static" then
					isStaticMode = true
				end
			end
			if isStaticMode then
				controls.colors.thresholdStatic:Show()
				colorUnderModeDropdown:Hide()
				controls.colors.thresholdUnder:Hide()
				colorOverModeDropdown:Hide()
				controls.colors.thresholdOver:Hide()
				colorUnusableModeDropdown:Hide()
				controls.colors.thresholdUnusable:Hide()
				colorOorModeDropdown:Hide()
				controls.colors.thresholdOutOfRange:Hide()
			else
				controls.colors.thresholdStatic:Hide()
				colorUnderModeDropdown:Show()
				colorOverModeDropdown:Show()
				-- Restore color swatch visibility based on each color entry's current mode
				local dictEntry = selectedSettingKey and spec.thresholds.thresholdDictionary[selectedSettingKey]
				if dictEntry and dictEntry.colors then
					if GetColorMode(dictEntry.colors.under) == "override" then
						controls.colors.thresholdUnder:Show()
					else
						controls.colors.thresholdUnder:Hide()
					end
					if GetColorMode(dictEntry.colors.over) == "override" then
						controls.colors.thresholdOver:Show()
					else
						controls.colors.thresholdOver:Hide()
					end
				else
					controls.colors.thresholdUnder:Hide()
					controls.colors.thresholdOver:Hide()
				end
				-- Restore unusable/OOR dropdown+swatch visibility based on spell capabilities
				if detailHasUnusable then
					colorUnusableModeDropdown:Show()
					if dictEntry and dictEntry.colors and GetColorMode(dictEntry.colors.unusable) == "override" then
						controls.colors.thresholdUnusable:Show()
					else
						controls.colors.thresholdUnusable:Hide()
					end
				end
				if detailHasOutOfRange then
					colorOorModeDropdown:Show()
					if dictEntry and dictEntry.colors and GetOorColorMode(dictEntry.colors.outOfRange) == "override" then
						controls.colors.thresholdOutOfRange:Show()
					else
						controls.colors.thresholdOutOfRange:Hide()
					end
				end
			end
		else
			colorsHeader:Hide()
			colorModeDropdown:Hide()
			controls.colors.thresholdStatic:Hide()
			colorUnderModeDropdown:Hide()
			controls.colors.thresholdUnder:Hide()
			colorOverModeDropdown:Hide()
			controls.colors.thresholdOver:Hide()
			colorUnusableModeDropdown:Hide()
			controls.colors.thresholdUnusable:Hide()
			colorOorModeDropdown:Hide()
			controls.colors.thresholdOutOfRange:Hide()
		end

		if colorsHeader:IsShown() then
			colorsHeader:ClearAllPoints()
			colorsHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			-- Color Mode row (Static / Dynamic)
			colorModeDropdown:ClearAllPoints()
			colorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
			if isStaticMode then
				controls.colors.thresholdStatic:ClearAllPoints()
				controls.colors.thresholdStatic:SetPoint("TOPLEFT", oUi.xCoord2, y)
			end
			y = y - 30

			if not isStaticMode then
				-- Under row
				colorUnderModeDropdown:ClearAllPoints()
				colorUnderModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				controls.colors.thresholdUnder:ClearAllPoints()
				controls.colors.thresholdUnder:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30

				-- Over row
				colorOverModeDropdown:ClearAllPoints()
				colorOverModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
				controls.colors.thresholdOver:ClearAllPoints()
				controls.colors.thresholdOver:SetPoint("TOPLEFT", oUi.xCoord2, y)
				y = y - 30

				-- Unusable row (only for spells with cooldown)
				if colorUnusableModeDropdown:IsShown() then
					colorUnusableModeDropdown:ClearAllPoints()
					colorUnusableModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
					controls.colors.thresholdUnusable:ClearAllPoints()
					controls.colors.thresholdUnusable:SetPoint("TOPLEFT", oUi.xCoord2, y)
					y = y - 30
				end

				-- Out of Range row (only for spells with range check)
				if colorOorModeDropdown:IsShown() then
					colorOorModeDropdown:ClearAllPoints()
					colorOorModeDropdown:SetPoint("TOPLEFT", oUi.xCoord, y)
					controls.colors.thresholdOutOfRange:ClearAllPoints()
					controls.colors.thresholdOutOfRange:SetPoint("TOPLEFT", oUi.xCoord2, y)
					y = y - 30
				end
			end
		end

		-- Line override section (hidden when threshold disabled)
		if isEnabled then
			lineHeader:Show()
			lineUseSpecificCheckbox:Show()
			-- Restore line sub-controls based on the "Use specific" checkbox
			if lineUseSpecificCheckbox:GetChecked() then
				controls.sliders.thresholdLineWidth:Show()
				lineOverlapBorderCheckbox:Show()
			else
				controls.sliders.thresholdLineWidth:Hide()
				lineOverlapBorderCheckbox:Hide()
			end
		else
			lineHeader:Hide()
			lineUseSpecificCheckbox:Hide()
			controls.sliders.thresholdLineWidth:Hide()
			lineOverlapBorderCheckbox:Hide()
		end

		if lineHeader:IsShown() then
			lineHeader:ClearAllPoints()
			lineHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			lineUseSpecificCheckbox:ClearAllPoints()
			lineUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			if controls.sliders.thresholdLineWidth:IsShown() then
				controls.sliders.thresholdLineWidth:ClearAllPoints()
				controls.sliders.thresholdLineWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				y = y - 50

				lineOverlapBorderCheckbox:ClearAllPoints()
				lineOverlapBorderCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
				y = y - 30
			end
		end

		-- Icon override section (hidden when threshold disabled or has no icon)
		if isEnabled and detailHasThresholdIcon then
			iconHeader:Show()
			iconUseSpecificCheckbox:Show()
			-- Restore icon sub-controls based on the "Use specific" checkbox
			if iconUseSpecificCheckbox:GetChecked() then
				iconRelativeToDropdown.label:Show()
				iconRelativeToDropdown:Show()
				iconShowCheckbox:Show()
				iconDesaturateCheckbox:Show()
				controls.sliders.thresholdIconWidth:Show()
				controls.sliders.thresholdIconHeight:Show()
				controls.sliders.thresholdIconXPos:Show()
				controls.sliders.thresholdIconYPos:Show()
				controls.sliders.thresholdIconBorderWidth:Show()
			else
				iconRelativeToDropdown.label:Hide()
				iconRelativeToDropdown:Hide()
				iconShowCheckbox:Hide()
				iconDesaturateCheckbox:Hide()
				controls.sliders.thresholdIconWidth:Hide()
				controls.sliders.thresholdIconHeight:Hide()
				controls.sliders.thresholdIconXPos:Hide()
				controls.sliders.thresholdIconYPos:Hide()
				controls.sliders.thresholdIconBorderWidth:Hide()
			end
		else
			iconHeader:Hide()
			iconUseSpecificCheckbox:Hide()
			iconRelativeToDropdown.label:Hide()
			iconRelativeToDropdown:Hide()
			iconShowCheckbox:Hide()
			iconDesaturateCheckbox:Hide()
			controls.sliders.thresholdIconWidth:Hide()
			controls.sliders.thresholdIconHeight:Hide()
			controls.sliders.thresholdIconXPos:Hide()
			controls.sliders.thresholdIconYPos:Hide()
			controls.sliders.thresholdIconBorderWidth:Hide()
		end

		if iconHeader:IsShown() then
			iconHeader:ClearAllPoints()
			iconHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			iconUseSpecificCheckbox:ClearAllPoints()
			iconUseSpecificCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			if iconRelativeToDropdown:IsShown() then
				iconRelativeToDropdown.label:ClearAllPoints()
				iconRelativeToDropdown.label:SetPoint("TOPLEFT", oUi.xCoord, y)
				iconRelativeToDropdown:ClearAllPoints()
				iconRelativeToDropdown:SetPoint("TOPLEFT", oUi.xCoord, y - 30)

				iconShowCheckbox:ClearAllPoints()
				iconShowCheckbox:SetPoint("TOPLEFT", oUi.xCoord2, y - 30)

				iconDesaturateCheckbox:ClearAllPoints()
				iconDesaturateCheckbox:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding * 2, y - 50)
				y = y - 100

				controls.sliders.thresholdIconWidth:ClearAllPoints()
				controls.sliders.thresholdIconWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				controls.sliders.thresholdIconHeight:ClearAllPoints()
				controls.sliders.thresholdIconHeight:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
				y = y - 60

				controls.sliders.thresholdIconXPos:ClearAllPoints()
				controls.sliders.thresholdIconXPos:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				controls.sliders.thresholdIconYPos:ClearAllPoints()
				controls.sliders.thresholdIconYPos:SetPoint("TOPLEFT", oUi.xCoord2 + 18, y)
				y = y - 60

				controls.sliders.thresholdIconBorderWidth:ClearAllPoints()
				controls.sliders.thresholdIconBorderWidth:SetPoint("TOPLEFT", oUi.xCoord + 18, y)
				y = y - 50
			end
		end

		-- Audio section (only visible when threshold supports audio cues)
		if detailCanHaveAudio then
			audioHeader:ClearAllPoints()
			audioHeader:SetPoint("TOPLEFT", oUi.xCoord, y)
			y = y - 30

			audioCheckbox:ClearAllPoints()
			audioCheckbox:SetPoint("TOPLEFT", oUi.xCoord, y)
			audioDropdown:ClearAllPoints()
			audioDropdown:SetPoint("TOPLEFT", oUi.xPadding2, y - 20)
			y = y - 60
		else
			audioHeader:Hide()
			audioCheckbox:Hide()
			audioDropdown:Hide()
		end

		detailScrollChild:SetHeight(math.abs(y) + 20)
	end

	---Populates the detail panel for the selected threshold.
	---@param settingKey string The settingKey of the threshold to show details for
	local function FillDetailPanel(settingKey)
		selectedSettingKey = settingKey
		local entry = nil
		for _, e in ipairs(thresholdEntries) do
			if e.settingKey == settingKey then
				entry = e
				break
			end
		end
		if entry == nil then
			detailHeader:Hide()
			detailFrame:Hide()
			return
		end

		-- Look up the spell object for capability detection
		local spellObj = nil
		if specSpells ~= nil then
			for _, v in pairs(specSpells) do
				if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v.settingKey == settingKey then
					spellObj = v --[[@as TRB.Classes.SpellThreshold]]
					break
				end
			end
		end

		local hasUnusable = spellObj ~= nil and spellObj.hasCooldown == true
		local hasOutOfRange = spellObj ~= nil and spellObj.rangeCheck ~= false
		detailHasUnusable = hasUnusable
		detailHasOutOfRange = hasOutOfRange
		detailCanHaveAudio = spellObj == nil or spellObj.canHaveAudioCue ~= false
		detailHasThresholdIcon = spellObj == nil or spellObj.hasThresholdIcon ~= false

		-- Update header
		detailHeader.font:SetText(string.format(L["ThresholdDetailHeader"], entry.icon .. " " .. entry.name))

		-- Get the dictionary entry
		local dictEntry = spec.thresholds.thresholdDictionary[settingKey]
		if dictEntry == nil then
			spec.thresholds.thresholdDictionary[settingKey] = { enabled = false }
			dictEntry = spec.thresholds.thresholdDictionary[settingKey]
		end

		-- Ensure sub-tables exist on demand with concrete defaults from global settings
		dictEntry.audio = dictEntry.audio or {}
		dictEntry.colors = dictEntry.colors or {}
		dictEntry.colors.under = dictEntry.colors.under or {}
		dictEntry.colors.over = dictEntry.colors.over or {}
		dictEntry.colors.unusable = dictEntry.colors.unusable or {}
		dictEntry.colors.outOfRange = dictEntry.colors.outOfRange or {}
		dictEntry.icon = dictEntry.icon or {
			enabled = false,
			show = true,
			desaturated = true,
			relativeTo = spec.thresholds.icons.relativeTo or "BOTTOM",
			width = spec.thresholds.icons.width or 32,
			height = spec.thresholds.icons.height or 32,
			xPos = spec.thresholds.icons.xPos or 0,
			yPos = spec.thresholds.icons.yPos or 0,
			border = spec.thresholds.icons.border or 2,
		}
		dictEntry.line = dictEntry.line or {
			enabled = false,
			width = spec.thresholds.properties.width or 2,
			overlapBorder = spec.thresholds.properties.overlapBorder,
		}

		local isEnabled = dictEntry.enabled or false

		-- For linked thresholds, check if any linked key is enabled
		if entry.linkedKeys then
			for _, lk in ipairs(entry.linkedKeys) do
				local lkEntry = spec.thresholds.thresholdDictionary[lk]
				if lkEntry and lkEntry.enabled then
					isEnabled = true
					break
				end
			end
		end

		-- ===== ENABLED CHECKBOX =====
		enabledCheckbox:SetChecked(isEnabled)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, isEnabled, false)
		enabledCheckbox:SetScript("OnClick", function(self, ...)
			local checked = self:GetChecked()
			dictEntry.enabled = checked
			if entry.linkedKeys then
				for _, lk in ipairs(entry.linkedKeys) do
					if spec.thresholds.thresholdDictionary[lk] then
						spec.thresholds.thresholdDictionary[lk].enabled = checked
					end
				end
			end
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(enabledCheckbox, checked, false)
			RepositionDetailControls()
			SetTableValues()
			for i, e in ipairs(thresholdEntries) do
				if e.settingKey == settingKey then
					thresholdTable:SetSelection(i)
					break
				end
			end
		end)
		if entry.tooltip then
			enabledCheckbox.tooltip = entry.tooltip
		end
		enabledCheckbox:Show()

		-- ===== COLOR OVERRIDE SECTION =====
		-- Helper to set up a color mode dropdown for a given color type
		local function SetupColorModeDropdown(dropdown, colorPicker, colorEntry, fallbackColor, modeLabels, prefix, getModeFn)
			local resolveMode = getModeFn or GetColorMode
			local mode = resolveMode(colorEntry)
			local color = colorEntry.color or fallbackColor

			-- Hook SetText to always prepend the prefix to the displayed selection
			if not dropdown._originalSetText then
				dropdown._originalSetText = dropdown.SetText
				dropdown.SetText = function(self, text)
					dropdown._originalSetText(self, prefix .. ": " .. (text or ""))
				end
			end

			dropdown:SetDefaultText(prefix .. ": " .. (modeLabels[mode] or modeLabels["shared"]))

			-- Show/hide color picker based on mode
			if mode == "override" then
				colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(color, true))
				colorPicker:Show()
			else
				colorPicker:Hide()
			end

			-- Set up dropdown menu
			local function IsSelected(value)
				return value == resolveMode(colorEntry)
			end

			local function SetSelected(newValue)
				colorEntry.mode = newValue
				colorEntry.enabled = nil -- Remove old field
				colorEntry.show = nil -- Remove old OOR field
				if newValue == "override" then
					colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true))
					colorPicker:Show()
				else
					colorPicker:Hide()
				end
				RepositionDetailControls()
				TRB.Functions.Threshold:RedrawThresholdLines()
			end

			dropdown:SetupMenu(function(dd, rootDescription)
				for _, key in ipairs({"shared", "override", "hidden"}) do
					rootDescription:CreateRadio(modeLabels[key], IsSelected, SetSelected, key)
				end
			end)
			dropdown:Show()
		end

		-- Helper to wire up color picker OnMouseDown
		local function WireColorPicker(colorPicker, colorEntry, fallbackColor)
			colorPicker:SetScript("OnMouseDown", function(self, button, ...)
				if button == "LeftButton" then
					local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorEntry.color or fallbackColor, true)
					TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
						local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
						local newColor = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
						colorEntry.color = newColor
						colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(newColor, true))
					end)
				end
			end)
		end

		-- ===== COLOR MODE (Static / Dynamic) =====
		dictEntry.colors.staticColor = dictEntry.colors.staticColor or {}
		local colorMode = dictEntry.colors.colorMode or "dynamic"
		local colorModeLabels = {
			static = L["ThresholdDetailColorModeStatic"],
			dynamic = L["ThresholdDetailColorModeDynamic"],
		}

		local colorModePrefix = L["ThresholdDetailColorModePrefix"]
		colorModeDropdown:SetDefaultText(colorModePrefix .. ": " .. (colorModeLabels[colorMode] or colorModeLabels["dynamic"]))
		if not colorModeDropdown._originalSetText then
			colorModeDropdown._originalSetText = colorModeDropdown.SetText
			colorModeDropdown.SetText = function(self, text)
				colorModeDropdown._originalSetText(self, colorModePrefix .. ": " .. (text or ""))
			end
		end
		colorModeDropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["ThresholdDetailColorModeTooltip"], 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		colorModeDropdown:SetScript("OnLeave", function() GameTooltip:Hide() end)

		-- Static color swatch
		local staticColor = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
		if colorMode == "static" then
			controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(staticColor, true))
			controls.colors.thresholdStatic:Show()
		else
			controls.colors.thresholdStatic:Hide()
		end

		local function ColorModeIsSelected(value)
			return value == (dictEntry.colors.colorMode or "dynamic")
		end

		local function ColorModeSetSelected(newValue)
			dictEntry.colors.colorMode = newValue
			if newValue == "static" then
				local sc = dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF"
				controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(sc, true))
			end
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end

		colorModeDropdown:SetupMenu(function(dd, rootDescription)
			for _, key in ipairs({"static", "dynamic"}) do
				rootDescription:CreateRadio(colorModeLabels[key], ColorModeIsSelected, ColorModeSetSelected, key)
			end
		end)
		colorModeDropdown:Show()

		-- Wire static color picker
		controls.colors.thresholdStatic:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(dictEntry.colors.staticColor.color or spec.colors.threshold.under.color or "FFFFFFFF", true)
				TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
					local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
					local newColor = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
					dictEntry.colors.staticColor.color = newColor
					controls.colors.thresholdStatic.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(newColor, true))
					TRB.Functions.Threshold:RedrawThresholdLines()
				end)
			end
		end)

		-- Under color: dropdown + swatch
		SetupColorModeDropdown(colorUnderModeDropdown, controls.colors.thresholdUnder, dictEntry.colors.under,
			spec.colors.threshold.under.color or "FFFFFFFF",
			{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnder"] },
			L["ThresholdDetailColorsPrefixUnder"])
		WireColorPicker(controls.colors.thresholdUnder, dictEntry.colors.under, spec.colors.threshold.under.color or "FFFFFFFF")

		-- Over color: dropdown + swatch
		SetupColorModeDropdown(colorOverModeDropdown, controls.colors.thresholdOver, dictEntry.colors.over,
			spec.colors.threshold.over.color or "FFFFFFFF",
			{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOver"] },
			L["ThresholdDetailColorsPrefixOver"])
		WireColorPicker(controls.colors.thresholdOver, dictEntry.colors.over, spec.colors.threshold.over.color or "FFFFFFFF")

		-- Unusable color: dropdown + swatch (only for spells with cooldown)
		if hasUnusable then
			SetupColorModeDropdown(colorUnusableModeDropdown, controls.colors.thresholdUnusable, dictEntry.colors.unusable,
				spec.colors.threshold.unusable.color or "FFFFFFFF",
				{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenUnusable"] },
				L["ThresholdDetailColorsPrefixUnusable"])
			WireColorPicker(controls.colors.thresholdUnusable, dictEntry.colors.unusable, spec.colors.threshold.unusable.color or "FFFFFFFF")
		else
			colorUnusableModeDropdown:Hide()
			controls.colors.thresholdUnusable:Hide()
		end

		-- Out of Range: dropdown + swatch (only for spells with range check)
		if hasOutOfRange then
			SetupColorModeDropdown(colorOorModeDropdown, controls.colors.thresholdOutOfRange, dictEntry.colors.outOfRange,
				spec.colors.threshold.outOfRange.color or "FFFFFFFF",
				{ shared = L["ThresholdDetailColorsModeShared"], override = L["ThresholdDetailColorsModeOverride"], hidden = L["ThresholdDetailColorsModeHiddenOutOfRange"] },
				L["ThresholdDetailColorsPrefixOutOfRange"],
				GetOorColorMode)
			WireColorPicker(controls.colors.thresholdOutOfRange, dictEntry.colors.outOfRange, spec.colors.threshold.outOfRange.color or "FFFFFFFF")
		else
			colorOorModeDropdown:Hide()
			controls.colors.thresholdOutOfRange:Hide()
		end

		-- ===== LINE OVERRIDE SECTION =====
		local function UpdateLineControlsVisibility()
			if dictEntry.line.enabled then
				controls.sliders.thresholdLineWidth:Show()
				lineOverlapBorderCheckbox:Show()
			else
				controls.sliders.thresholdLineWidth:Hide()
				lineOverlapBorderCheckbox:Hide()
			end
		end

		lineUseSpecificCheckbox:SetChecked(dictEntry.line.enabled or false)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled or false, true)
		lineUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.line.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(lineUseSpecificCheckbox, dictEntry.line.enabled, true)
			UpdateLineControlsVisibility()
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		lineUseSpecificCheckbox:Show()

		local lineWidth = dictEntry.line.width or spec.thresholds.properties.width or 2
		controls.sliders.thresholdLineWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdLineWidth:SetValue(lineWidth)
		controls.sliders.thresholdLineWidth.EditBox:SetText(lineWidth)
		controls.sliders.thresholdLineWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.line.width = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Overlap Border checkbox
		lineOverlapBorderCheckbox:SetChecked(dictEntry.line.overlapBorder or false)
		lineOverlapBorderCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.line.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		UpdateLineControlsVisibility()

		-- ===== ICON OVERRIDE SECTION =====
		if detailHasThresholdIcon then
		local function UpdateIconControlsVisibility()
			if dictEntry.icon.enabled then
				iconRelativeToDropdown.label:Show()
				iconRelativeToDropdown:Show()
				iconShowCheckbox:Show()
				iconDesaturateCheckbox:Show()
				TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)
				controls.sliders.thresholdIconWidth:Show()
				controls.sliders.thresholdIconHeight:Show()
				controls.sliders.thresholdIconXPos:Show()
				controls.sliders.thresholdIconYPos:Show()
				controls.sliders.thresholdIconBorderWidth:Show()
			else
				iconRelativeToDropdown.label:Hide()
				iconRelativeToDropdown:Hide()
				iconShowCheckbox:Hide()
				iconDesaturateCheckbox:Hide()
				controls.sliders.thresholdIconWidth:Hide()
				controls.sliders.thresholdIconHeight:Hide()
				controls.sliders.thresholdIconXPos:Hide()
				controls.sliders.thresholdIconYPos:Hide()
				controls.sliders.thresholdIconBorderWidth:Hide()
			end
		end

		iconUseSpecificCheckbox:SetChecked(dictEntry.icon.enabled or false)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled or false, true)
		iconUseSpecificCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(iconUseSpecificCheckbox, dictEntry.icon.enabled, true)
			UpdateIconControlsVisibility()
			RepositionDetailControls()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		iconUseSpecificCheckbox:Show()

		-- Relative Position dropdown
		local iconRelativeTo = dictEntry.icon.relativeTo or spec.thresholds.icons.relativeTo or "BOTTOM"

		local relativeToMap = {}
		relativeToMap[L["ThresholdIconPositionAboveLeft"]] = "TOP"
		relativeToMap[L["PositionMiddle"]] = "CENTER"
		relativeToMap[L["ThresholdIconPositionBelowRight"]] = "BOTTOM"
		local relativeToList = { L["ThresholdIconPositionAboveLeft"], L["PositionMiddle"], L["ThresholdIconPositionBelowRight"] }

		-- Set initial display text
		for k, v in pairs(relativeToMap) do
			if v == iconRelativeTo then
				iconRelativeToDropdown:SetDefaultText(k)
				break
			end
		end

		local function IconRelativeToIsSelected(value)
			return value == (dictEntry.icon.relativeTo or spec.thresholds.icons.relativeTo or "BOTTOM")
		end

		local function IconRelativeToSetSelected(newValue)
			dictEntry.icon.relativeTo = newValue
			for k, v in pairs(relativeToMap) do
				if v == newValue then
					iconRelativeToDropdown:SetDefaultText(k)
					break
				end
			end
			TRB.Functions.Threshold:RedrawThresholdLines()
		end

		local function IconRelativeToGenerator(dropdown, rootDescription)
			for _, label in pairs(relativeToList) do
				rootDescription:CreateRadio(label, IconRelativeToIsSelected, IconRelativeToSetSelected, relativeToMap[label])
			end
		end
		iconRelativeToDropdown:SetupMenu(IconRelativeToGenerator)

		-- Show Icons checkbox
		iconShowCheckbox:SetChecked(dictEntry.icon.show ~= false)
		iconShowCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.show = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show)
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Desaturate Icons checkbox
		iconDesaturateCheckbox:SetChecked(dictEntry.icon.desaturated ~= false)
		iconDesaturateCheckbox:SetScript("OnClick", function(self, ...)
			dictEntry.icon.desaturated = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(iconDesaturateCheckbox, dictEntry.icon.show ~= false)

		-- Icon size/position sliders
		local iconWidth = dictEntry.icon.width or spec.thresholds.icons.width or 32
		local iconHeight = dictEntry.icon.height or spec.thresholds.icons.height or 32
		local iconXPos = dictEntry.icon.xPos or spec.thresholds.icons.xPos or 0
		local iconYPos = dictEntry.icon.yPos or spec.thresholds.icons.yPos or 0
		local iconBorder = dictEntry.icon.border or spec.thresholds.icons.border or 2

		controls.sliders.thresholdIconWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconWidth:SetValue(iconWidth)
		controls.sliders.thresholdIconWidth.EditBox:SetText(iconWidth)
		controls.sliders.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.width = value

			local currentHeight = dictEntry.icon.height or spec.thresholds.icons.height or 32
			local maxBorderSize = math.min(math.floor(currentHeight / TRB.Data.constants.borderWidthFactor), math.floor(value / TRB.Data.constants.borderWidthFactor))
			local borderSize = math.min(maxBorderSize, dictEntry.icon.border or spec.thresholds.icons.border or 2)
			controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.EditBox:SetText(borderSize)

			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconHeight:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconHeight:SetValue(iconHeight)
		controls.sliders.thresholdIconHeight.EditBox:SetText(iconHeight)
		controls.sliders.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.height = value

			local currentWidth = dictEntry.icon.width or spec.thresholds.icons.width or 32
			local maxBorderSize = math.min(math.floor(value / TRB.Data.constants.borderWidthFactor), math.floor(currentWidth / TRB.Data.constants.borderWidthFactor))
			local borderSize = math.min(maxBorderSize, dictEntry.icon.border or spec.thresholds.icons.border or 2)
			controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.sliders.thresholdIconBorderWidth.EditBox:SetText(borderSize)

			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconXPos:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconXPos:SetValue(iconXPos)
		controls.sliders.thresholdIconXPos.EditBox:SetText(iconXPos)
		controls.sliders.thresholdIconXPos:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.xPos = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconYPos:SetValue(iconYPos)
		controls.sliders.thresholdIconYPos.EditBox:SetText(iconYPos)
		controls.sliders.thresholdIconYPos:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.yPos = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		-- Icon Border Width slider
		local maxIconBorder = math.min(math.floor(iconHeight / TRB.Data.constants.borderWidthFactor), math.floor(iconWidth / TRB.Data.constants.borderWidthFactor))
		controls.sliders.thresholdIconBorderWidth:SetMinMaxValues(0, maxIconBorder)
		controls.sliders.thresholdIconBorderWidth.MaxLabel:SetText(maxIconBorder)
		controls.sliders.thresholdIconBorderWidth:SetScript("OnValueChanged", nil)
		controls.sliders.thresholdIconBorderWidth:SetValue(iconBorder)
		controls.sliders.thresholdIconBorderWidth.EditBox:SetText(iconBorder)
		controls.sliders.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			dictEntry.icon.border = value
			TRB.Functions.Threshold:RedrawThresholdLines()
		end)

		UpdateIconControlsVisibility()
		else
			iconHeader:Hide()
			iconUseSpecificCheckbox:Hide()
			iconRelativeToDropdown.label:Hide()
			iconRelativeToDropdown:Hide()
			iconShowCheckbox:Hide()
			iconDesaturateCheckbox:Hide()
			controls.sliders.thresholdIconWidth:Hide()
			controls.sliders.thresholdIconHeight:Hide()
			controls.sliders.thresholdIconXPos:Hide()
			controls.sliders.thresholdIconYPos:Hide()
			controls.sliders.thresholdIconBorderWidth:Hide()
		end

		-- ===== AUDIO CUE SECTION =====
		if detailCanHaveAudio then
			audioHeader:Show()
			audioCheckbox:SetChecked(dictEntry.audio.enabled or false)
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled or false, true)
			audioCheckbox:SetScript("OnClick", function(self, ...)
				dictEntry.audio.enabled = self:GetChecked()
				TRB.Functions.OptionsUi:ToggleCheckboxOnOff(audioCheckbox, dictEntry.audio.enabled, true)
				if dictEntry.audio.enabled and dictEntry.audio.sound and dictEntry.audio.sound ~= "" then
					PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
				end
				SetTableValues()
			end)
			audioCheckbox:Show()

			-- Audio sound dropdown
			FillSoundCache()
			local soundDisplayName = dictEntry.audio.soundName
			audioDropdown:SetDefaultText((soundDisplayName and soundDisplayName ~= "") and soundDisplayName or L["ThresholdDetailAudioNone"])
			local function AudioIsSelected(value)
				return value == dictEntry.audio.sound
			end
			local function AudioSetSelected(newValue)
				dictEntry.audio.sound = newValue
				dictEntry.audio.soundName = soundPairsByName[newValue]
				local newSoundName = dictEntry.audio.soundName
				audioDropdown:SetDefaultText((newSoundName and newSoundName ~= "") and newSoundName or L["ThresholdDetailAudioNone"])
				PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
				SetTableValues()
			end
			audioDropdown:SetupMenu(function(dropdown, rootDescription)
				for k, v in pairs(soundPairs) do
					rootDescription:CreateRadio(v[1], AudioIsSelected, AudioSetSelected, v[2])
				end
				rootDescription:SetScrollMode(400)
			end)
			audioDropdown:Show()
		else
			audioHeader:Hide()
			audioCheckbox:Hide()
			audioDropdown:Hide()
		end

		RepositionDetailControls()
		detailHeader:Show()
		detailFrame:Show()
	end

	-- Table click handler
	thresholdTable:RegisterEvents({
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				if realrow ~= nil and realrow > 0 then
					local settingKey = data[realrow].cols[1].value
					local currentSelection = scrollingTable:GetSelection()
					FillDetailPanel(settingKey)
					C_Timer.After(0, function()
						C_Timer.After(0.05, function()
							local newSelection = scrollingTable:GetSelection()
							if newSelection == nil then
								thresholdTable:SetSelection(currentSelection)
							end
						end)
					end)
				end
			end
		end
	})

	-- Row tooltip handler
	thresholdTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 then
				local settingKey = data[realrow].cols[1].value
				for _, entry in ipairs(thresholdEntries) do
					if entry.settingKey == settingKey and entry.tooltip then
						GameTooltip:SetOwner(rowFrame, "ANCHOR_CURSOR")
						GameTooltip:SetText(entry.tooltip, 1, 1, 1, 1, true)
						GameTooltip:Show()
						break
					end
				end
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			GameTooltip:Hide()
		end
	})

	-- Initial table population
	SetTableValues()

	yCoord = yCoord - (35 + (tableRowCount * 15)) - 10

	return yCoord
end

---Generates the threshold line icon position and dimension options panel, including icon size, border, position, threshold line width, and overlap settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing threshold icon configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param isHealer boolean? Whether the spec is a healer (affects global setting handling)
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, isHealer)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdIcons")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "thresholdIcons")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdIcons", "thresholdIcons", yCoord)
	end

	yCoord = yCoord - 20
	local thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRelativeTo", parent, "WowStyle1DropdownTemplate")
	thresholdIconRelativeTo:SetWidth(oUi.sliderWidth)
	thresholdIconRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdIconRelativePosition"], oUi.xCoord, yCoord)
	thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["ThresholdIconPositionAboveLeft"]] = "TOP"
	relativeTo[L["PositionMiddle"]] = "CENTER"
	relativeTo[L["ThresholdIconPositionBelowRight"]] = "BOTTOM"
	local relativeToList = {
		L["ThresholdIconPositionAboveLeft"],
		L["PositionMiddle"],
		L["ThresholdIconPositionBelowRight"]
	}
	for label, value in pairs(relativeTo) do
		if value == spec.thresholds.icons.relativeTo then
			thresholdIconRelativeTo:SetDefaultText(label)
			break
		end
	end

	local function RelativeToIsSelected(value)
		return value == spec.thresholds.icons.relativeTo
	end

	local function RelativeToSetSelected(newValue)
		spec.thresholds.icons.relativeTo = newValue

		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.thresholds.icons.relativeToName = k
				break
			end
		end
		thresholdIconRelativeTo:SetDefaultText(spec.thresholds.icons.relativeToName)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	thresholdIconRelativeTo:SetupMenu(RelativeToGenerator)
	thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShow"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

	yCoord = yCoord - 100
	title = L["ThresholdIconWidth"]
	controls.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.width = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconHeight"]
	controls.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.height = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.thresholds.icons.border)

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)


	title = L["ThresholdIconHorizontal"]
	yCoord = yCoord - 60
	controls.thresholdIconHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.xPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconVertical"]
	controls.thresholdIconVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.yPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

	title = L["ThresholdIconBorderWidth"]
	yCoord = yCoord - 60
	controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.border = value

		local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
		local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

		controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
		controls.thresholdIconHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
		controls.thresholdIconWidth.MinLabel:SetText(tostring(minsliderWidth))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdLineWidth"]
	controls.thresholdWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.thresholds.properties.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.properties.width = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	yCoord = yCoord - 40
	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.properties.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.properties.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	return yCoord
end

---Generates Threshold Line color options for the specialization, including custom colors if provided.
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param localizationResource string
---@param under boolean?
---@param over boolean?
---@param unusable boolean?
---@param outOfRange boolean?
---@param custom TRB.Classes.OptionsUi.Color[]?
---@return number
function TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, classId, specId, yCoord, localizationResource, under, over, unusable, outOfRange, custom)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.colors.threshold = controls.colors.threshold or {}

	if classId == nill then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsForDpsAndTanksHeader"], oUi.xCoord, yCoord)
	else
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "thresholds")
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdColors")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "thresholdColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdColors", "thresholdColors", yCoord)
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)
	end

	if unusable == true then
		yCoord = yCoord - 30
		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)
	end

	if outOfRange == true then
		yCoord = yCoord - 30
		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeShowCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.show = self:GetChecked()

			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		controls.checkBoxes.thresholdOutOfRangeColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRangeColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRangeColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.enabled = self:GetChecked()
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)
	end

	if custom ~= nil and #custom > 0 then
		for _, value in pairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
		end
	end

	return yCoord
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