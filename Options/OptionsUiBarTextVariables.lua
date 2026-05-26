---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.BarTextVariables = TRB.Functions.OptionsUi.BarTextVariables or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- ============================================================================
-- Bar text variables side panel
-- ============================================================================

---Creates the bar text variables side panel with a searchable scrolling table, description pane, and add-button behavior.
---@param parent Frame # The spec's scrollChild or display panel parent
---@param name string # Unique name prefix for frame naming (e.g., "Priest_Shadow")
---@param cache table # The spec cache entry containing barTextVariables
---@param classId integer # The WoW class ID
---@param specId integer # The WoW specialization ID
---@return Frame # The outer container frame for the side panel
function TRB.Functions.OptionsUi.BarTextVariables:CreateVariablesSidePanel(parent, name, cache, classId, specId)
	local mainFrame = TRB.Frames.optionsFrame
	local panelWidth = 350

	-- Outer container frame anchored to the right of the main options frame
	local cf = CreateFrame("Frame", "TRB_" .. name .. "_BarTextVariables_Frame", mainFrame, "BackdropTemplate")
	cf:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	cf:SetBackdropColor(0, 0, 0, 0.8)
	cf:SetWidth(panelWidth)
	cf:ClearAllPoints()
	cf:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 0, 0)
	cf:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMRIGHT", 0, 0)

	-- Start hidden; SwitchTab will show it when the Bar Text tab is active
	cf:Hide()

	-- Register in the per-spec lookup table so tab/nav switching can activate the correct panel.
	TRB.Frames.barTextVariablesPanelRegistry = TRB.Frames.barTextVariablesPanelRegistry or {}
	TRB.Frames.barTextVariablesPanelRegistry[name] = cf

	-- =============================================
	-- Title
	-- =============================================
	local titleLabel = cf:CreateFontString(nil, "OVERLAY")
	titleLabel:SetFontObject(GameFontNormalLarge)
	titleLabel:SetPoint("TOPLEFT", cf, "TOPLEFT", 10, -8)
	titleLabel:SetText(L["BarTextVariablesPanelTitle"])

	-- =============================================
	-- Search box
	-- =============================================
	local searchBox = CreateFrame("EditBox", "TRB_" .. name .. "_BarTextVariables_Search", cf, "InputBoxTemplate")
	searchBox:SetSize(panelWidth - 30, 20)
	searchBox:SetPoint("TOPLEFT", cf, "TOPLEFT", 18, -30)
	searchBox:SetAutoFocus(false)
	searchBox:SetFontObject(ChatFontNormal)

	local searchPlaceholder = searchBox:CreateFontString(nil, "ARTWORK")
	searchPlaceholder:SetFontObject(GameFontDisable)
	searchPlaceholder:SetPoint("LEFT", searchBox, "LEFT", 4, 0)
	searchPlaceholder:SetText(L["BarTextVariablesPanelSearchPlaceholder"])
	searchBox:SetScript("OnEditFocusGained", function(self)
		searchPlaceholder:Hide()
	end)
	searchBox:SetScript("OnEditFocusLost", function(self)
		if self:GetText() == "" then
			searchPlaceholder:Show()
		end
	end)
	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)

	-- =============================================
	-- Description pane (bottom 30% of the panel)
	-- =============================================
	local descHeight = 120
	local descFrame = CreateFrame("Frame", nil, cf, "BackdropTemplate")
	descFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 16,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	descFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
	descFrame:SetHeight(descHeight)
	descFrame:SetPoint("BOTTOMLEFT", cf, "BOTTOMLEFT", 5, 5)
	descFrame:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", -5, 5)

	local descLabel = descFrame:CreateFontString(nil, "OVERLAY")
	descLabel:SetFontObject(GameFontNormal)
	descLabel:SetPoint("TOPLEFT", descFrame, "TOPLEFT", 8, -6)
	descLabel:SetWidth(panelWidth - 30)
	descLabel:SetJustifyH("LEFT")
	descLabel:SetJustifyV("TOP")
	descLabel:SetText("")

	local descText = descFrame:CreateFontString(nil, "OVERLAY")
	descText:SetFontObject(GameFontHighlight)
	descText:SetPoint("TOPLEFT", descLabel, "BOTTOMLEFT", 0, -4)
	descText:SetPoint("BOTTOMRIGHT", descFrame, "BOTTOMRIGHT", -8, 6)
	descText:SetJustifyH("LEFT")
	descText:SetJustifyV("TOP")
	---@diagnostic disable-next-line: redundant-parameter
	descText:SetWordWrap(true)
	descText:SetText(L["BarTextVariablesPanelDescriptionDefault"])

	-- =============================================
	-- Table container (between search and description)
	-- =============================================
	local tableContainer = CreateFrame("Frame", "TRB_" .. name .. "_BarTextVariables_TableContainer", cf)
	tableContainer:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -55)
	tableContainer:SetPoint("BOTTOMRIGHT", descFrame, "TOPRIGHT", -5, 2)

	-- =============================================
	-- Build data table from cache.barTextVariables
	-- =============================================
	local allData = {}     -- flat array for LibScrollingTable
	local sectionOrder = { "values", "pipe", "icons" }
	local sectionLabels = {
		values = L["BarTextVariablesSectionValues"],
		pipe = L["BarTextVariablesSectionPipe"],
		icons = L["BarTextVariablesSectionIcons"],
	}

	---Builds a flat data array for LibScrollingTable from the spec's barTextVariables, organized by section.
	---@param barTextVariables table # The barTextVariables table with values, pipe, and icons sections
	---@return table[] # Flat array of row data for LibScrollingTable
	local function BuildDataTable(barTextVariables)
		local data = {}
		for _, sectionKey in ipairs(sectionOrder) do
			local sectionEntries = barTextVariables[sectionKey]
			if sectionEntries and #sectionEntries > 0 then
				local hasVisible = false
				for _, entry in ipairs(sectionEntries) do
					if entry.printInSettings then
						hasVisible = true
						break
					end
				end
				if hasVisible then
					-- Section header row
					table.insert(data, {
						cols = {
							{ value = "" },
							{ value = sectionLabels[sectionKey] },
						},
						isHeader = true,
						sectionKey = sectionKey,
						variable = "",
						description = "",
					})
					-- Variable rows
					for _, entry in ipairs(sectionEntries) do
						if entry.printInSettings then
							local desc = entry.description or ""
							if sectionKey == "icons" and entry.icon and entry.icon ~= "" then
								desc = entry.icon .. " " .. desc
							end
							table.insert(data, {
								cols = {
									{ value = L["BarTextVariablesAddButton"] },
									{ value = entry.variable },
								},
								isHeader = false,
								sectionKey = sectionKey,
								variable = entry.variable,
								description = desc,
							})
						end
					end
				end
			end
		end
		return data
	end

	-- Ensure barTextVariables are populated for this spec.
	-- For non-active specs, FillBarTextVariables hasn't been called yet during SwitchSpec,
	-- so we use the barTextVariablesRegistry to fill them on demand.
	local registryKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	---Ensures the spec's barTextVariables are populated, filling them on demand from the registry if needed.
	local function EnsureBarTextVariablesPopulated()
		local vals = cache.barTextVariables.values
		if vals == nil or #vals == 0 then
			local registry = TRB.Data.barTextVariablesRegistry
			if registry and registryKey and registry[registryKey] then
				registry[registryKey](cache)
			end
		end
	end

	EnsureBarTextVariablesPopulated()
	allData = BuildDataTable(cache.barTextVariables)

	-- =============================================
	-- Calculate how many rows fit in the table area
	-- =============================================
	local rowHeight = 22
	-- Reserve space: panel top (55px for title+search) + description pane (descHeight + gap)
	-- The table container fills the remainder. Estimate available height.
	-- We use a conservative default; the table will scroll.
	local estimatedTableHeight = 400  -- Reasonable default, will be dynamically limited by anchors
	local numDisplayRows = math.max(5, math.floor(estimatedTableHeight / rowHeight))

	-- =============================================
	-- LibScrollingTable columns
	-- Column 1 = Add button (+), Column 2 = Variable name
	-- =============================================
	local columns = {
		{
			["name"] = "",
			["width"] = 18,
			["align"] = "CENTER",
			["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, st)
				if not fShow then return end
				-- Hide the default text; we use an icon texture instead
				cellFrame.text:SetText("")

				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					if cellFrame._addIcon then cellFrame._addIcon:Hide() end
				else
					-- Create the icon texture once per cell, reuse thereafter
					if not cellFrame._addIcon then
						local icon = cellFrame:CreateTexture(nil, "ARTWORK")
						icon:SetSize(10, 10)
						icon:SetPoint("CENTER", cellFrame, "CENTER", 0, 0)
						-- Use a white base texture so SetVertexColor has full range
						icon:SetAtlas("communities-chat-icon-plus")
						cellFrame._addIcon = icon
					end
					local icon = cellFrame._addIcon
					icon:Show()
					local hasActiveEditBox = TRB.Frames.activeBarTextEditBox ~= nil
					if hasActiveEditBox then
						icon:SetVertexColor(0, 1, 0, 1)
					else
						icon:SetVertexColor(0.5, 0.5, 0.5, 0.6)
					end
				end
			end,
		},
		{
			["name"] = "",
			["width"] = panelWidth - 65,
			["align"] = "LEFT",
			["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, st)
				if not fShow then return end
				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					cellFrame.text:SetFontObject(GameFontNormal)
					cellFrame.text:SetTextColor(1, 0.82, 0, 1)
					cellFrame.text:SetText(rowData.cols[2].value)
				else
					cellFrame.text:SetFontObject(GameFontHighlight)
					cellFrame.text:SetTextColor(1, 1, 1, 1)
					cellFrame.text:SetText(rowData and rowData.cols[2].value or "")
				end
			end,
		},
	}

	local variablesTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, numDisplayRows, rowHeight, nil, tableContainer, false)
	variablesTable:EnableSelection(true)
	variablesTable.frame:SetPoint("TOPLEFT", tableContainer, "TOPLEFT", 0, 0)
	variablesTable.frame:SetPoint("TOPRIGHT", tableContainer, "TOPRIGHT", 0, 0)
	variablesTable:SetData(allData)

	-- Raise the search box above the table header frames so it remains clickable
	searchBox:SetFrameLevel(variablesTable.frame:GetFrameLevel() + 10)

	-- Dynamically resize the table when the container size changes
	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local newRows = math.max(5, math.floor(h / rowHeight))
		if newRows ~= variablesTable.displayRows then
			variablesTable:SetDisplayRows(newRows, rowHeight)
		end
		-- Resize variable column (col 2) to fill remaining width
		columns[2].width = math.max(100, w - columns[1].width - 45)
		variablesTable:SetDisplayCols(columns)
	end)

	-- =============================================
	-- Search filtering
	-- =============================================
	local searchText = ""
	variablesTable:SetFilter(function(self, rowData)
		if searchText == "" then
			return true
		end
		if rowData.isHeader then
			-- Show header if any child in the same section passes the filter
			local started = false
			for _, d in ipairs(allData) do
				if d == rowData then
					started = true
				elseif started then
					if d.isHeader then
						break -- next section
					end
					local var = (d.variable or ""):lower()
					local desc = (d.description or ""):lower()
					if string.find(var, searchText, 1, true) or string.find(desc, searchText, 1, true) then
						return true
					end
				end
			end
			return false
		end
		local var = (rowData.variable or ""):lower()
		local desc = (rowData.description or ""):lower()
		return string.find(var, searchText, 1, true) or string.find(desc, searchText, 1, true)
	end)

	searchBox:SetScript("OnTextChanged", function(self, userInput)
		searchText = self:GetText():lower()
		variablesTable:SortData() -- Re-filters and refreshes
	end)

	-- =============================================
	-- Row click / Add button behavior
	-- =============================================
	variablesTable:RegisterEvents({
		["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" and realrow and realrow > 0 then
				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					-- Section header click -- do nothing
					scrollingTable:ClearSelection()
					return true
				end

				if column == 1 then
					-- "Add" button column clicked -- insert variable at cursor
					local editBox = TRB.Frames.activeBarTextEditBox
					if editBox and rowData and rowData.variable and rowData.variable ~= "" then
						local cursorPos = TRB.Frames.activeBarTextCursorPosition or editBox:GetCursorPosition()
						local currentText = editBox:GetText() or ""
						local before = string.sub(currentText, 1, cursorPos)
						local after = string.sub(currentText, cursorPos + 1)
						local varText = rowData.variable
						local newText = before .. varText .. after
						editBox:SetText(newText)
						-- Move cursor to just after inserted variable
						local newCursorPos = cursorPos + string.len(varText)
						editBox:SetCursorPosition(newCursorPos)
						TRB.Frames.activeBarTextCursorPosition = newCursorPos

						-- Fire the OnTextChanged to update working data
						if editBox:GetScript("OnTextChanged") then
							editBox:GetScript("OnTextChanged")(editBox, true)
						end
					end
					-- Don't select the row for an add-button click
					scrollingTable:ClearSelection()
					return true
				else
					-- Normal click -- show description and select the row
					if rowData then
						descLabel:SetText(rowData.variable or "")
						descText:SetText(rowData.description or "")
						scrollingTable:SetSelection(realrow)
					end
				end
			end
			return true
		end,
		["OnEnter"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow and realrow > 0 then
				local rowData = data[realrow]
				if rowData and not rowData.isHeader then
					scrollingTable:SetHighLightColor(rowFrame, scrollingTable:GetDefaultHighlight())
					-- Tooltip for add button
					if column == 1 then
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(L["BarTextVariablesAddTooltip"], 1, 1, 1)
						GameTooltip:Show()
					end
				end
			end
			return true
		end,
		["OnLeave"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow and realrow > 0 then
				local rowData = data[realrow]
				if not rowData or not rowData.isHeader then
					-- Only clear highlight if this row is not the current selection
					if realrow ~= scrollingTable:GetSelection() then
						scrollingTable:SetHighLightColor(rowFrame, scrollingTable:GetDefaultHighlightBlank())
					end
				end
			end
			GameTooltip:Hide()
			return true
		end,
	})

	-- Refresh data from cache on each Show (handles cases where barTextVariables
	-- were not yet populated at construction time, e.g. when spec was not active).
	cf:HookScript("OnShow", function()
		EnsureBarTextVariablesPopulated()
		local newData = BuildDataTable(cache.barTextVariables)
		if #newData > 0 and #newData ~= #allData then
			allData = newData
			variablesTable:SetData(allData)
			variablesTable:SortData()
		end
	end)

	---@diagnostic disable-next-line: inject-field
	cf.variablesTable = variablesTable
	---@diagnostic disable-next-line: inject-field
	cf.allData = allData
	---@diagnostic disable-next-line: inject-field
	cf.BuildDataTable = BuildDataTable
	---@diagnostic disable-next-line: inject-field
	cf.descLabel = descLabel
	---@diagnostic disable-next-line: inject-field
	cf.descText = descText
	---@diagnostic disable-next-line: inject-field
	cf.searchBox = searchBox

	return cf
end

