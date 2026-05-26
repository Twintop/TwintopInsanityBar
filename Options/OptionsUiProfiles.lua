---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Profiles = TRB.Functions.OptionsUi.Profiles or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Profile management dropdown (Phase 2B + 2C)


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
function TRB.Functions.OptionsUi.Profiles:RefreshProfileDropdownForScope(scope, className, specName)
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


---Builds a profile-management dropdown anchored to the top-right of `parent`.
---Used by both `BuildSpecTitleRow` (spec scope) and Global Options (core scope).
---@param parent Frame
---@param yCoord number # vertical offset from parent's top-right
---@param scope "spec"|"core"
---@param className string? # required when scope=="spec"
---@param specName string? # required when scope=="spec"
---@param specLabel string? # localized label used in popup text for spec scope
---@return DropdownButton dropdown
function TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, yCoord, scope, className, specName, specLabel)
	TRB.Functions.OptionsUi.ProfilePopups:EnsureRegistered()

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
		TRB.Functions.OptionsUi.ProfilePopups:ShowProfileImportPopup()
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
			StaticPopup_Show("TwintopResourceBar_Profile_CopyOverwriteConfirm", destinationName, TRB.Functions.OptionsUi.ProfilePopups:GetScopeLabel(data), data)
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
TRB.Functions.OptionsUi.ProfilePopups:EnsureRegistered()

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
function TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, specLabel, enabledSettingRef, enabledKey, checkboxName, checkboxControlKey, className, specName)
	local yCoord = 0

	-- Section header (left-aligned)
	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, specLabel, oUi.xCoord, yCoord - 5)

	-- Profile dropdown (rightmost, anchored to parent's top-right)
	controls.profileDropdown = TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, yCoord - 10, "spec", className, specName, specLabel)
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
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)
		if TRB.Options.OptionsFrame then
			TRB.Options.OptionsFrame:RefreshNav()
		end
	end)
	TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)

	-- Position checkbox: anchor its right edge left of the dropdown, leaving room for the label text.
	cb:SetPoint("RIGHT", dropdown, "LEFT", -75, 0)

	return yCoord - 37
end

