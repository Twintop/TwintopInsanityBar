---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Profiles = TRB.Functions.OptionsUi.Profiles or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Profile management dropdown (Phase 2B + 2C)


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
function TRB.Functions.OptionsUi.Profiles:ShowProfileImportPopup(onComplete)
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
function TRB.Functions.OptionsUi.Profiles:BuildProfileDropdown(parent, yCoord, scope, className, specName, specLabel)
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
		TRB.Functions.OptionsUi.Profiles:ShowProfileImportPopup()
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
function TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, specLabel, enabledSettingRef, enabledKey, checkboxName, checkboxControlKey, className, specName)
	local yCoord = 0

	-- Section header (left-aligned)
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, specLabel, oUi.xCoord, yCoord - 5)

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

