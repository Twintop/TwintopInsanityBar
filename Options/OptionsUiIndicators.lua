---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Indicators = TRB.Functions.OptionsUi.Indicators or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Indicator colors options
-- ============================================================================

local gradientDirectionCycle = { "disabled", "horizontal", "vertical" }
local gradientDirectionAbbrevLabels = {
	disabled = L["GradientDirectionDisabledAbbrev"],
	horizontal = L["GradientDirectionHorizontalAbbrev"],
	vertical = L["GradientDirectionVerticalAbbrev"],
}

-- The elements a bar target offers when it doesn't name its own set: every spec-owned resource bar.
local defaultElementDefs = {
	{ key = "bar", label = L["BarElementBar"] },
	{ key = "border", label = L["BarElementBorder"] },
	{ key = "background", label = L["BarElementBackground"] },
	{ key = "endCap", label = L["EndCap"] },
}

---Whether this spec registers channel tick profiles of its own, which is what makes the cast bar draw
---channel tick lines -- and so what makes a color for them worth offering. Read from the code registry, for
---the spec whose panel is being built (not the one being played, which is usually a different spec).
---@param classId integer
---@param specId integer
---@return boolean
local function SpecHasCastbarTickProfiles(classId, specId)
	local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local getter = compositeKey and TRB.Data.castbarTickProfilesRegistry[compositeKey]
	if type(getter) ~= "function" then
		return false
	end
	return next(getter()) ~= nil
end

---The bar targets every spec gets for free: the health bar and the cast bar. Appended to whatever bars the
---spec itself declares, so these don't have to be hand-wired into all 40 spec option panels.
---Neither offers a plain "Bar" element: the health bar's fill is a health-threshold curve, and the cast
---bar's is driven per cast state, so it splits into its two states instead.
---@param classId integer
---@param specId integer
---@return TRB.Classes.OptionsUi.BarTargetDef[]
local function BuildSharedBarTargetDefs(classId, specId)
	local castbarElements = {
		{ key = "bar", label = L["BarElementBarHardcast"] },
		{ key = "channel", label = L["BarElementBarChanneled"] },
		{ key = "border", label = L["BarElementBorder"] },
		{ key = "background", label = L["BarElementBackground"] },
		{ key = "endCap", label = L["EndCap"] },
	}
	if SpecHasCastbarTickProfiles(classId, specId) then
		castbarElements[#castbarElements + 1] = { key = "tick", label = L["BarElementChanneledTick"] }
	end

	-- Gradient indicators are a step curve over the spec's own resource, painted onto whichever bar is
	-- targeted -- the same way the overcap gradient already colors, say, the Stagger bar's border from
	-- Energy. Borders and backgrounds are plain node colors and can take that curve. The rest can't: the
	-- health bar's fill is already a health curve, the cast bar's fill is driven per cast state, and the
	-- channel ticks are drawn textures rather than a node color.
	return {
		{
			key = "healthBar",
			label = L["BarVisibilityBarNameHealth"],
			elements = {
				{ key = "border", label = L["BarElementBorder"] },
				{ key = "background", label = L["BarElementBackground"] },
				{ key = "endCap", label = L["EndCap"] },
			}
		},
		{
			key = "castbar",
			label = L["BarVisibilityBarNameCastbar"],
			elements = castbarElements,
			gradientExcluded = { bar = true, channel = true, tick = true }
		},
	}
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
function TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, config)
	local indicatorDefs = config.indicatorDefs
	local gradientDefs = config.gradientDefs or {}
	local excludedElements = config.excludedElements or {}
	local gradientExcludedElements = config.gradientExcludedElements or {}
	local ddNamePrefix = config.ddNamePrefix

	-- The spec's own bars, then the health bar and cast bar every spec shares. Built into a new list so the
	-- caller's config table isn't mutated -- the panel is regenerated each time it's opened.
	local barTargetDefs = {}
	for _, barDef in ipairs(config.barTargetDefs) do
		barTargetDefs[#barTargetDefs + 1] = barDef
	end
	for _, barDef in ipairs(BuildSharedBarTargetDefs(classId, specId)) do
		barTargetDefs[#barTargetDefs + 1] = barDef
	end

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
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["IndicatorColorPriorityHeader"], oUi.xCoord, yCoord)

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
				for _, elemDef in ipairs(barDef.elements or defaultElementDefs) do
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

	---Whether any bar element is currently targeted by this indicator.
	---@param indicator table?
	---@return boolean
	local function HasAnyTarget(indicator)
		if not indicator or not indicator.targets then
			return false
		end
		for _, barDef in ipairs(barTargetDefs) do
			local barTargets = indicator.targets[barDef.key]
			if barTargets then
				for _, elemDef in ipairs(barDef.elements or defaultElementDefs) do
					if barTargets[elemDef.key] then
						return true
					end
				end
			end
		end
		return false
	end

	---Syncs the enabled state for an indicator based on whether any targets are selected
	---@param indicator table?
	---@param colorPicker Button? # The row's color picker, greyed out while nothing is targeted
	local function SyncEnabled(indicator, colorPicker)
		if not indicator then return end
		local anyEnabled = HasAnyTarget(indicator)
		indicator.enabled = anyEnabled
		if colorPicker then
			TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(colorPicker, anyEnabled)
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
			indicator.color2 = indicator.color2 or indicator.color
			indicator.gradientDirection = indicator.gradientDirection or "disabled"
			row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color, true))
			if row.colorPicker.Swatch2 then
				row.colorPicker.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color2, true))
				local gradDir = indicator.gradientDirection
				if gradDir == "disabled" then
					row.colorPicker.Swatch2:SetAlpha(0.35)
					row.colorPicker.Swatch2:EnableMouse(false)
				else
					row.colorPicker.Swatch2:SetAlpha(1.0)
					row.colorPicker.Swatch2:EnableMouse(true)
				end
			end
			if row.colorPicker.DirectionButton then
				row.colorPicker.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[indicator.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
			end
			if row.colorPicker.Font then
				row.colorPicker.Font:SetText(def.colorLabel)
			end
			TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
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
				for _, barDef in ipairs(barTargetDefs) do
					local barElementDefs = barDef.elements or defaultElementDefs
					local excluded = excludedElements[barDef.key]
					local allExcluded = true
					if excluded then
						for _, elemDef in ipairs(barElementDefs) do
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

						for _, elemDef in ipairs(barElementDefs) do
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
										local targetRow = rows[capturedRowIdx]
										SyncEnabled(ci, targetRow and targetRow.colorPicker)
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
			local cp = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, def.colorLabel, indicator, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord, L["GradientBarFillOnlyTooltip"])
			---@cast cp Button
			cp.Swatch1:SetScript("OnMouseDown", function(self, button)
				local currentKey = orderedKeys[capturedRowIdx]
				TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [currentKey] = rows[capturedRowIdx].colorPicker }, currentKey, "indicatorColor_" .. currentKey)
			end)
			cp.Swatch2:SetScript("OnMouseDown", function(self, button)
				local currentKey = orderedKeys[capturedRowIdx]
				TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, indicatorColors[currentKey], cp.Swatch2, classId, specId)
			end)
			cp.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
				if mouseButton == "LeftButton" then
					local currentKey = orderedKeys[capturedRowIdx]
					local currentEntry = indicatorColors[currentKey]
					if not currentEntry then return end
					currentEntry.gradientDirection = currentEntry.gradientDirection or "disabled"
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
			---@diagnostic disable-next-line: inject-field
			cp.UpdateSwatch2State = function()
				local currentKey = orderedKeys[capturedRowIdx]
				local currentEntry = indicatorColors[currentKey]
				if not currentEntry then return end
				currentEntry.color2 = currentEntry.color2 or currentEntry.color
				currentEntry.gradientDirection = currentEntry.gradientDirection or "disabled"
				cp.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(currentEntry.color2, true))
				if currentEntry.gradientDirection == "disabled" then
					cp.Swatch2:SetAlpha(0.35)
					cp.Swatch2:EnableMouse(false)
				else
					cp.Swatch2:SetAlpha(1.0)
					cp.Swatch2:EnableMouse(true)
				end
				cp.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[currentEntry.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
			end
			---@cast cp Button
			TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(cp, indicator.enabled)
			row.colorPicker = cp

			-- Store row controls for the color picker callback
			controls.indicatorColors.rows[rowIndex] = row

			yCoord = yCoord - 30
		end
	end

	-- Gradient Color Overrides section
	if #gradientDefs > 0 then
		yCoord = yCoord - 10
		controls.textSectionGradient = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["GradientColorOverridesHeader"], oUi.xCoord, yCoord)
		yCoord = yCoord - 30

		-- Note explaining gradient behavior
		controls.gradientNote = TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, L["GradientColorOverridesNote"], oUi.xCoord, yCoord, oUi.maxOptionsWidth, 28)
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
				TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
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
					for _, barDef in ipairs(barTargetDefs) do
						local barElementDefs = barDef.elements or defaultElementDefs
						-- An element is off-limits to a gradient row if the panel excludes it outright, the caller
						-- excludes it from gradients, or the bar itself declares it can't take a color curve.
						local function IsGradientExcluded(elemKey)
							local globalExcluded = excludedElements[barDef.key]
							local gradExcluded = gradientExcludedElements[barDef.key]
							local barExcluded = barDef.gradientExcluded
							return (globalExcluded and globalExcluded[elemKey])
								or (gradExcluded and gradExcluded[elemKey])
								or (barExcluded and barExcluded[elemKey]) or false
						end

						local allExcluded = true
						for _, elemDef in ipairs(barElementDefs) do
							if not IsGradientExcluded(elemDef.key) then
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

							for _, elemDef in ipairs(barElementDefs) do
								if not IsGradientExcluded(elemDef.key) then
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
											SyncEnabled(indicator, gradRow.colorPicker)
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
				local cp = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, gradDef.colorLabel, gradIndicator.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
				---@cast cp Button
				cp:SetScript("OnMouseDown", function(self, button)
					local gk = orderedGradientKeys[capturedGradIdx]
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, indicatorColors, { [gk] = gradRow.colorPicker }, gk, "indicatorColor_" .. gk)
				end)
				TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(cp, gradIndicator.enabled)
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
			yCoord = TRB.Functions.OptionsUi.Colors:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, endOfConfig)
		end
	end

	-- Optional Overcap configuration
	if config.overcapConfig then
		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi.Colors:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, config.overcapConfig.primaryResourceString, config.overcapConfig.primaryResourceMax)
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
function TRB.Functions.OptionsUi.Indicators:BuildOverlayFullHeightCheckbox(parent, frameName, parentX, yCoord, isChecked, onClick)
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
function TRB.Functions.OptionsUi.Indicators:RefreshOverlayGeometryPreview(classId, specId)
	if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
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

