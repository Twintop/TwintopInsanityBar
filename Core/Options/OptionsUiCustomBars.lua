local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.CustomBars = TRB.Functions.OptionsUi.CustomBars or {}

-- A specialization's Custom Bars tab: a table of the bars the user added over the selected bar's options.

local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization
local CustomBars = TRB.Functions.CustomBars
local deleteActionTextColor = { r = 1, g = 0, b = 0, a = 1 }
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0

StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteCustomBar"] = {
	text = "%s",
	button1 = L["CustomBarsDelete"],
	button2 = CANCEL,
	OnAccept = function(self, data)
		if data ~= nil then
			data.delete()
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- Each built Bars tab's "open this bar", by composite key.
---@type table<string, fun(barKey: string)>
local openBarByPanel = {}

---Opens a bar on its specialization's Bars tab: selects its row and shows its options.
---@param classId integer
---@param specId integer
---@param barKey string
function TRB.Functions.OptionsUi.CustomBars:OpenBar(classId, specId, barKey)
	local compositeKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local openBar = compositeKey ~= nil and openBarByPanel[compositeKey] or nil
	if openBar ~= nil then
		openBar(barKey)
	end
end

---@param source TRB.Classes.Settings.CustomBarSource|TRB.Classes.CustomBarSourceOption
---@return string
local function GetSourceKey(source)
	return source.kind .. ":" .. tostring(source.spellId)
end

---Builds the Custom Bars tab's Bars sub-tab.
---@param parent Frame # The sub-tab's manual container frame
---@param classId integer
---@param specId integer
function TRB.Functions.OptionsUi.CustomBars:ConstructPanel(parent, classId, specId)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(classNameLower, specName)
	local namePrefix = "TwintopResourceBar_" .. compositeKey .. "_CustomBars"
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()

	---The saved settings, re-read on every use so a profile switch is followed.
	---@return table?
	local function GetSpec()
		return TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if GetSpec() == nil then
		return
	end
	-- Another class's bars are registered nowhere else.
	CustomBars:SyncRegistry(classId, specId, GetSpec())

	local selectedGuid = nil
	local isRefreshing = false
	-- Each bar's built options: the generators bind to one bar, so every bar gets its own frame.
	---@type table<string, Frame>
	local barFrames = {}
	-- The saved settings each bar's options were built against.
	---@type table<string, table>
	local builtFor = {}
	local buildSerial = 0
	local SetTableValues, RefreshEditor

	---Recomposes the spec's settings and, when its bars are the ones being drawn, lays them out again.
	local function ReapplyBars()
		if TRB.Data.specCache[compositeKey] ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(classNameLower, specName)
		else
			CustomBars:SyncRegistry(classId, specId, GetSpec())
		end
		if CustomBars:IsDisplayedSpec(classId, specId) and TRB.Frames.barGroups ~= nil then
			local settings = CustomBars:GetDisplayedSettings()
			local character = TRB.Data.character
			local ownCache = TRB.Data.specCache[character.compositeKey]
			if settings ~= nil and ownCache ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyCustomBarGroupsAppearance(settings, TRB.Frames.barGroups, true)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
				TRB.Functions.Class:TriggerResourceBarUpdates()
				-- A rebuilt bar has new frames for its text to anchor to, and the frames follow the character's list.
				TRB.Functions.BarText:CreateBarTextFrames()
				TRB.Data.lookupDirty = true
				TRB.Functions.BarText:UpdateResourceBarText(ownCache.settings, true)
			end
		end
		TRB.Functions.OptionsUi.BarText:RefreshAnchorCatalogs(classId, specId)
	end

	---@param guid string?
	---@return TRB.Classes.Settings.CustomBar?
	local function GetBar(guid)
		local bars = CustomBars:GetBars(GetSpec())
		return guid ~= nil and bars ~= nil and bars[guid] or nil
	end

	local columns = {
		{ name = "", width = 1, align = "CENTER" },
		{ name = L["Name"], width = 220, align = "LEFT", sort = 1, defaultsort = 1 },
		{ name = L["CustomBarsTableHeaderTracks"], width = 260, align = "LEFT" },
		{ name = "", width = 15, align = "CENTER", color = deleteActionTextColor },
	}

	local yCoord = 0
	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["CustomBarsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 20

	local sources = CustomBars:GetSources(classId, specId)
	local note = #sources > 0 and L["CustomBarsPanelNote"] or L["CustomBarsNoSourcesNote"]
	TRB.Functions.OptionsUi.Primitives:BuildLabel(parent, note, oUi.xCoord, yCoord, oUi.maxOptionsWidth, 28)
	yCoord = yCoord - 30

	local tableContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	tableContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord - 10)
	tableContainer:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	tableContainer:SetHeight(35 + 5 * 15)

	local barsTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, tableContainer, false, false)

	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[3].width + columns[4].width
		columns[2].width = math.max(120, w - fixedWidth - 30)
		barsTable:SetDisplayCols(columns)
	end)

	local function UpdateActionCell(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		scrollingTable.DoCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
		if fShow and cellFrame ~= nil and cellFrame.text ~= nil then
			cellFrame.text:SetAlpha(actionCellDimAlpha)
		end
	end

	local editorHeaderRow = CreateFrame("Frame", namePrefix .. "_EditorHeaderRow", parent)
	editorHeaderRow:SetPoint("TOPLEFT", tableContainer, "BOTTOMLEFT", 0, -2)
	editorHeaderRow:SetPoint("TOPRIGHT", tableContainer, "BOTTOMRIGHT", 0, -2)
	editorHeaderRow:SetHeight(50)

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["CustomBarsAdd"], 0, 0, 140, 24)
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", editorHeaderRow, "TOPRIGHT", -5, -8)
	if #sources == 0 then
		addButton:Disable()
	end

	local nameLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(editorHeaderRow, L["Name"], oUi.xCoord, 0, 110, 20)
	local nameBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(editorHeaderRow, "", 80, 260, 20, oUi.xCoord, -20)
	nameLabel:Hide()
	nameBox:Hide()

	local editorFrame = CreateFrame("Frame", namePrefix .. "_Editor", parent, "BackdropTemplate")
	editorFrame:SetPoint("TOPLEFT", editorHeaderRow, "BOTTOMLEFT", 0, -5)
	editorFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -oUi.xCoord, 3)
	editorFrame:Hide()

	local editorScrollFrame = CreateFrame("ScrollFrame", namePrefix .. "_EditorScroll", editorFrame, "UIPanelScrollFrameTemplate")
	editorScrollFrame:SetPoint("TOPLEFT", editorFrame, "TOPLEFT", 0, 0)
	editorScrollFrame:SetPoint("BOTTOMRIGHT", editorFrame, "BOTTOMRIGHT", -20, 0)
	local editorContent = CreateFrame("Frame", nil, editorScrollFrame)
	editorContent:SetSize(editorScrollFrame:GetWidth() or 600, 1)
	editorScrollFrame:SetScrollChild(editorContent)
	editorScrollFrame:HookScript("OnSizeChanged", function(self, w, h)
		editorContent:SetWidth(w)
	end)

	---Retires a bar's built options, so the next refresh builds them again from its settings.
	---@param guid string
	local function DropBarFrame(guid)
		local frame = barFrames[guid]
		if frame ~= nil then
			-- The rebuilt options reuse its names.
			TRB.Functions.OptionsUi.Primitives:RetireFrame(frame)
			barFrames[guid] = nil
			builtFor[guid] = nil
		end
	end

	---A change that the built options can't follow: the bar's name, what it tracks, or its shape.
	---@param guid string
	local function RebuildBar(guid)
		DropBarFrame(guid)
		ReapplyBars()
		SetTableValues()
		RefreshEditor(guid)
	end

	---Builds one bar's options: what it tracks, then the standard layout and colors.
	---@param bar TRB.Classes.Settings.CustomBar
	---@return Frame?
	local function BuildBarFrame(bar)
		local spec = GetSpec()
		local barKey = CustomBars:GetBarKey(bar.guid)
		local barDef = registry:Get(barKey)
		if spec == nil or barDef == nil then
			return nil
		end
		buildSerial = buildSerial + 1
		local barPrefix = namePrefix .. "_" .. barKey .. "_" .. buildSerial
		local frame = CreateFrame("Frame", nil, editorContent)
		frame:SetPoint("TOPLEFT", editorContent, "TOPLEFT", 0, 0)
		frame:SetPoint("TOPRIGHT", editorContent, "TOPRIGHT", 0, 0)
		builtFor[bar.guid] = spec

		local controls = { checkBoxes = {}, dropDown = {}, sliders = {}, colors = {}, labels = {}, buttons = {} }

		-- The saved source leads when this spec's snapshots don't offer it, as on another class.
		local options = {}
		local currentKey = GetSourceKey(bar.source)
		local sourcesByKey = {}
		for _, source in ipairs(CustomBars:GetSources(classId, specId)) do
			local key = GetSourceKey(source)
			sourcesByKey[key] = source
			options[#options + 1] = { value = key, label = source.label }
		end
		if sourcesByKey[currentKey] == nil then
			table.insert(options, 1, { value = currentKey, label = CustomBars:GetSourceLabel(classId, specId, bar.source) })
		end

		local barY = -5
		TRB.Functions.OptionsUi.Primitives:BuildDropdown(frame, barPrefix .. "_Tracks", L["CustomBarsTracks"], options,
			function()
				return GetSourceKey(bar.source)
			end,
			function(key)
				local source = sourcesByKey[key]
				if source == nil or key == GetSourceKey(bar.source) then
					return
				end
				CustomBars:SetSource(spec, classId, specId, bar, source)
				RebuildBar(bar.guid)
			end, oUi.xCoord, barY)
		barY = barY - 70

		if CustomBars:IsCountKind(bar.source.kind) then
			TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(frame, barPrefix .. "_Segmented", L["CustomBarsSegmented"], L["CustomBarsSegmentedTooltip"], barY,
				function()
					return barDef.isMultiNode
				end,
				function(checked)
					CustomBars:Change(spec, classId, specId, bar, function()
						bar.segmented = checked
					end)
					RebuildBar(bar.guid)
				end)
			if bar.source.kind == CustomBars.kinds.charges then
				barY = barY - 20
				local fillRecharge = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(frame, barPrefix .. "_FillRecharge", L["CustomBarsFillRecharge"],
					L["CustomBarsFillRechargeTooltip"], barY,
					function()
						return CustomBars:FillsRecharge(bar)
					end,
					function(checked)
						CustomBars:Change(spec, classId, specId, bar, function()
							bar.fillRecharge = checked
						end)
						-- Nothing built here depends on it, so the options stay as they are.
						ReapplyBars()
					end)
				-- Only a segmented bar has a charge to fill.
				fillRecharge:ClearAllPoints()
				fillRecharge:SetPoint("TOPLEFT", oUi.xCoord + 20, barY)
				TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(fillRecharge, barDef.isMultiNode)
			end
			barY = barY - 30
		end

		barY = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(frame, controls, spec, classId, specId, barY, barDef, barDef.displayName)
		barY = barY - 60
		barY = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(frame, controls, spec, classId, specId, barY, barDef)
		-- The End Cap width slider reaches 40 below the row the colors return.
		frame:SetHeight(math.max(1, -barY + 70))
		return frame
	end

	RefreshEditor = function(guid)
		selectedGuid = guid
		local bar = GetBar(guid)
		for _, frame in pairs(barFrames) do
			frame:Hide()
		end
		if bar == nil then
			selectedGuid = nil
			nameLabel:Hide()
			nameBox:Hide()
			editorFrame:Hide()
			barsTable:ClearSelection()
			return
		end

		isRefreshing = true
		nameLabel:Show()
		nameBox:Show()
		editorFrame:Show()
		nameBox:SetText(bar.name or "")
		isRefreshing = false

		-- A profile switch leaves the built options bound to the old profile's tables.
		if barFrames[guid] ~= nil and builtFor[guid] ~= GetSpec() then
			DropBarFrame(guid)
		end
		if barFrames[guid] == nil then
			barFrames[guid] = BuildBarFrame(bar)
		end
		local frame = barFrames[guid]
		if frame ~= nil then
			frame:Show()
			editorContent:SetHeight(frame:GetHeight())
		end
	end

	-- Each listed bar's row in the table's data.
	---@type table<string, integer>
	local rowByGuid = {}

	SetTableValues = function()
		local dataTable = {}
		wipe(rowByGuid)
		for _, bar in ipairs(CustomBars:GetOrdered(GetSpec())) do
			rowByGuid[bar.guid] = #dataTable + 1
			table.insert(dataTable, {
				cols = {
					{ value = bar.guid },
					{ value = bar.name or "" },
					{ value = CustomBars:GetSourceLabel(classId, specId, bar.source) },
					{ value = "X", color = deleteActionTextColor, DoCellUpdate = UpdateActionCell },
				}
			})
		end
		barsTable:SetData(dataTable)
		barsTable:EnableSelection(true)
		-- The open bar stays highlighted through a refill.
		if selectedGuid ~= nil and rowByGuid[selectedGuid] ~= nil then
			barsTable:SetSelection(rowByGuid[selectedGuid])
		end
	end

	local nameChanged = false
	nameBox:SetScript("OnTextChanged", function(self)
		if isRefreshing then
			return
		end
		local bar = GetBar(selectedGuid)
		if bar == nil then
			return
		end
		local spec = GetSpec()
		if spec == nil then
			return
		end
		CustomBars:Rename(spec, classId, specId, bar, self:GetText())
		nameChanged = true
		SetTableValues()
	end)
	-- The built options and the other tabs name the bar, so they follow once the edit is finished.
	nameBox:HookScript("OnEditFocusLost", function()
		if nameChanged and selectedGuid ~= nil and GetBar(selectedGuid) ~= nil then
			nameChanged = false
			RebuildBar(selectedGuid)
		end
	end)

	---@param source TRB.Classes.CustomBarSourceOption
	local function AddBar(source)
		local spec = GetSpec()
		if spec == nil then
			return
		end
		local guid = CustomBars:Add(spec, classId, specId, source)
		ReapplyBars()
		SetTableValues()
		RefreshEditor(guid)
	end

	addButton:SetScript("OnClick", function(self)
		local available = CustomBars:GetSources(classId, specId)
		MenuUtil.CreateContextMenu(self, function(_, rootDescription)
			rootDescription:CreateTitle(L["CustomBarsAddTitle"])
			for _, source in ipairs(available) do
				rootDescription:CreateButton(source.label, function()
					AddBar(source)
				end)
			end
			TRB.Functions.OptionsUi.Primitives:LimitMenuRows(rootDescription, #available + 1)
		end)
	end)

	barsTable:RegisterEvents({
		OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow ~= nil and realrow > 0 and column == 4 and cellFrame ~= nil and cellFrame.text ~= nil then
				cellFrame.text:SetAlpha(actionCellBrightAlpha)
				GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["CustomBarsDeleteActionTooltip"], 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end,
		OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if column == 4 then
				if cellFrame ~= nil and cellFrame.text ~= nil then
					cellFrame.text:SetAlpha(actionCellDimAlpha)
				end
				GameTooltip:Hide()
			end
		end,
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button)
			if button ~= "LeftButton" or realrow == nil or realrow <= 0 then
				return
			end
			local guid = data[realrow].cols[1].value
			if column == 4 then
				local bar = GetBar(guid)
				StaticPopup_Show("TwintopResourceBar_ConfirmDeleteCustomBar", string.format(L["CustomBarsDeleteConfirmation"], bar and bar.name or ""), nil, {
					delete = function()
						local spec = GetSpec()
						if spec == nil then
							return
						end
						CustomBars:Delete(spec, classId, specId, guid)
						DropBarFrame(guid)
						ReapplyBars()
						SetTableValues()
						RefreshEditor(nil)
					end,
				})
			else
				RefreshEditor(guid)
			end
		end,
	})

	openBarByPanel[compositeKey] = function(barKey)
		CustomBars:SyncRegistry(classId, specId, GetSpec())
		SetTableValues()
		for _, bar in ipairs(CustomBars:GetOrdered(GetSpec())) do
			if CustomBars:GetBarKey(bar.guid) == barKey then
				RefreshEditor(bar.guid)
				TRB.Functions.OptionsUi.Primitives:ScrollTableToRow(barsTable, rowByGuid[bar.guid])
				barsTable:SetSelection(rowByGuid[bar.guid])
				return
			end
		end
	end

	-- Built once and kept, so a profile switch or an import can leave the table showing bars that are gone.
	parent:HookScript("OnShow", function()
		CustomBars:SyncRegistry(classId, specId, GetSpec())
		SetTableValues()
		RefreshEditor(selectedGuid)
	end)

	SetTableValues()
end
