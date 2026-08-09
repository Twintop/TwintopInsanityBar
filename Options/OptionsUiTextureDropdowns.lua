---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.TextureDropdowns = TRB.Functions.OptionsUi.TextureDropdowns or {}
local oUi = TRB.Data.constants.optionsUi

-- ============================================================================
-- LibSharedMedia texture dropdown helpers
-- ============================================================================
local backgrounds = {}
local backgroundsList = {}
local backgroundPairs = {}
local backgroundPairsByName = {}
---Populates the background texture cache from LibSharedMedia if not already filled.
local function FillBackgroundCache()
	if TRB.Functions.Table:Length(backgrounds) == 0 then
		backgrounds = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
		backgroundsList = TRB.Details.addonData.libs.SharedMedia:List("background")

		for k, v in pairs(backgroundsList) do
			table.insert(backgroundPairs, { v, backgrounds[v] })
			backgroundPairsByName[backgrounds[v]] = v
		end
	end
end

---@return table backgroundPairsByName
function TRB.Functions.OptionsUi.TextureDropdowns:GetBackgroundPairsByName()
	FillBackgroundCache()
	return backgroundPairsByName
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

		for k, v in pairs(bordersList) do
			table.insert(borderPairs, { v, borders[v] })
			borderPairsByName[borders[v]] = v
		end
	end
end

---@return table borderPairsByName
function TRB.Functions.OptionsUi.TextureDropdowns:GetBorderPairsByName()
	FillBorderCache()
	return borderPairsByName
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

		for k, v in pairs(statusbarsList) do
			table.insert(statusbarPairs, { v, statusbars[v] })
			statusbarPairsByName[statusbars[v]] = v
		end
	end
end

---Refreshes a WowStyle1DropdownTemplate control by re-invoking its stored GeneratorFunction.
---@param control DropdownButton # The dropdown control with a GeneratorFunction field
local function DropdownSetupMenuWrapper(control)
	if control == nil then
		return
	end

	control:SetupMenu(control.GeneratorFunction)
end

local function SetDropdownDisplayText(control, text)
	if control == nil or text == nil then
		return
	end

	if type(control.SetDefaultText) == "function" then
		control:SetDefaultText(text)
	end
	if type(control.SetText) == "function" then
		control:SetText(text)
	elseif control.Text ~= nil and type(control.Text.SetText) == "function" then
		control.Text:SetText(text)
	end
end

local function RefreshLsmDropdown(control, displayText)
	DropdownSetupMenuWrapper(control)
	SetDropdownDisplayText(control, displayText)
end

---@param control DropdownButton? # The dropdown control to refresh
---@param displayText string? # Optional text to show on the dropdown button
function TRB.Functions.OptionsUi.TextureDropdowns:RefreshLsmDropdown(control, displayText)
	RefreshLsmDropdown(control, displayText)
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
function TRB.Functions.OptionsUi.TextureDropdowns:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText, setSelectedFunc)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local lsmPairs
	local lsmPairsByName

	if lsmType == "statusbar" then
		FillStatusbarCache()
		lsmPairs = statusbarPairs
		lsmPairsByName = statusbarPairsByName
	elseif lsmType == "background" then
		FillBackgroundCache()
		lsmPairs = backgroundPairs
		lsmPairsByName = backgroundPairsByName
	elseif lsmType == "border" then
		FillBorderCache()
		lsmPairs = borderPairs
		lsmPairsByName = borderPairsByName
	end

	dropDowns[varName] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. varName .. "_" .. lsmType, parent, "WowStyle1DropdownTemplate")
	dropDowns[varName]:SetWidth(oUi.sliderWidth)
	dropDowns[varName].label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
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
	SetDropdownDisplayText(dropDowns[varName], lsmPairsByName[section[varName]] or section[varName .. "Name"] or dropdownInfoText)
	dropDowns[varName]:SetPoint("TOPLEFT", xCoord, yCoord-30)
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
function TRB.Functions.OptionsUi.TextureDropdowns:UpdateStatusbarDropdowns(controls, textures, newValue, variable, includeComboPoints, includeManaBar, customBars, includeComboPointsCastingOverlay)
	FillStatusbarCache()
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
	-- Castbar is an all-spec bar; include it in every texture dropdown set without per-class wiring.
	TRB.Classes.BarTypeRegistry:GetInstance():AppendCastbar(customBars)
	-- Target and Focus Cast Bars are likewise all-spec; include them in every texture dropdown set.
	TRB.Classes.BarTypeRegistry:GetInstance():AppendTargetFocusCastbars(customBars)
	-- Other Bars (GCD + mirror timers) too. This callback doesn't know which class's panel it is serving,
	-- so it takes every key regardless of scope and the sync loop below skips the ones this panel has no
	-- dropdown for -- otherwise texture lock would quietly pass over the Hunter-only Feign Death bar.
	TRB.Classes.BarTypeRegistry:GetInstance():AppendOtherBars(customBars, nil, true)

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	RefreshLsmDropdown(controls[variable.."Bar"], newName)
	if textures.textureLock then
		textures.resourceBar = newValue
		textures.resourceBarName = newName
		RefreshLsmDropdown(controls.resourceBar, newName)

		if includeComboPoints then
			textures.comboPointsBar = newValue
			textures.comboPointsBarName = newName
			RefreshLsmDropdown(controls.comboPointsBar, newName)

			if includeComboPointsCastingOverlay then
				textures.comboPointsCastingBar = newValue
				textures.comboPointsCastingBarName = newName
				RefreshLsmDropdown(controls.comboPointsCastingBar, newName)
			end
		end

		if includeManaBar then
			textures.manaBarBar = newValue
			textures.manaBarBarName = newName
			RefreshLsmDropdown(controls.manaBarBar, newName)
		end

		-- Sync custom bar textures
		for _, barTypeDef in ipairs(customBars) do
			local barKey = barTypeDef.key .. "Bar"
			-- Some all-spec bars are scoped out of a given panel (Feign Death is Hunter-only), so only
			-- sync the ones this panel actually built a dropdown for.
			if controls[barKey] ~= nil then
				textures[barKey] = newValue
				textures[barKey .. "Name"] = newName
				RefreshLsmDropdown(controls[barKey], newName)
			end
		end

		textures.healthBar = newValue
		textures.healthBarName = newName
		RefreshLsmDropdown(controls.healthBar, newName)

		textures.castingBar = newValue
		textures.castingBarName = newName
		RefreshLsmDropdown(controls.castingBar, newName)
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
function TRB.Functions.OptionsUi.TextureDropdowns:UpdateOverlayDropdowns(controls, textures, newValue, variable)
	FillStatusbarCache()
	local newName = statusbarPairsByName[newValue]

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	RefreshLsmDropdown(controls[variable.."Bar"], newName)
	if textures.textureLock then
		-- Sync all overlay textures to the changed value.
		textures.absorbBar = newValue
		textures.absorbBarName = newName
		RefreshLsmDropdown(controls.absorbBar, newName)
		textures.incomingHealBar = newValue
		textures.incomingHealBarName = newName
		RefreshLsmDropdown(controls.incomingHealBar, newName)
		textures.healAbsorbBar = newValue
		textures.healAbsorbBarName = newName
		RefreshLsmDropdown(controls.healAbsorbBar, newName)
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

