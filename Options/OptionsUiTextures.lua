---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Textures = TRB.Functions.OptionsUi.Textures or {}
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
-- Texture dropdowns and texture option panels
-- ============================================================================
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
function TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString, includeManaBar, customBars, includeComboPointsCastingOverlay)
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
function TRB.Functions.OptionsUi.Textures:GenerateFlashOptions(parent, controls, spec, classId, specId, yCoord, flashAlphaName, flashAlphaNameShort)
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

