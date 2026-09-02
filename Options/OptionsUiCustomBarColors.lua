---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.CustomBarColors = TRB.Functions.OptionsUi.CustomBarColors or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

---Repaints the live bar after a range edit, from either the colors or the start values section.
---@param classId integer
---@param specId integer
local function RepaintRangeBar(classId, specId)
	if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

-- ============================================================================
-- Secondary and custom bar color options
-- ============================================================================

---Generates the optional partial-fill color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
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

	controls.colors.comboPoints.regenerating = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], secondaryResourceString), spec.colors.comboPoints.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "regenerating")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.regenerating, self)
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
function TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, resourceString)
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
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	colorControls.regenerating = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], resourceString), colorSettings.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = colorControls.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "regenerating", nil, nil, classId, specId)
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorSettings.regenerating, self, classId, specId)
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
function TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryCastingOverlayOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
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

	controls.colors.comboPoints.casting = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["SecondaryCastingOverlayColorPicker"], secondaryResourceString), spec.colors.comboPoints.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.casting
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "casting")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.casting, self, classId, specId)
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
		TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
	end)
	yCoord = yCoord - 45
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	return yCoord
end

---Generates spending overlay color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondarySpendingOverlayOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	spec.colors = spec.colors or {}
	spec.colors.comboPoints = spec.colors.comboPoints or {}
	spec.colors.comboPoints.spending = spec.colors.comboPoints.spending or TRB.Functions.Settings:DefaultSecondarySpendingOverlayColor(true)

	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local frameName = "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondarySpendingOverlay"

	controls.colors.comboPoints.spending = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["SecondarySpendingOverlayColorPicker"], secondaryResourceString), spec.colors.comboPoints.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.spending
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "spending")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.spending, self, classId, specId)
	end)

	controls.checkBoxes.secondarySpendingOverlayEnabled = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes.secondarySpendingOverlayEnabled
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondarySpendingOverlayCheckbox"], secondaryResourceString))
	checkBox.tooltip = string.format(L["SecondarySpendingOverlayCheckboxTooltip"], secondaryResourceString)
	checkBox:SetChecked(spec.colors.comboPoints.spending.enabled)

	controls.checkBoxes.secondarySpendingOverlayFullHeight = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondarySpendingOverlayFullHeight", parent, "ChatConfigCheckButtonTemplate")
	local fullHeightCheckBox = controls.checkBoxes.secondarySpendingOverlayFullHeight
	fullHeightCheckBox:SetPoint("TOPLEFT", oUi.xCoord + (oUi.xPadding * 2), yCoord - 18)
	getglobal(fullHeightCheckBox:GetName() .. 'Text'):SetText(L["OverlayFullHeightCheckbox"])
	fullHeightCheckBox.tooltip = L["OverlayFullHeightCheckboxTooltip"]
	fullHeightCheckBox:SetChecked(spec.colors.comboPoints.spending.fullHeight == true)
	fullHeightCheckBox:SetScript("OnClick", function(self)
		spec.colors.comboPoints.spending.fullHeight = self:GetChecked()
		TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
	end)
	yCoord = yCoord - 45
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.secondarySpendingOverlayFullHeight, spec.colors.comboPoints.spending.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.spending.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(controls.checkBoxes.secondarySpendingOverlayFullHeight, spec.colors.comboPoints.spending.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

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
function TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, afterNodesCallback)
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
	controls[barTypeDef.key .. "ColorSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]

	-- For threshold-based color bars (like Stagger), use the threshold color UI
	if barTypeDef.colorCurveType == "step" or barTypeDef.colorCurveType == "linear" then
		return TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	end

	-- Simple bar/border/background colors
	-- Bar Color

	if colorSettings.bar then
		if type(colorSettings.bar) == "table" and colorSettings.bar.color2 then
			colorControls.bar = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), colorSettings.bar, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
			f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorSettings.bar, self, classId, specId)
			end)
		else
			local barColorValue = type(colorSettings.bar) == "table" and colorSettings.bar.color or colorSettings.bar
			colorControls.bar = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), barColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
		end
		yCoord = yCoord - 30
	end

	-- Gated range colors sit with the bar color they override. Slot 1 IS that color, so only slots
	-- 2..rangeSlots get a row; the start values live in their own section.
	if barTypeDef.rangeSlots ~= nil and colorSettings.ranges ~= nil then
		colorControls.ranges = colorControls.ranges or {}
		controls.checkBoxes = controls.checkBoxes or {}
		for index = 2, barTypeDef.rangeSlots do
			local range = colorSettings.ranges[index]
			if range ~= nil then
				local slotKey = barTypeDef.key .. "Range" .. index

				controls.checkBoxes[slotKey .. "Enabled"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_range" .. index .. "Enabled", parent, "ChatConfigCheckButtonTemplate")
				local rangeCheckBox = controls.checkBoxes[slotKey .. "Enabled"]
				rangeCheckBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
				getglobal(rangeCheckBox:GetName() .. 'Text'):SetText(string.format(L["CustomBarRangeEnabled"], index))
				rangeCheckBox.tooltip = string.format(L["CustomBarRangeEnabledTooltip"], index, displayName)
				rangeCheckBox:SetChecked(range.enabled)
				rangeCheckBox:SetScript("OnClick", function(self, ...)
					range.enabled = self:GetChecked()
					RepaintRangeBar(classId, specId)
				end)

				colorControls.ranges[index] = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, string.format(L["CustomBarRangeColor"], index), range, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
				local rangeColorPicker = colorControls.ranges[index]
				rangeColorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings.ranges, colorControls.ranges, index, nil, nil, classId, specId)
				end)
				rangeColorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, range, self, classId, specId)
				end)
				yCoord = yCoord - 30
			end
		end
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
				local checkboxText = getglobal(row.checkbox:GetName() .. 'Text')
				checkboxText:SetText(nc.displayName)
				-- After the relabel: the badge is placed past the measured end of the new text.
				TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(checkboxText, nc.cdm)
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
					-- After the relabel: the badge is placed past the measured end of the new text.
					TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(row.colorPicker.Font, nc.cdm)
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
					-- On an amalgamation bar only some nodes are CDM-fed, so the badge is per-node.
					TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(getglobal(fCheckbox:GetName() .. 'Text'), nodeConfig.cdm)
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
						nodeControls.color = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
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
						nodeControls.color = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, nodeColorLabel, nodeColorSettings.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
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
						nodeControls.color = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
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
						nodeControls.color = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, nodeColorLabel, nodeColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
					end
					row.colorPicker = nodeControls.color
					-- No enable checkbox here, so the swatch label carries the badge.
					if nodeControls.color ~= nil then
						TRB.Functions.OptionsUi.Primitives:AttachCdmBadgeToText(nodeControls.color.Font, nodeConfig.cdm)
					end
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
		colorControls.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	-- Background Color
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	-- Multi-node secret bars get no cap: which node is highest is unknowable. Single-node ones have one fill edge.
	if not (barTypeDef.usesSecretValue and barTypeDef.isMultiNode) and colorSettings.endCap then
		yCoord = yCoord + 30
		yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colorSettings, namePrefix, "endCap_" .. barTypeDef.key, L["EndCap"], classId, specId)
	end

	return yCoord
end

---Generates the start value sliders for a bar whose fill recolors by value range, two per row. Slot 1
---starts at 0, so only slots 2..rangeSlots get a slider. Their colors sit in the bar's colors section.
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param maxValue number # Highest start value a range can take (the bar's own maximum)
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarRangeValueOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, maxValue)
	local colorSettings = barTypeDef:GetColors(spec)
	if colorSettings == nil or colorSettings.ranges == nil or barTypeDef.rangeSlots == nil then
		return yCoord
	end

	local displayName = barTypeDef.displayName

	controls[barTypeDef.key .. "RangeValueSection"] = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, string.format(L["CustomBarRangeValueHeader"], displayName), oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	controls[barTypeDef.key .. "RangeColorNote"] = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, string.format(L["CustomBarRangeColorNote"], displayName), oUi.xCoord, yCoord, oUi.dropdownWidth * 2, 28)
	yCoord = yCoord - 40

	-- Two per row, so the slider titles and edit boxes stay legible without a column of dead space.
	local column = 0
	for index = 2, barTypeDef.rangeSlots do
		local range = colorSettings.ranges[index]
		if range ~= nil then
			local slotKey = barTypeDef.key .. "Range" .. index
			local xCoord = column == 0 and oUi.xCoord or oUi.xCoord2

			controls[slotKey .. "Value"] = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, string.format(L["CustomBarRangeValue"], index), 1, maxValue, range.value, 1, 0,
											oUi.sliderWidth, oUi.sliderHeight, xCoord, yCoord)
			controls[slotKey .. "Value"]:SetScript("OnValueChanged", function(self, value)
				value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
				range.value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
				RepaintRangeBar(classId, specId)
			end)

			column = column + 1
			if column == 2 then
				column = 0
				yCoord = yCoord - 60
			end
		end
	end

	-- An odd count leaves the last row half-filled and unadvanced.
	if column > 0 then
		yCoord = yCoord - 60
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
function TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, onChangeCallback)
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
		-- Run the callback first (e.g. UpdateHealthValues rebuilds the health color curve)
		-- so the bar update below paints with the fresh color instead of the stale one.
		if changeCallback then
			changeCallback()
		end
		if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
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
	-- Only bar types that supply this label offer the flat class color option
	local colorTypeClassColorLabel = barTypeDef.colorTypeClassColorLabel

	-- Color Transition Type dropdown
	-- Note: yCoord already positioned at header row, so dropdown label goes here
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown[barTypeDef.key .. "ColorCurveType"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetWidth(oUi.sliderWidth)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, colorTypeLabel, oUi.xCoord, yCoord)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the current color curve type.
	---@param value string The color curve type to check ("step", "linear", "none", or "classColor")
	---@return boolean
	local function ColorCurveTypeIsSelected(value)
		return value == colorSettings.type
	end

	---Returns the localized display name for a color curve type value.
	---@param value string The color curve type ("step", "linear", "none", or "classColor")
	---@return string
	local function ColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return colorTypeStepLabel
		elseif value == "linear" then
			return colorTypeLinearLabel
		elseif value == "classColor" and colorTypeClassColorLabel ~= nil then
			return colorTypeClassColorLabel
		else
			return colorTypeNoneLabel
		end
	end

	---Sets the color curve type to a new value, updates the dropdown text, and triggers a change callback.
	---@param newValue string The new color curve type ("step", "linear", "none", or "classColor")
	local function ColorCurveTypeSetSelected(newValue)
		colorSettings.type = newValue
		controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(newValue))
		triggerChange()
	end

	---Populates the dropdown menu with color curve type options (step, linear, none, and optionally classColor).
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function ColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(colorTypeStepLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(colorTypeLinearLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(colorTypeNoneLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "none")
		if colorTypeClassColorLabel ~= nil then
			rootDescription:CreateRadio(colorTypeClassColorLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "classColor")
		end
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
			controls[barTypeDef.key .. thresholdKey .. "Threshold"] = TRB.Functions.OptionsUi.Primitives:BuildPercentageSlider(parent, sliderLabel,
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
				colorControls[thresholdKey] = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, colorLabel, colorSettings[thresholdKey], oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2, gradientTooltip)
				f = colorControls[thresholdKey]
				f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId, changeCallback)
				end)
				f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, colorSettings[thresholdKey], self, classId, specId, changeCallback)
				end)
			else
				colorControls[thresholdKey] = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, colorLabel, colorSettings[thresholdKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
				f = colorControls[thresholdKey]
				f:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId, changeCallback)
				end)
			end
			yCoord2 = yCoord2 - 30
		end
	end

	-- Border and background colors
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId, changeCallback)
		end)
		yCoord2 = yCoord2 - 30
	end

	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId, changeCallback)
		end)
		yCoord2 = yCoord2 - 30
	end

	yCoord = math.min(yCoord, yCoord2)

	-- Multi-node secret bars get no cap: which node is highest is unknowable. Single-node ones have one fill edge.
	if not (barTypeDef.usesSecretValue and barTypeDef.isMultiNode) and colorSettings.endCap then
		yCoord = yCoord + 50
		yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, colorSettings, namePrefix, "endCap_" .. barTypeDef.key, L["EndCap"], classId, specId)
		yCoord = yCoord - 30
	end

	return yCoord
end

