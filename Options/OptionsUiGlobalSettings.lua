---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.GlobalSettings = TRB.Functions.OptionsUi.GlobalSettings or {}
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
-- Global settings toggles and copy menus
-- ============================================================================
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

---@param settingKey string
---@return table?
function TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(settingKey)
	return globalSettingDefinitions[settingKey]
end

---Returns true if the panel being edited belongs to (or affects) the currently active spec.
---Used to guard live-preview callbacks so editing a non-active spec's settings doesn't
---trigger unnecessary or incorrect bar updates.
---@param classId integer? # Class ID of the panel being edited (nil for global panel)
---@param specId integer? # Spec ID of the panel being edited (nil for global panel)
---@return boolean
function TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId)
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
function TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, controlKey, settingKey, yCoord, customLabel, customTooltip)
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
function TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox(settingKey)
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
function TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(checkbox, globalTabKey)
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
			TRB.Functions.OptionsUi.Profiles:RefreshProfileDropdownForScope(data.dstScope, data.dstClassName, data.dstSpecName)
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
function TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalCopyButton(checkbox, classId, specId, settingKey)
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
function TRB.Functions.OptionsUi.GlobalSettings:BuildGlobalBulkCopyButton(bulkCheckbox, settingKey)
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

