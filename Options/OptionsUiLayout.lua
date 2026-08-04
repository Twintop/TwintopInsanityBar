---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Layout = TRB.Functions.OptionsUi.Layout or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Bar layout and dimensions options
-- ============================================================================

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

---Applies sensible defaults when changing anchor target type (screen <-> bar).
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
		-- Screen -> Bar: reset to bar-to-bar defaults
		-- Attach this bar's TOP to the target bar's BOTTOM (bar appears just below target)
		anchor.anchorPoint = "BOTTOM"
		anchor.attachPoint = "TOP"
		anchor.xOffset = 0
		anchor.yOffset = 0
		anchor.matchWidth = true
		return true
	elseif not wasScreen and goingToScreen then
		-- Bar -> Screen: reset to screen defaults
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
	return 100/255, 225/255, 200/255
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
function TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	controls.barPositionSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarPositionSize"], oUi.xCoord, yCoord)

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
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "resourceBar")
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
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("bar")
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "bar")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllBarDimensions", "bar", yCoord)
	end

	yCoord = yCoord - 40
	title = L["BarWidth"]
	controls.width = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls.height = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls.horizontal = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), primaryAnchor.xOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls.vertical = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), primaryAnchor.yOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls.borderWidth = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	primaryAnchorToDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], L["Resource"]), oUi.xCoord, yCoord)
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
			-- Update UI controls if anchor type changed (screen <-> bar)
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
	primaryAnchorPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
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
	primaryAttachPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
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
	primaryFillDirectionDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
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
function TRB.Functions.OptionsUi.Layout:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, config)
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
	controls[settingKey .. "PositionSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, sectionHeader, oUi.xCoord, yCoord)

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
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, globalSettingDef.tabKey)
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
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(globalSettingKey)
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, globalSettingKey)
	elseif globalSettingKey and classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKey:gsub("^%l", string.upper), globalSettingKey, yCoord)
	end

	-- Width and Height sliders
	local maxWidthValue = TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / widthDivisor, 0, "floor")
	local maxHeightValue = sanityCheckValues.barMaxHeight

	yCoord = yCoord - 40
	title = string.format(L["SecondaryWidth"], displayName)
	controls[settingKey .. "Width"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, maxWidthValue, spec[settingKey].width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls[settingKey .. "Height"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 1, maxHeightValue, spec[settingKey].height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls[settingKey .. "Horizontal"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), anchor.xOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Horizontal"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls[settingKey .. "Vertical"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), anchor.yOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Vertical"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls[settingKey .. "BorderWidth"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, maxBorderHeight, spec[settingKey].border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "BorderWidth"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
		controls.comboPointSpacing = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls.comboPointSpacing, not spec.comboPoints.collapseBorderWidth)
		cbCollapse:SetScript("OnClick", function(self, ...)
			spec.comboPoints.collapseBorderWidth = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls.comboPointSpacing, not spec.comboPoints.collapseBorderWidth)

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
	anchorToDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], displayName), oUi.xCoord, yCoord)
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
			-- Update UI controls if anchor type changed (screen <-> bar)
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
	anchorPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
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
	attachPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
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
	ancFillDirectionDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
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
		ancGrowthDirectionDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GrowthDirection"], oUi.xCoord2, yCoord)
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
function TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString, includeSpacing)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceEnergy"]
	end

	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	if includeSpacing == nil then
		includeSpacing = true
	end

	return TRB.Functions.OptionsUi.Layout:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
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


---Legacy wrapper for health bar dimension options. Delegates to GenerateAncillaryBarDimensionsOptions.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param primaryResourceString string? Localized primary resource name (defaults to "Mana")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceMana"]
	end

	return TRB.Functions.OptionsUi.Layout:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
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
function TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, primaryResourceString, useGlobalSettingKey)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the bar settings from the nested structure
	local barSettings = barTypeDef:GetSettings(spec)
	if not barSettings then
		return yCoord
	end

	-- On the Global panel (classId == nil) the edited table is core-scope; value-copied fields
	-- (width/height/border/fillDirection) only reach the active spec's cache via a re-fill when its
	-- use-global flag is set, so refresh the cache before applying layout.
	local function RefreshActiveSpecCacheForGlobalEdit()
		local char = TRB.Data.character
		if classId == nil and char ~= nil and char.className ~= nil and char.specName ~= nil and TRB.Data.specCache[char.compositeKey] ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(char.className, char.specName)
		end
	end

	local displayName = barTypeDef.displayName

	-- Section header. Every custom bar panel opens with this one, so a whole-bar CDM badge lands here.
	local headerText = string.format(L["SecondaryPositionAndSize"], displayName)
	controls[barTypeDef.key .. "DimensionsSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)
	TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(controls[barTypeDef.key .. "DimensionsSection"].font, barTypeDef.cdm)

	-- Optional "Use global settings" row (spec panels) / bulk all-specs toggle (Global panel)
	if useGlobalSettingKey ~= nil then
		local settingKeyUpper = useGlobalSettingKey:gsub("^%l", string.upper)
		if classId ~= nil and specId ~= nil then
			yCoord = yCoord - 30
			local lowerClassName = string.lower(className)
			controls.checkBoxes = controls.checkBoxes or {}
			controls.checkBoxes["useGlobal" .. settingKeyUpper] = CreateFrame("CheckButton", "TwintopResourceBar_" .. className .. "_" .. specName .. "_useGlobal_" .. useGlobalSettingKey, parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes["useGlobal" .. settingKeyUpper]
			f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
			local settingDef = TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(useGlobalSettingKey)
			getglobal(f:GetName() .. 'Text'):SetText(settingDef and settingDef.useGlobalLabel or L["CheckboxUseGlobal"])
			getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, settingDef and settingDef.tabKey or "resourceBar", settingDef and settingDef.categoryKey or nil)
			f.tooltip = L["CheckboxUseGlobalTooltip_" .. settingKeyUpper]
			f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName][useGlobalSettingKey])
			f:SetScript("OnClick", function(self, ...)
				TRB.Data.settings.core.global[lowerClassName][specName][useGlobalSettingKey] = self:GetChecked()
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)

				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				end
				TRB.Data.lookupDirty = true
				TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(useGlobalSettingKey)
			end)
			TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, useGlobalSettingKey)
		else
			yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKeyUpper, useGlobalSettingKey, yCoord)
		end
	end

	-- Width slider
	yCoord = yCoord - 40
	local widthMin = barTypeDef.isMultiNode and 10 or 30
	local widthMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	local widthDivisor = barTypeDef.isMultiNode and 6 or 1

	controls[barTypeDef.key .. "Width"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondaryWidth"], displayName),
		widthMin, math.ceil(widthMax / widthDivisor), barSettings.width, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		barSettings.width = value

		local a = EnsureAnchorBlock(barSettings)
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))

		RefreshActiveSpecCacheForGlobalEdit()
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Height slider
	controls[barTypeDef.key .. "Height"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondaryHeight"], displayName),
		1, (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100, barSettings.height, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		barSettings.height = value

		local a = EnsureAnchorBlock(barSettings)
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))
		controls[barTypeDef.key .. "Border"].EditBox:SetText(tostring(borderSize))

		RefreshActiveSpecCacheForGlobalEdit()
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- X/Y Offset sliders (read/write anchor block, dual-write to legacy)
	yCoord = yCoord - 60
	local anchor = EnsureAnchorBlock(barSettings)

	local xPosMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	controls[barTypeDef.key .. "XPos"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondaryHorizontalPosition"], displayName),
		math.ceil(-xPosMax / 2), math.floor(xPosMax / 2), anchor.xOffset, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "XPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(barSettings)
		a.xOffset = value
		DualWriteAnchorToLegacy(barSettings)

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Y Offset slider
	local yPosMax = (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100
	controls[barTypeDef.key .. "YPos"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondaryVerticalPosition"], displayName),
		math.ceil(-yPosMax / 2), math.floor(yPosMax / 2), anchor.yOffset, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "YPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	controls[barTypeDef.key .. "Border"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondaryBorderWidth"], displayName),
		0, maxBorderHeight, barSettings.border, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Border"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		barSettings.border = value

		RefreshActiveSpecCacheForGlobalEdit()
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
		controls[barTypeDef.key .. "Spacing"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["SecondarySpacing"], displayName),
			-20, 20, barSettings.spacing, 1, 0,
			oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls[barTypeDef.key .. "Spacing"]:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls[barTypeDef.key .. "Spacing"], not barSettings.collapseBorderWidth)
		cbCollapse:SetScript("OnClick", function(self, ...)
			barSettings.collapseBorderWidth = self:GetChecked()
			TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(controls[barTypeDef.key .. "Spacing"], not barSettings.collapseBorderWidth)

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
	anchorToDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], displayName), oUi.xCoord, yCoord)
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
			-- Update UI controls if anchor type changed (screen <-> bar)
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
	fillDirectionDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
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

			RefreshActiveSpecCacheForGlobalEdit()
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
		growthDirectionDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GrowthDirection"], oUi.xCoord2, yCoord)
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
	anchorPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
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
	attachPointDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
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

---Generates the side ability icon options for a bar: enable checkbox, side dropdown, and spacing/border
---sliders. Bar-agnostic -- any bar type whose settings carry an `icon` block can call this, and the
---layout code in Functions/Bar.lua reserves the space generically.
---@param parent Frame # The tab's scroll child
---@param controls table # The panel's controls table
---@param spec table # The spec (or core) settings table being edited
---@param classId integer? # nil on the Global panel
---@param specId integer?
---@param yCoord number
---@param barTypeDef table # The bar's BarTypeRegistry definition
---@return number yCoord
function TRB.Functions.OptionsUi.Layout:GenerateBarIconOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = "TwintopResourceBar_" .. className .. "_" .. specName .. "_" .. barTypeDef.key .. "_icon"

	local barSettings = barTypeDef:GetSettings(spec)
	if barSettings == nil then
		return yCoord
	end
	barSettings.icon = barSettings.icon or TRB.Functions.Settings:DefaultBarIconSettings()
	local iconSettings = barSettings.icon

	-- Global-panel edits land on the core table; the active spec's merged cache only picks them up on a re-fill
	local function ApplyIconChange()
		local char = TRB.Data.character
		if classId == nil and char ~= nil and char.className ~= nil and char.specName ~= nil and TRB.Data.specCache[char.compositeKey] ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(char.className, char.specName)
		end
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end

	controls[barTypeDef.key .. "IconSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, string.format(L["BarIconHeader"], barTypeDef.displayName), oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	-- Everything below the enable checkbox is meaningless with the icon off, so gray it out together
	local iconSubControls = {}
	local function RefreshIconSubControlStates()
		local enabled = iconSettings.enabled == true
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(iconSubControls.side, enabled)
		-- Collapsing the border overlaps the icon onto the bar, so the spacing slider is meaningless then
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(iconSubControls.spacing, enabled and not iconSettings.collapseBorderWidth)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(iconSubControls.collapse, enabled)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(iconSubControls.zoom, enabled)
	end

	controls[barTypeDef.key .. "IconEnabled"] = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_enabled", L["BarIconEnabled"], L["BarIconEnabledTooltip"], yCoord,
		function() return iconSettings.enabled end,
		function(v)
			iconSettings.enabled = v
			RefreshIconSubControlStates()
			ApplyIconChange()
		end)
	yCoord = yCoord - 40

	local sideOptions = {
		{ value = "left", label = L["BarIconSideLeft"] },
		{ value = "right", label = L["BarIconSideRight"] },
		{ value = "top", label = L["BarIconSideTop"] },
		{ value = "bottom", label = L["BarIconSideBottom"] },
	}
	-- Row with Side dropdown (left) + Spacing slider (right), and Collapse border width directly under
	-- Spacing. The dropdown is nudged up 14px so its label lines up with the slider's floating title.
	iconSubControls.side = TRB.Functions.OptionsUi.Primitives:BuildDropdown(parent, namePrefix .. "_side", L["BarIconSide"], sideOptions,
		function() return iconSettings.side or "left" end,
		function(v)
			iconSettings.side = v
			ApplyIconChange()
		end,
		oUi.xCoord, yCoord + 14)
	controls[barTypeDef.key .. "IconSideDropdown"] = iconSubControls.side

	yCoord = yCoord - 20
	iconSubControls.spacing = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["BarIconSpacing"], 0, 20, iconSettings.spacing, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	iconSubControls.spacing:SetScript("OnValueChanged", function(sliderFrame, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
		iconSettings.spacing = value
		ApplyIconChange()
	end)
	controls[barTypeDef.key .. "IconSpacing"] = iconSubControls.spacing

	-- Collapse checkbox sits 40px under the Spacing slider (same offset the bar-group panel uses)
	iconSubControls.collapse = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_collapseBorderWidth", L["CollapseBorderWidth"], L["CollapseBorderWidthTooltip"], yCoord,
		function() return iconSettings.collapseBorderWidth end,
		function(v)
			iconSettings.collapseBorderWidth = v
			RefreshIconSubControlStates()
			ApplyIconChange()
		end)
	iconSubControls.collapse:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 40)
	controls[barTypeDef.key .. "IconCollapseBorderWidth"] = iconSubControls.collapse

	-- Zoom slider on its own row, clearing the dropdown button and the collapse checkbox above it.
	yCoord = yCoord - 80
	iconSubControls.zoom = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["BarIconZoom"], 0, 25, iconSettings.zoom, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	iconSubControls.zoom:SetScript("OnValueChanged", function(sliderFrame, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(sliderFrame, value)
		iconSettings.zoom = value
		ApplyIconChange()
	end)
	controls[barTypeDef.key .. "IconZoom"] = iconSubControls.zoom
	yCoord = yCoord - 40

	RefreshIconSubControlStates()
	return yCoord
end

