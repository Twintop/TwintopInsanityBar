local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Textures = TRB.Functions.OptionsUi.Textures or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Texture dropdowns and texture option panels
-- ============================================================================

-- Session-only, never saved: whether a scope's spec tab also lists the bars that have their own groupings' tabs.
local includeAllGroups = {}

-- Each built Textures tab, by scope then grouping, so a change on one tab reaches the others and a cover can open a row.
---@type table<string, table<string, { Refresh: fun(), SelectBarKey: fun(barKey: string) }>>
local texturesEditors = {}

local dimColor = { r = 0.5, g = 0.5, b = 0.5, a = 0.7 }
local TABLE_ROW_COUNT = 8

local lockGroups = TRB.Functions.Settings.textureLockGroups

---@param classId integer?
---@param specId integer?
---@return string
local function GetScopeKey(classId, specId)
	if classId == nil then
		return "global"
	end
	return classId .. "_" .. specId
end

---Every texture key a lock matches to its source.
---@param lockName string
---@return string[]
local function GetLockMembers(lockName)
	local group = lockGroups[lockName]
	local members = {}
	for _, key in ipairs(group.fixed) do
		members[#members + 1] = key
	end
	if group.suffix ~= nil then
		for prefix in pairs(TRB.Classes.BarTypeRegistry:GetInstance():GetAll()) do
			members[#members + 1] = prefix .. group.suffix
		end
	end
	return members
end

---@type table<string, { lock: string, isSource: boolean }>?
local lockByKey = nil

---The lock that governs a texture key, and whether the key is the texture the others copy.
---@param key string
---@return string? lockName
---@return boolean isSource
local function GetLockOfKey(key)
	if lockByKey == nil then
		lockByKey = {}
		for lockName, group in pairs(lockGroups) do
			for _, member in ipairs(GetLockMembers(lockName)) do
				lockByKey[member] = { lock = lockName, isSource = false }
			end
			lockByKey[group.source] = { lock = lockName, isSource = true }
		end
	end
	local found = lockByKey[key]
	if found == nil then
		return nil, false
	end
	return found.lock, found.isSource
end

---Copies a lock's source texture to everything the lock matches that the table holds.
---@param textures table
---@param lockName string
local function SyncLock(textures, lockName)
	local source = lockGroups[lockName].source
	local value = textures[source]
	if value == nil then
		return
	end
	local name = textures[source .. "Name"]
	for _, key in ipairs(GetLockMembers(lockName)) do
		if textures[key] ~= nil then
			textures[key] = value
			textures[key .. "Name"] = name
		end
	end
end

---Applies a changed texture to the active bar, when the panel edits it.
---@param classId integer?
---@param specId integer?
local function RefreshBar(classId, specId)
	if not TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
		return
	end
	TRB.Functions.Character:ResetCaches()
	if TRB.Frames.barGroups ~= nil then
		local character = TRB.Data.character
		-- The cache holds its own copy of global textures, so an edit only reaches the bar through a re-fill.
		TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
		local settings = TRB.Data.specCache[character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end
end

---Re-fills every specialization's cache that has been initialized, then applies the result to the active bar.
local function RefreshAllSpecs()
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		if TRB.Data.specCache[entry.compositeKey] then
			TRB.Functions.Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
	end
	RefreshBar(nil, nil)
end

---Opens a bar's row on the Global Options Textures tab that lists it, switching to the Global screen that holds it.
---@param barKey string
function TRB.Functions.OptionsUi.Textures:OpenGlobalTextures(barKey)
	if TRB.Options.OptionsFrame == nil then
		return
	end
	local barGroup = TRB.Classes.BarTypeRegistry:GetBarGroup(barKey)
	local tabs = TRB.Functions.OptionsUi.Tabs
	TRB.Options.OptionsFrame:SelectCategory(barGroup == "spec" and "global" or barGroup)
	-- The category's tabs exist only after it is selected.
	C_Timer.After(0, function()
		if barGroup == "spec" then
			tabs:SwitchToTabByNamePrefix("Global", tabs.TabKeys.BarTextures)
		else
			tabs:SwitchToTabByNamePrefix(tabs:GetGroupInnerPrefix(barGroup, nil, nil), tabs.TabKeys.GroupTextures)
		end
		local editor = texturesEditors.global and texturesEditors.global[barGroup]
		if editor ~= nil then
			editor.SelectBarKey(barKey)
		end
	end)
end

---Generates the bar textures options: a table of the bars with a detail panel for the selected bar's fill, border,
---background, and overlay textures, and the locks that keep a kind of texture the same across the bars.
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
---@param options { groupKey: string? }? Which grouping's bars to list; nil is the spec's own tab
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString, includeManaBar, customBars, includeComboPointsCastingOverlay, options)
	includeComboPoints = includeComboPoints == true
	includeComboPointsCastingOverlay = includeComboPointsCastingOverlay == true
	includeManaBar = includeManaBar == true
	customBars = customBars or {}
	local barRegistry = TRB.Classes.BarTypeRegistry:GetInstance()
	-- Castbar is an all-spec bar; include it in every textures panel without per-class wiring.
	barRegistry:AppendCastbar(customBars)
	-- Target and Focus Cast Bars are likewise all-spec; include them in every textures panel.
	barRegistry:AppendTargetFocusCastbars(customBars)
	-- Other Bars too, scoped so Feign Death only appears for Hunters.
	barRegistry:AppendOtherBars(customBars, classId)
	-- Pet bars, scoped so they only appear on the specs that can hold a permanent pet.
	barRegistry:AppendPetBars(customBars, classId, specId)
	barRegistry:AppendSkyridingBars(customBars)

	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	local groupKey = options and options.groupKey or "spec"
	local scopeKey = GetScopeKey(classId, specId)
	local isSpecScope = classId ~= nil and specId ~= nil
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. (groupKey == "spec" and "" or "_" .. groupKey)
	local primitives = TRB.Functions.OptionsUi.Primitives
	local textureDropdowns = TRB.Functions.OptionsUi.TextureDropdowns
	local settingsFunctions = TRB.Functions.Settings
	local textures = spec.textures
	local coreTextures = TRB.Data.settings.core.textures
	local globalBars = settingsFunctions:GetGlobalTextureBars()
	local f = nil

	-- ===== The bars this scope can texture, in the order the table lists them =====
	---@type table[]
	local allRows = {}
	---@type table<string, table>
	local rowsByKey = {}
	-- The row and item each texture key belongs to, so a lock's tooltip can name its source.
	---@type table<string, table>
	local rowByTextureKey = {}
	---@type table<string, table>
	local itemByTextureKey = {}
	---@param key string
	---@param label string
	---@param lsmType string
	local function Item(key, label, lsmType)
		return { key = key, label = label, lsmType = lsmType }
	end
	---@param row table
	local function AddRow(row)
		if rowsByKey[row.key] ~= nil then
			return
		end
		row.canUseGlobal = isSpecScope and globalBars.set[row.key] == true
		row.isRegistryBar = barRegistry:Get(row.key) ~= nil
		rowsByKey[row.key] = row
		allRows[#allRows + 1] = row
		for _, item in ipairs(row.items) do
			rowByTextureKey[item.key] = row
			itemByTextureKey[item.key] = item
		end
	end

	AddRow({ key = "primary", label = TRB.Functions.Bar:GetSpecResourceBarName("primary", classId, specId) or L["MainResourceBar"], items = {
		Item("resourceBar", L["MainBarTexture"], "statusbar"),
		Item("border", L["BorderTexture"], "border"),
		Item("background", L["BackgroundTexture"], "background"),
		Item("castingBar", L["CastingBarTexture"], "statusbar"),
	} })
	if includeComboPoints then
		local items = {
			Item("comboPointsBar", string.format(L["SecondaryBarTexture"], secondaryResourceString), "statusbar"),
			Item("comboPointsBorder", string.format(L["SecondaryBorderTexture"], secondaryResourceString), "border"),
			Item("comboPointsBackground", string.format(L["SecondaryBackgroundTexture"], secondaryResourceString), "background"),
		}
		if includeComboPointsCastingOverlay then
			items[#items + 1] = Item("comboPointsCastingBar", string.format(L["SecondaryCastingOverlayTexture"], secondaryResourceString), "statusbar")
		end
		AddRow({ key = "secondary", label = secondaryResourceString, items = items })
	end
	AddRow({ key = "health", label = L["HealthBar"], items = {
		Item("healthBar", L["HealthBarTexture"], "statusbar"),
		Item("healthBorder", L["HealthBorderTexture"], "border"),
		Item("healthBackground", L["HealthBackgroundTexture"], "background"),
		Item("absorbBar", L["AbsorbBarTexture"], "statusbar"),
		Item("incomingHealBar", L["IncomingHealBarTexture"], "statusbar"),
		Item("healAbsorbBar", L["HealAbsorbBarTexture"], "statusbar"),
	} })
	if includeManaBar then
		local manaDefinition = barRegistry:Get("mana")
		AddRow({ key = "mana", label = manaDefinition and manaDefinition.displayName or L["BarNameManaBar"], items = {
			Item("manaBar", L["ManaBarTexture"], "statusbar"),
			Item("manaBorder", L["ManaBarBorderTexture"], "border"),
			Item("manaBackground", L["ManaBarBackgroundTexture"], "background"),
		} })
	end
	for _, barTypeDef in ipairs(customBars) do
		-- Cast bar display names already end in "Bar", so use a label that omits the redundant trailing "Bar".
		local barLabel = barTypeDef.isCastbar and L["CustomBarTextureCastbarBar"] or L["CustomBarTextureBar"]
		-- A class module may rename a shared bar after its own use of it, which Global Options must not show.
		local barName = isSpecScope and barTypeDef.displayName or barTypeDef.globalDisplayName
		AddRow({ key = barTypeDef.key, label = barName, items = {
			Item(barTypeDef.key .. "Bar", string.format(barLabel, barName), "statusbar"),
			Item(barTypeDef.key .. "Border", string.format(L["CustomBarTextureBorder"], barName), "border"),
			Item(barTypeDef.key .. "Background", string.format(L["CustomBarTextureBackground"], barName), "background"),
		} })
	end

	-- Mutated in place: the table, detail panel, and handlers below all close over it.
	local listedRows = {}
	local function RebuildRows()
		for index = #listedRows, 1, -1 do
			listedRows[index] = nil
		end
		for _, row in ipairs(allRows) do
			if TRB.Classes.BarTypeRegistry:IsBarInGroupScope(row.key, groupKey, includeAllGroups[scopeKey]) then
				listedRows[#listedRows + 1] = row
			end
		end
	end
	RebuildRows()

	-- ===== Who owns what =====
	---Whether the main bar's textures, and the locks that match every bar to them, come from Global Options.
	local function PrimaryFollowsGlobal()
		return isSpecScope and (textures.useGlobal == nil or textures.useGlobal.primary ~= false)
	end
	---@param row table
	local function IsFollowingGlobal(row)
		return row.canUseGlobal and (textures.useGlobal == nil or textures.useGlobal[row.key] ~= false)
	end
	---The table a bar's textures are read from and written to.
	---@param row table
	local function OwnerTextures(row)
		return IsFollowingGlobal(row) and coreTextures or textures
	end
	---The table whose locks apply: the main bar's owner decides them.
	local function LockTextures()
		return PrimaryFollowsGlobal() and coreTextures or textures
	end
	---Whether a texture is one a lock is currently matching to another, so it cannot be changed on its own.
	---@param key string
	local function IsLockedMember(key)
		local lockName, isSource = GetLockOfKey(key)
		return lockName ~= nil and not isSource and LockTextures()[lockName] == true
	end

	---Whether a locked texture draws its lock's source instead of its own copy, as ResolveTextures applies it: a registered
	---bar always does, and a main bar whose textures are owned apart from the main bar's.
	---@param row table
	---@param item table
	local function DrawsLockSource(row, item)
		return IsLockedMember(item.key) and (row.isRegistryBar or IsFollowingGlobal(row) ~= PrimaryFollowsGlobal())
	end

	---The texture name a bar draws with for one of its textures.
	---@param row table
	---@param item table
	local function DisplayName(row, item)
		if DrawsLockSource(row, item) then
			local source = lockGroups[GetLockOfKey(item.key)].source
			local sourceRow = rowByTextureKey[source]
			return (sourceRow ~= nil and OwnerTextures(sourceRow) or LockTextures())[source .. "Name"]
		end
		return OwnerTextures(row)[item.key .. "Name"]
	end

	---@param barKey string
	local function CopyGlobalRow(barKey)
		for _, key in ipairs(settingsFunctions:GetTextureKeysForBar(barKey).all) do
			if coreTextures[key] ~= nil then
				textures[key] = coreTextures[key]
				textures[key .. "Name"] = coreTextures[key .. "Name"]
			end
		end
	end
	---Opting a bar out starts it from the textures it was showing, which are Global's.
	---@param barKey string
	---@param useGlobal boolean
	local function SetRowUsesGlobal(barKey, useGlobal)
		textures.useGlobal = textures.useGlobal or {}
		if useGlobal then
			textures.useGlobal[barKey] = nil
		else
			if textures.useGlobal[barKey] ~= false then
				CopyGlobalRow(barKey)
			end
			textures.useGlobal[barKey] = false
		end
	end

	---All, none, or some of a count: true, false, or nil.
	---@param followed integer
	---@param total integer
	---@return boolean|nil
	local function GetUseGlobalState(followed, total)
		if followed == total then
			return true
		elseif followed == 0 then
			return false
		end
		return nil
	end

	-- Redraws everything on this scope's Textures tabs; assigned once they exist.
	---@type fun()
	local RefreshEditors = function() end
	---Applies an edit to the bar and every tab of this scope.
	local function AfterChange()
		if isSpecScope then
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
		end
		RefreshBar(classId, specId)
		RefreshEditors()
	end

	-- ===== Header, Use Global, and locks =====
	local sectionTitle = L["BarTexturesHeader"]
	if groupKey == "castbar" then
		sectionTitle = L["BarTexturesHeaderCastbar"]
	elseif groupKey == "otherBars" then
		sectionTitle = L["BarTexturesHeaderOtherBars"]
	elseif groupKey == "petBars" then
		sectionTitle = L["BarTexturesHeaderPetBars"]
	elseif groupKey == "skyriding" then
		sectionTitle = L["BarTexturesHeaderSkyriding"]
	end
	controls.textBarTexturesSection = primitives:BuildSectionHeader(parent, sectionTitle, oUi.xCoord, yCoord)

	-- Redraws the table, detail panel, and boxes from the settings; assigned below.
	---@type fun()
	local Refresh = function() end

	local useGlobalBox = nil
	if isSpecScope then
		yCoord = yCoord - 30
		useGlobalBox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useGlobal_textures", parent, "ChatConfigCheckButtonTemplate")
		f = useGlobalBox
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarTexturesUseGlobalAll"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		if groupKey == "spec" then
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "barTextures")
		else
			TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, TRB.Functions.OptionsUi.Tabs.TabKeys.GroupTextures, groupKey)
		end
		f.tooltip = L["BarTexturesUseGlobalAllTooltip"]
		f:SetScript("OnClick", function()
			-- Checked gives every listed bar its own textures; unchecked or mixed puts them all back on Global Options.
			local useGlobal = true
			local followed, total = 0, 0
			for _, row in ipairs(listedRows) do
				if row.canUseGlobal then
					total = total + 1
					if IsFollowingGlobal(row) then
						followed = followed + 1
					end
				end
			end
			useGlobal = followed ~= total
			for _, row in ipairs(listedRows) do
				if row.canUseGlobal then
					SetRowUsesGlobal(row.key, useGlobal)
				end
			end
			AfterChange()
		end)
	else
		-- Global options panel: one box for the listed bars in every specialization.
		yCoord = yCoord - 30
		useGlobalBox = CreateFrame("CheckButton", "TwintopResourceBar_Global_enableAll_textures" .. (groupKey == "spec" and "" or "_" .. groupKey), parent, "ChatConfigCheckButtonTemplate")
		f = useGlobalBox
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarTexturesUseGlobalAllSpecs"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		f.tooltip = L["BarTexturesUseGlobalAllSpecsTooltip"]
		f.specCount = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.specCount:SetTextColor(0.75, 0.75, 0.75)
		-- The template's label keeps its own width, so sit past the rendered text rather than its right edge.
		f.specCount:SetPoint("LEFT", f, "RIGHT", getglobal(f:GetName() .. 'Text'):GetStringWidth() + 14, 0)
		f:SetScript("OnClick", function()
			local followed, total = 0, 0
			for _, specEntry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
				local classPiece = TRB.Data.settings[specEntry.className]
				local piece = classPiece and classPiece[specEntry.specName]
				local specTextures = piece and piece.textures
				if specTextures ~= nil then
					for _, row in ipairs(listedRows) do
						if globalBars.set[row.key] then
							total = total + 1
							if specTextures.useGlobal == nil or specTextures.useGlobal[row.key] ~= false then
								followed = followed + 1
							end
						end
					end
				end
			end
			local useGlobal = followed ~= total
			for _, specEntry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
				local classPiece = TRB.Data.settings[specEntry.className]
				local piece = classPiece and classPiece[specEntry.specName]
				local specTextures = piece and piece.textures
				if specTextures ~= nil then
					specTextures.useGlobal = specTextures.useGlobal or {}
					for _, row in ipairs(listedRows) do
						if globalBars.set[row.key] then
							if useGlobal then
								specTextures.useGlobal[row.key] = nil
							else
								if specTextures.useGlobal[row.key] ~= false then
									for _, key in ipairs(settingsFunctions:GetTextureKeysForBar(row.key).all) do
										if coreTextures[key] ~= nil then
											specTextures[key] = coreTextures[key]
											specTextures[key .. "Name"] = coreTextures[key .. "Name"]
										end
									end
								end
								specTextures.useGlobal[row.key] = false
							end
						end
					end
				end
			end
			RefreshAllSpecs()
			RefreshEditors()
		end)
	end

	-- Re-lists the table; assigned once the table exists.
	---@type fun()
	local ReloadRows = function() end
	if groupKey == "spec" then
		yCoord = yCoord - 20
		controls.checkBoxes.includeAllGroups = primitives:BuildCheckboxRow(parent, "TwintopResourceBar_" .. namePrefix .. "_includeAllGroups",
			L["CheckboxIncludeAllBarGroups"], L["CheckboxIncludeAllBarGroupsTooltip"], yCoord,
			function() return includeAllGroups[scopeKey] == true end,
			function(checked)
				includeAllGroups[scopeKey] = checked
				ReloadRows()
			end)
		-- Lined up with the Use Global box above it.
		controls.checkBoxes.includeAllGroups:ClearAllPoints()
		controls.checkBoxes.includeAllGroups:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	end

	-- The four locks, two to a row.
	local lockBoxes = {}
	---@type table<string, string>
	local lockLabels = {}
	local lockDefinitions = {
		{ lock = "lockBar", label = L["TextureLockBar"], tooltip = L["TextureLockBarTooltip"] },
		{ lock = "lockBorder", label = L["TextureLockBorder"], tooltip = L["TextureLockBorderTooltip"] },
		{ lock = "lockBackground", label = L["TextureLockBackground"], tooltip = L["TextureLockBackgroundTooltip"] },
		{ lock = "lockOverlay", label = L["TextureLockOverlay"], tooltip = L["TextureLockOverlayTooltip"] },
	}
	yCoord = yCoord - 10
	for index, definition in ipairs(lockDefinitions) do
		if index % 2 == 1 then
			yCoord = yCoord - 20
		end
		local lockName = definition.lock
		local box = primitives:BuildCheckboxRow(parent, "TwintopResourceBar_" .. namePrefix .. "_" .. lockName, definition.label, definition.tooltip, yCoord,
			function() return LockTextures()[lockName] == true end,
			function(checked)
				textures[lockName] = checked
				if checked then
					SyncLock(textures, lockName)
				end
				AfterChange()
			end)
		if index % 2 == 0 then
			box:ClearAllPoints()
			box:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		end
		-- Disabled while Global Options holds the locks, and its tooltip says so.
		box:SetMotionScriptsWhileDisabled(true)
		box.baseTooltip = definition.tooltip
		lockBoxes[lockName] = box
		lockLabels[lockName] = definition.label
	end

	---Why a texture cannot be changed on its own, for its dropdown's and table cell's tooltip; nil when it can.
	---@param row table
	---@param item table
	---@return string?
	local function GetDisabledReason(row, item)
		local reasons = {}
		if IsFollowingGlobal(row) then
			reasons[#reasons + 1] = L["BarTexturesFollowsGlobalTooltip"]
		end
		if IsLockedMember(item.key) then
			local lockName = GetLockOfKey(item.key) --[[@as string]]
			local source = lockGroups[lockName].source
			local sourceRow = rowByTextureKey[source]
			local sourceItem = itemByTextureKey[source]
			local sourceName = DisplayName(sourceRow, sourceItem) or ""
			if PrimaryFollowsGlobal() then
				reasons[#reasons + 1] = string.format(L["BarTexturesLockedGlobalTooltip"], lockLabels[lockName], sourceItem.label, sourceName, sourceRow.label, rowsByKey.primary.label)
			else
				reasons[#reasons + 1] = string.format(L["BarTexturesLockedTooltip"], lockLabels[lockName], sourceItem.label, sourceName, sourceRow.label)
			end
		end
		if #reasons == 0 then
			return nil
		end
		return table.concat(reasons, "\n\n")
	end

	yCoord = yCoord - 24
	controls.labels = controls.labels or {}
	controls.labels.texturesLockedNote = primitives:BuildLabel(parent, L["BarTexturesLockedNote"], oUi.xCoord, yCoord, 600, 18, GameFontHighlightSmall, "LEFT")
	yCoord = yCoord - 28

	-- ===== The table =====
	-- Narrow enough, with the last column at its minimum, to fit a grouping's tab nested inside a specialization's.
	local columns = {
		{ ["name"] = "Key", ["width"] = 1, ["align"] = "CENTER" },
		{ ["name"] = L["BarTexturesTableHeaderBar"], ["width"] = 170, ["align"] = "LEFT" },
		{ ["name"] = L["BarTexturesTableHeaderFill"], ["width"] = 110, ["align"] = "LEFT" },
		{ ["name"] = L["BarTexturesTableHeaderBorder"], ["width"] = 110, ["align"] = "LEFT" },
		{ ["name"] = L["BarTexturesTableHeaderBackground"], ["width"] = 110, ["align"] = "LEFT" },
	}
	if isSpecScope then
		columns[#columns + 1] = { ["name"] = L["BarTexturesTableHeaderSource"], ["width"] = 150, ["align"] = "LEFT" }
	end
	-- The last column takes whatever width is left.
	local fillColumn = columns[#columns]

	local container = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	container:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	container:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	container:SetHeight(35 + (TABLE_ROW_COUNT * 15))

	local barTexturesTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, TABLE_ROW_COUNT, 15, nil, container, false, false)

	-- Dynamically resize the last column to fill available width
	container:HookScript("OnSizeChanged", function(_, w)
		local fixedWidth = 0
		for _, column in ipairs(columns) do
			if column ~= fillColumn then
				fixedWidth = fixedWidth + column.width
			end
		end
		fillColumn.width = math.max(100, w - fixedWidth - 30)
		barTexturesTable:SetDisplayCols(columns)
	end)

	local selectedKey = nil

	---Refreshes the scrolling table from the current textures and keeps the open bar highlighted.
	local function SetTableValues()
		local dataTable = {}
		local selectedRow = nil
		for index, row in ipairs(listedRows) do
			local followsGlobal = IsFollowingGlobal(row)
			local function Cell(item)
				local locked = IsLockedMember(item.key)
				return { value = DisplayName(row, item) or "", color = locked and dimColor or nil }
			end
			local cols = {
				{ value = row.key },
				{ value = row.label },
				Cell(row.items[1]),
				Cell(row.items[2]),
				Cell(row.items[3]),
			}
			if isSpecScope then
				cols[#cols + 1] = { value = row.canUseGlobal and (followsGlobal and L["BarVisibilitySettingsSourceGlobal"] or L["BarVisibilitySettingsSourceSpec"]) or L["BarVisibilitySettingsSourceSpec"] }
			end
			dataTable[#dataTable + 1] = { cols = cols, color = followsGlobal and dimColor or nil }
			if row.key == selectedKey then
				selectedRow = index
			end
		end
		barTexturesTable:SetData(dataTable)
		barTexturesTable:EnableSelection(true)
		if selectedRow ~= nil then
			barTexturesTable:SetSelection(selectedRow)
		end
	end

	-- ===== The selected bar's textures =====
	yCoord = yCoord - (35 + (TABLE_ROW_COUNT * 15))
	-- Room for the health bar's six dropdowns, the most a bar has.
	local detailHeight = 270
	local detailFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarTexturesDetail", parent, "BackdropTemplate")
	detailFrame:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 0, 0)
	detailFrame:SetPoint("TOPRIGHT", container, "BOTTOMRIGHT", 0, 0)
	detailFrame:SetHeight(detailHeight)
	detailFrame:Hide()

	local detailHeader = primitives:BuildSectionHeader(detailFrame, "", oUi.xCoord, 0)

	local rowGlobalBox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useGlobal_row", detailFrame, "ChatConfigCheckButtonTemplate")
	rowGlobalBox:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, -30)
	getglobal(rowGlobalBox:GetName() .. 'Text'):SetText(L["BarTexturesUseGlobalRow"])
	getglobal(rowGlobalBox:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	rowGlobalBox.tooltip = L["BarTexturesUseGlobalRowTooltip"]
	rowGlobalBox:SetScript("OnClick", function(self)
		if selectedKey ~= nil then
			SetRowUsesGlobal(selectedKey, self:GetChecked() == true)
			AfterChange()
		end
	end)

	-- Covers the dropdowns of a bar that follows Global Options, with the ways to change it.
	local detailCover = primitives:BuildSectionCover(detailFrame, -58, -detailHeight)
	controls.barTexturesDetailCover = detailCover
	local coverMessage = detailCover:CreateFontString(nil, "OVERLAY")
	coverMessage:SetFontObject(GameFontHighlightLarge)
	coverMessage:SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	coverMessage:SetJustifyH("CENTER")
	coverMessage:SetText(L["BarTexturesUsingGlobal"])
	-- Raised by half the button row so the message and buttons sit centered as one block.
	coverMessage:SetPoint("LEFT", detailCover, "LEFT", 20, 15)
	coverMessage:SetPoint("RIGHT", detailCover, "RIGHT", -20, 15)

	local coverOpen = CreateFrame("Button", nil, detailCover, "UIPanelButtonTemplate")
	coverOpen:SetText(L["UseGlobalCoverOpenGlobal"])
	coverOpen:SetSize(coverOpen:GetTextWidth() + 30, 22)
	coverOpen:SetPoint("TOPRIGHT", coverMessage, "BOTTOM", -5, -8)
	coverOpen:SetScript("OnClick", function()
		if selectedKey ~= nil then
			TRB.Functions.OptionsUi.Textures:OpenGlobalTextures(selectedKey)
		end
	end)

	local coverCustomize = CreateFrame("Button", nil, detailCover, "UIPanelButtonTemplate")
	coverCustomize:SetText(L["UseGlobalCoverCustomize"])
	coverCustomize:SetSize(coverCustomize:GetTextWidth() + 30, 22)
	coverCustomize:SetPoint("TOPLEFT", coverMessage, "BOTTOM", 5, -8)
	coverCustomize:SetScript("OnClick", function()
		if selectedKey ~= nil then
			SetRowUsesGlobal(selectedKey, false)
			AfterChange()
		end
	end)
	detailCover.openButton = coverOpen
	detailCover.customizeButton = coverCustomize

	-- One dropdown per texture key, made the first time its bar is opened and shown only with that bar.
	local dropdowns = {}
	local shownDropdowns = {}

	---@param row table
	---@param item table
	---@param slot integer
	local function EnsureDropdown(row, item, slot)
		if dropdowns[item.key] == nil then
			local xPos = (slot % 2 == 1) and oUi.xCoord or oUi.xCoord2
			local yPos = -70 - (60 * math.floor((slot - 1) / 2))
			textureDropdowns:CreateLsmDropdown(detailFrame, dropdowns, textures, classId, specId, xPos, yPos, item.lsmType, item.key, item.label, L["StatusBarTextures"],
				function(newValue)
					local ownerTextures = OwnerTextures(row)
					local newName = dropdowns[item.key].lsmPairsByName[newValue]
					ownerTextures[item.key] = newValue
					ownerTextures[item.key .. "Name"] = newName
					-- Changing the texture a lock copies changes everything the lock matches to it.
					local lockName, isSource = GetLockOfKey(item.key)
					if lockName ~= nil and isSource and ownerTextures[lockName] then
						SyncLock(ownerTextures, lockName)
					end
					AfterChange()
				end, namePrefix)
			local dropdown = dropdowns[item.key]
			-- A disabled button skips its mouse scripts unless told otherwise, and a disabled one is what needs explaining.
			dropdown:SetMotionScriptsWhileDisabled(true)
			dropdown:HookScript("OnEnter", function(button)
				if button.disabledReason ~= nil then
					GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
					GameTooltip:SetText(button.disabledReason, 1, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end)
			dropdown:HookScript("OnLeave", function(button)
				if GameTooltip:GetOwner() == button then
					GameTooltip:Hide()
				end
			end)
		end
		return dropdowns[item.key]
	end

	---Opens a bar in the detail panel.
	---@param barKey string
	local function FillDetailPanel(barKey)
		local row = rowsByKey[barKey]
		for _, dropdown in ipairs(shownDropdowns) do
			dropdown:Hide()
			dropdown.label:Hide()
		end
		shownDropdowns = {}
		if row == nil then
			selectedKey = nil
			detailFrame:Hide()
			return
		end
		selectedKey = barKey
		detailHeader.font:SetText(row.label)

		local followsGlobal = IsFollowingGlobal(row)
		rowGlobalBox:SetShown(row.canUseGlobal)
		rowGlobalBox:SetChecked(followsGlobal)
		detailCover:SetShown(followsGlobal)

		for slot, item in ipairs(row.items) do
			local dropdown = EnsureDropdown(row, item, slot)
			local displayName = DisplayName(row, item) or OwnerTextures(row)[item.key .. "Name"]
			local locked = IsLockedMember(item.key)
			textureDropdowns:RefreshLsmDropdown(dropdown, displayName)
			primitives:ToggleDropdownEnabled(dropdown, not followsGlobal and not locked)
			dropdown.disabledReason = GetDisabledReason(row, item)
			dropdown:Show()
			dropdown.label:Show()
			shownDropdowns[#shownDropdowns + 1] = dropdown
		end
		detailFrame:Show()
	end

	-- ===== Wiring =====
	---Syncs the Use Global box to the rows it covers.
	local function SyncUseGlobalBox()
		if useGlobalBox == nil then
			return
		end
		if isSpecScope then
			local followed, total = 0, 0
			for _, row in ipairs(listedRows) do
				if row.canUseGlobal then
					total = total + 1
					if IsFollowingGlobal(row) then
						followed = followed + 1
					end
				end
			end
			useGlobalBox:SetShown(total > 0)
			TRB.Functions.OptionsUi.GlobalSettings:SetCheckboxTriState(useGlobalBox, GetUseGlobalState(followed, total))
		else
			local followed, total = 0, 0
			for _, specEntry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
				local classPiece = TRB.Data.settings[specEntry.className]
				local piece = classPiece and classPiece[specEntry.specName]
				local specTextures = piece and piece.textures
				if specTextures ~= nil then
					for _, row in ipairs(listedRows) do
						if globalBars.set[row.key] then
							total = total + 1
							if specTextures.useGlobal == nil or specTextures.useGlobal[row.key] ~= false then
								followed = followed + 1
							end
						end
					end
				end
			end
			useGlobalBox:SetShown(total > 0)
			TRB.Functions.OptionsUi.GlobalSettings:SetCheckboxTriState(useGlobalBox, GetUseGlobalState(followed, total))
			useGlobalBox.specCount:SetText(string.format(L["BarTexturesUseGlobalCountFormat"], followed, total))
		end
	end

	---Shows the locks of the main bar's owner; they can only be changed there.
	local function SyncLockBoxes()
		local lockTextures = LockTextures()
		local editable = not PrimaryFollowsGlobal()
		for lockName, box in pairs(lockBoxes) do
			box:SetChecked(lockTextures[lockName] == true)
			primitives:ToggleCheckboxEnabled(box, editable)
			if editable then
				box.tooltip = box.baseTooltip
			else
				box.tooltip = box.baseTooltip .. "\n\n" .. string.format(L["TextureLockGlobalTooltip"], rowsByKey.primary.label)
			end
		end
	end

	Refresh = function()
		SetTableValues()
		if selectedKey ~= nil then
			FillDetailPanel(selectedKey)
		end
		SyncLockBoxes()
		SyncUseGlobalBox()
	end

	ReloadRows = function()
		RebuildRows()
		if selectedKey ~= nil and not tContains(listedRows, rowsByKey[selectedKey]) then
			selectedKey = nil
			detailFrame:Hide()
		end
		Refresh()
	end

	RefreshEditors = function()
		for _, editor in pairs(texturesEditors[scopeKey] or {}) do
			editor.Refresh()
		end
	end

	-- The texture cells say why one can't be changed on its own; the table's own hover highlight runs after.
	barTexturesTable:RegisterEvents({
		OnEnter = function(_, cellFrame, data, _, _, realrow, column)
			if realrow == nil or realrow < 1 or column < 3 or column > 5 then
				return
			end
			local row = rowsByKey[data[realrow].cols[1].value]
			local reason = row ~= nil and GetDisabledReason(row, row.items[column - 2]) or nil
			if reason ~= nil then
				GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
				GameTooltip:SetText(reason, 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end,
		OnLeave = function(_, cellFrame)
			if GameTooltip:GetOwner() == cellFrame then
				GameTooltip:Hide()
			end
		end,
		OnClick = function(_, _, data, _, _, realrow, _, scrollingTable, button)
			if button == "LeftButton" then
				if realrow ~= nil and realrow > 0 then
					local barKey = data[realrow].cols[1].value
					local currentSelection = scrollingTable:GetSelection()
					FillDetailPanel(barKey)
					C_Timer.After(0, function()
						C_Timer.After(0.05, function()
							local newSelection = scrollingTable:GetSelection()
							if newSelection == nil then
								barTexturesTable:SetSelection(currentSelection)
							end
						end)
					end)
				end
			end
		end
	})

	local scopeEditors = texturesEditors[scopeKey] or {}
	texturesEditors[scopeKey] = scopeEditors
	scopeEditors[groupKey] = {
		Refresh = Refresh,
		SelectBarKey = function(barKey)
			if tContains(listedRows, rowsByKey[barKey]) then
				FillDetailPanel(barKey)
				SetTableValues()
			end
		end,
	}

	-- A sibling tab's edits show up when this one comes back into view.
	container:HookScript("OnShow", function()
		Refresh()
	end)

	Refresh()

	return yCoord - detailHeight
end

---Constructs the Textures tab of a shared grouping's strip: the textures of just that grouping's bars.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param groupKey string # castbar, otherBars, petBars, or skyriding
function TRB.Functions.OptionsUi.Textures:ConstructGroupPanel(parent, classId, specId, groupKey)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec
	if classId == nil then
		spec = TRB.Data.settings.core
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if spec == nil or spec.textures == nil then
		return
	end

	-- Each grouping's tab gets its own controls: they would otherwise overwrite each other's under one scope.
	local controls = { checkBoxes = {}, dropDown = {}, buttons = {}, labels = {}, colors = {} }
	self:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, 5, false, nil, false, {}, false, { groupKey = groupKey })
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

	controls.flashSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["FlashSectionHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["FlashAlpha"], flashAlphaName)
	controls.flashAlpha = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.bar.flashAlpha = value
	end)

	title = string.format(L["FlashPeriod"], flashAlphaName)
	controls.flashPeriod = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0.05, 2, spec.colors.bar.flashPeriod, 0.05, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
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
	f.tooltip = string.format(L["FlashBarTooltip"], flashAlphaName)
	f:SetChecked(spec.colors.bar.flashEnabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.flashEnabled = self:GetChecked()
	end)

	return yCoord
end

