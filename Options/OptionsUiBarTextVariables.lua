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
	-- Kept as narrow as the columns allow; the options frame plus this flyout has to fit on screen.
	local panelWidth = 365

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
	local descHeight = 155
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
	descLabel:SetFontObject(GameFontNormalLarge)
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
	tableContainer:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -72)
	tableContainer:SetPoint("BOTTOMRIGHT", descFrame, "TOPRIGHT", -5, 2)

	-- =============================================
	-- Build data table from cache.barTextVariables
	-- =============================================
	local allData = {}     -- flat array for LibScrollingTable
	-- Fixed group order. Sorting reorders a group's contents but never the groups themselves.
	local groupOrder = { "resources", "abilities", "stats", "castBar", "other", "icons" }
	local groupLabels = {
		resources = L["BarTextVariablesSectionResources"],
		abilities = L["BarTextVariablesSectionAbilities"],
		stats = L["BarTextVariablesSectionStats"],
		castBar = L["BarTextVariablesSectionCastBars"],
		other = L["BarTextVariablesSectionOther"],
		icons = L["BarTextVariablesSectionIcons"],
	}
	-- Recognized group keys. Metadata inference stays section-based, so each entry carries its
	-- own source section: Other mixes plain values with pipe commands.
	local validGroupKeys = {}
	for _, groupKey in ipairs(groupOrder) do
		validGroupKeys[groupKey] = true
	end
	local variableLogicType = TRB.Functions.BarText.VariableLogicType
	local variableRenderType = TRB.Functions.BarText.VariableRenderType
	local logicTypeSortOrder = {
		[variableLogicType.NONE] = 0,
		[variableLogicType.BOOLEAN] = 1,
		[variableLogicType.INTEGER] = 2,
		[variableLogicType.NUMBER] = 3,
		[variableLogicType.TEXT] = 4,
		[variableLogicType.UNKNOWN] = 5,
	}
	local renderTypeSortOrder = {
		[variableRenderType.LOGIC_ONLY] = 1,
		[variableRenderType.TEXT] = 2,
		[variableRenderType.ICON] = 3,
		[variableRenderType.COMMAND] = 4,
		[variableRenderType.UNKNOWN] = 5,
	}
	local cdmDependency = TRB.Data.constants.cdmDependency

	local function GetBooleanStatusLabel(value)
		if value == true then
			return L["BarTextVariablesStatusYes"]
		end
		return L["BarTextVariablesStatusNo"]
	end

	local function GetLogicTypeLabel(logicType)
		if logicType == variableLogicType.BOOLEAN then
			return L["BarTextVariablesLogicTypeBoolean"]
		elseif logicType == variableLogicType.INTEGER then
			return L["BarTextVariablesLogicTypeInteger"]
		elseif logicType == variableLogicType.NUMBER then
			return L["BarTextVariablesLogicTypeNumber"]
		elseif logicType == variableLogicType.TEXT then
			return L["BarTextVariablesLogicTypeText"]
		elseif logicType == variableLogicType.NONE then
			return L["BarTextVariablesLogicTypeNone"]
		end
		return L["BarTextVariablesLogicTypeUnknown"]
	end

	local function GetLogicTypeBadge(logicType)
		if logicType == variableLogicType.BOOLEAN then
			return L["BarTextVariablesBadgeBoolean"]
		elseif logicType == variableLogicType.INTEGER then
			return L["BarTextVariablesBadgeInteger"]
		elseif logicType == variableLogicType.NUMBER then
			return L["BarTextVariablesBadgeNumber"]
		elseif logicType == variableLogicType.TEXT then
			return L["BarTextVariablesBadgeText"]
		end
		return ""
	end

	local function GetRenderTypeLabel(renderType)
		if renderType == variableRenderType.TEXT then
			return L["BarTextVariablesRenderTypeText"]
		elseif renderType == variableRenderType.LOGIC_ONLY then
			return L["BarTextVariablesRenderTypeLogicOnly"]
		elseif renderType == variableRenderType.ICON then
			return L["BarTextVariablesRenderTypeIcon"]
		elseif renderType == variableRenderType.COMMAND then
			return L["BarTextVariablesRenderTypeCommand"]
		end
		return L["BarTextVariablesRenderTypeUnknown"]
	end

	local function GetRenderTypeBadge(renderType)
		if renderType == variableRenderType.TEXT then
			return L["BarTextVariablesBadgeTextOutput"]
		elseif renderType == variableRenderType.LOGIC_ONLY then
			return L["BarTextVariablesBadgeLogicOnly"]
		elseif renderType == variableRenderType.ICON then
			return L["BarTextVariablesBadgeIcon"]
		elseif renderType == variableRenderType.COMMAND then
			return L["BarTextVariablesBadgeCommand"]
		end
		return ""
	end

	local function GetCdmLabel(cdm)
		if cdm == cdmDependency.REQUIRED then
			return L["BarTextVariablesCdmRequired"]
		end
		return L["BarTextVariablesCdmNone"]
	end

	local function GetCdmBadge(cdm)
		if cdm == cdmDependency.REQUIRED then
			return L["BarTextVariablesBadgeCdm"]
		end
		return ""
	end

	local function BuildDescriptionText(rowData)
		if rowData == nil or rowData.isHeader then
			return L["BarTextVariablesPanelDescriptionDefault"]
		end

		local metadata = rowData.metadata or {}
		local summary = {
			L["BarTextVariablesDescriptionSecret"] .. ": " .. GetBooleanStatusLabel(metadata.secret),
			L["BarTextVariablesDescriptionCdm"] .. ": " .. GetCdmLabel(metadata.cdm),
			L["BarTextVariablesDescriptionLogicType"] .. ": " .. GetLogicTypeLabel(metadata.logicType),
			L["BarTextVariablesDescriptionBooleanCheck"] .. ": " .. GetBooleanStatusLabel(metadata.booleanCheck),
			L["BarTextVariablesDescriptionLogicComparisons"] .. ": " .. GetBooleanStatusLabel(metadata.comparisonUsable),
			L["BarTextVariablesDescriptionOutput"] .. ": " .. GetRenderTypeLabel(metadata.renderType),
		}

		local description = rowData.description or ""
		if description ~= "" then
			return description .. "\n\n" .. table.concat(summary, "\n")
		end
		return table.concat(summary, "\n")
	end

	local function GetColumnTooltipText(column, rowData)
		if rowData ~= nil and not rowData.isHeader then
			local metadata = rowData.metadata or {}
			if column == 3 then
				local secretText = L["BarTextVariablesDescriptionSecret"] .. ": " .. GetBooleanStatusLabel(metadata.secret)
				if metadata.secret then
					secretText = secretText .. "\n" .. L["BarTextVariablesDescriptionSecretNoComparisons"]
				end
				return secretText
			elseif column == 4 then
				return L["BarTextVariablesDescriptionCdm"] .. ": " .. GetCdmLabel(metadata.cdm)
			elseif column == 5 then
				return L["BarTextVariablesDescriptionBooleanCheck"] .. ": " .. GetBooleanStatusLabel(metadata.booleanCheck)
			elseif column == 6 then
				return L["BarTextVariablesDescriptionLogicType"] .. ": " .. GetLogicTypeLabel(metadata.logicType) .. "\n" .. L["BarTextVariablesDescriptionLogicComparisons"] .. ": " .. GetBooleanStatusLabel(metadata.comparisonUsable)
			elseif column == 7 then
				return L["BarTextVariablesDescriptionOutput"] .. ": " .. GetRenderTypeLabel(metadata.renderType)
			end
		end

		if column == 2 then
			return L["BarTextVariablesColumnNameTooltip"]
		elseif column == 3 then
			return L["BarTextVariablesColumnSecretComparisonsTooltip"]
		elseif column == 4 then
			return L["BarTextVariablesColumnCdmTooltip"]
		elseif column == 5 then
			return L["BarTextVariablesColumnBooleanTooltip"]
		elseif column == 6 then
			return L["BarTextVariablesColumnTypeTooltip"]
		elseif column == 7 then
			return L["BarTextVariablesColumnOutputTooltip"]
		end
		return nil
	end

	local function ShowTooltip(owner, text)
		if owner == nil or text == nil or text == "" then
			return
		end
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		GameTooltip:SetText(text, 1, 1, 1)
		GameTooltip:Show()
	end

	---Variable name plus its description, so the description is readable without selecting the row.
	---Anchored to the cell's TOPLEFT rather than the preset ANCHOR_RIGHT, which uses TOPRIGHT and
	---puts the tooltip over the badge columns on a cell this wide.
	local function ShowVariableTooltip(owner, rowData)
		if owner == nil or rowData == nil then
			return
		end
		local variable = rowData.variable or ""
		if variable == "" then
			return
		end
		GameTooltip:SetOwner(owner, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOMLEFT", owner, "TOPLEFT", 0, 0)
		GameTooltip:SetText(variable, 1, 1, 1)
		local description = rowData.description or ""
		if description ~= "" then
			GameTooltip:AddLine(description, nil, nil, nil, true)
		end
		GameTooltip:Show()
	end

	local function CompareVariableRows(scrollingTable, rowA, rowB, sortByColumn)
		local dataA = scrollingTable.data[rowA]
		local dataB = scrollingTable.data[rowB]
		if dataA == nil or dataB == nil then
			return false
		end

		-- Groups always keep their position; only their contents re-sort.
		local groupA = dataA.groupIndex or 99
		local groupB = dataB.groupIndex or 99
		if groupA ~= groupB then
			return groupA < groupB
		end

		if dataA.isHeader ~= dataB.isHeader then
			return dataA.isHeader == true
		end
		if dataA.isHeader and dataB.isHeader then
			return false
		end

		local sortValueA = dataA.sortVariable
		local sortValueB = dataB.sortVariable
		if sortByColumn == 3 then
			sortValueA = dataA.sortSecret
			sortValueB = dataB.sortSecret
		elseif sortByColumn == 4 then
			sortValueA = dataA.sortCdm
			sortValueB = dataB.sortCdm
		elseif sortByColumn == 5 then
			sortValueA = dataA.sortBooleanCheck
			sortValueB = dataB.sortBooleanCheck
		elseif sortByColumn == 6 then
			sortValueA = dataA.sortLogicType
			sortValueB = dataB.sortLogicType
		elseif sortByColumn == 7 then
			sortValueA = dataA.sortRenderType
			sortValueB = dataB.sortRenderType
		end

		if sortValueA == sortValueB then
			if dataA.sortVariable == dataB.sortVariable then
				return false
			end
			return dataA.sortVariable < dataB.sortVariable
		end

		local column = scrollingTable.cols[sortByColumn]
		local direction = column.sort or column.defaultsort or 1
		if direction == 1 then
			return sortValueA < sortValueB
		end
		return sortValueA > sortValueB
	end

	---Buckets the spec's visible barTextVariables entries into their display groups.
	---Values split across Stats/Resources/Abilities/Cast Bar/Other; icons and pipe commands are
	---resolved by the categorizer. Each bucket entry keeps its source section for metadata inference.
	---@param barTextVariables table # The barTextVariables table with values, pipe, and icons sections
	---@return table<string, table[]> # Map of group key to a list of { entry, sectionKey } records
	local function GroupVariableEntries(barTextVariables)
		local grouped = {}
		for _, sectionKey in ipairs({ "values", "icons", "pipe" }) do
			local sectionEntries = barTextVariables[sectionKey]
			if sectionEntries then
				for _, entry in ipairs(sectionEntries) do
					if entry.printInSettings then
						local groupKey = TRB.Functions.BarText:GetVariableCategory(entry, sectionKey)
						-- An unrecognized category would otherwise drop the entry from the panel entirely.
						if not validGroupKeys[groupKey] then
							groupKey = TRB.Functions.BarText.VariableCategory.ABILITIES
						end
						grouped[groupKey] = grouped[groupKey] or {}
						table.insert(grouped[groupKey], { entry = entry, sectionKey = sectionKey })
					end
				end
			end
		end
		return grouped
	end

	---Builds a flat data array for LibScrollingTable from the spec's barTextVariables, organized by group.
	---@param barTextVariables table # The barTextVariables table with values, pipe, and icons sections
	---@return table[] # Flat array of row data for LibScrollingTable
	local function BuildDataTable(barTextVariables)
		local data = {}
		local grouped = GroupVariableEntries(barTextVariables)

		for groupIndex, groupKey in ipairs(groupOrder) do
			local groupEntries = grouped[groupKey]
			if groupEntries and #groupEntries > 0 then
				-- Group header row
				table.insert(data, {
					cols = {
						{ value = "" },
						{ value = groupLabels[groupKey] },
						{ value = "" },
						{ value = "" },
						{ value = "" },
						{ value = "" },
						{ value = "" },
					},
					isHeader = true,
					groupKey = groupKey,
					groupIndex = groupIndex,
					variable = "",
					description = "",
				})
				-- Variable rows
				for _, record in ipairs(groupEntries) do
					local entry = record.entry
					local sectionKey = record.sectionKey
					local desc = entry.description or ""
					if sectionKey == "icons" and entry.icon and entry.icon ~= "" then
						desc = entry.icon .. " " .. desc
					end
					local metadata = TRB.Functions.BarText:GetVariableMetadata(entry, sectionKey)
					local variable = entry.variable or ""
					table.insert(data, {
						cols = {
							{ value = L["BarTextVariablesAddButton"] },
							{ value = variable },
							{ value = metadata.secret and L["BarTextVariablesBadgeSecret"] or "" },
							{ value = GetCdmBadge(metadata.cdm) },
							{ value = metadata.booleanCheck and L["BarTextVariablesBadgeBooleanCheck"] or "" },
							{ value = GetLogicTypeBadge(metadata.logicType) },
							{ value = GetRenderTypeBadge(metadata.renderType) },
						},
						isHeader = false,
						groupKey = groupKey,
						groupIndex = groupIndex,
						variable = variable,
						description = desc,
						metadata = metadata,
						sortVariable = string.lower(variable),
						sortSecret = metadata.secret and 1 or 0,
						sortBooleanCheck = metadata.booleanCheck and 1 or 0,
						sortLogicType = logicTypeSortOrder[metadata.logicType] or logicTypeSortOrder[variableLogicType.UNKNOWN],
						sortRenderType = renderTypeSortOrder[metadata.renderType] or renderTypeSortOrder[variableRenderType.UNKNOWN],
						sortCdm = metadata.cdm == cdmDependency.REQUIRED and 1 or 0,
					})
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
	-- Reserve space: panel top (72px for title+search) + description pane (descHeight + gap)
	-- The table container fills the remainder. Estimate available height.
	-- We use a conservative default; the table will scroll.
	local estimatedTableHeight = 400  -- Reasonable default, will be dynamically limited by anchors
	local numDisplayRows = math.max(5, math.floor(estimatedTableHeight / rowHeight))

	-- =============================================
	-- LibScrollingTable columns
	-- Column 1 = Add button (+), Column 2 = Variable name, Columns 3-7 = metadata badges
	-- =============================================
	local function UpdateMetadataCell(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, st)
		if not fShow then return end
		local rowData = data[realrow]
		if rowData and rowData.isHeader then
			cellFrame.text:SetText("")
		else
			cellFrame.text:SetFontObject(GameFontHighlightSmall)
			cellFrame.text:SetTextColor(1, 1, 1, 1)
			cellFrame.text:SetText(rowData and rowData.cols[column].value or "")
		end
	end

	-- LibScrollingTable indents its rows 6px and reserves 22px on the right for the scroll trough.
	local tableChrome = 32

	local columns = {
		{
			["name"] = "",
			["width"] = 16,
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
			["name"] = L["BarTextVariablesColumnName"],
			-- Placeholder; tableContainer's OnSizeChanged recomputes this from the real container width.
			["width"] = panelWidth - 203,
			["align"] = "LEFT",
			["sort"] = 1,
			["defaultsort"] = 1,
			["comparesort"] = CompareVariableRows,
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
		{
			["name"] = L["BarTextVariablesColumnSecret"],
			["width"] = 20,
			["align"] = "CENTER",
			["defaultsort"] = 2,
			["comparesort"] = CompareVariableRows,
			["DoCellUpdate"] = UpdateMetadataCell,
		},
		{
			["name"] = L["BarTextVariablesColumnCdm"],
			["width"] = 20,
			["align"] = "CENTER",
			["defaultsort"] = 2,
			["comparesort"] = CompareVariableRows,
			["DoCellUpdate"] = UpdateMetadataCell,
		},
		{
			["name"] = L["BarTextVariablesColumnBoolean"],
			["width"] = 20,
			["align"] = "CENTER",
			["defaultsort"] = 2,
			["comparesort"] = CompareVariableRows,
			["DoCellUpdate"] = UpdateMetadataCell,
		},
		{
			["name"] = L["BarTextVariablesColumnType"],
			["width"] = 38,
			["align"] = "CENTER",
			["defaultsort"] = 1,
			["comparesort"] = CompareVariableRows,
			["DoCellUpdate"] = UpdateMetadataCell,
		},
		{
			["name"] = L["BarTextVariablesColumnOutput"],
			["width"] = 42,
			["align"] = "CENTER",
			["defaultsort"] = 1,
			["comparesort"] = CompareVariableRows,
			["DoCellUpdate"] = UpdateMetadataCell,
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
		-- Resize variable column (col 2) to fill remaining width after fixed metadata columns.
		local fixedWidth = columns[1].width + columns[3].width + columns[4].width + columns[5].width + columns[6].width + columns[7].width
		columns[2].width = math.max(110, w - fixedWidth - tableChrome)
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
			if button == "LeftButton" and row == nil and realrow == nil then
				return column == 1
			end

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
						descText:SetText(BuildDescriptionText(rowData))
						scrollingTable:SetSelection(realrow)
					end
				end
			end
			return true
		end,
		["OnEnter"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if not realrow or realrow <= 0 then
				ShowTooltip(cellFrame, GetColumnTooltipText(column, nil))
				return true
			end
			if realrow and realrow > 0 then
				local rowData = data[realrow]
				if rowData and not rowData.isHeader then
					scrollingTable:SetHighLightColor(rowFrame, scrollingTable:GetDefaultHighlight())
					-- Tooltip for add button
					if column == 1 then
						ShowTooltip(cellFrame, L["BarTextVariablesAddTooltip"])
					elseif column == 2 then
						ShowVariableTooltip(cellFrame, rowData)
					elseif column >= 3 then
						ShowTooltip(cellFrame, GetColumnTooltipText(column, rowData))
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
		if #newData > 0 then
			allData = newData
			variablesTable:SetData(allData)
			variablesTable:SortData()
			cf.allData = allData
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

