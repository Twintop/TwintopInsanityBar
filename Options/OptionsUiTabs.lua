---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Tabs = TRB.Functions.OptionsUi.Tabs or {}
local oUi = TRB.Data.constants.optionsUi

-- Reverse map (namePrefix -> {classId, specId}) so the all-spec castbar tab can be injected centrally
-- in BuildTabGroup without per-class wiring. Built lazily from the spec registry and cached.
local castbarSpecByNamePrefix = nil
local function GetCastbarSpecMap()
	if castbarSpecByNamePrefix ~= nil then
		return castbarSpecByNamePrefix
	end
	castbarSpecByNamePrefix = {}
	local byIds = TRB.Data.specRegistryByIds
	if type(byIds) == "table" then
		for classId, byClass in pairs(byIds) do
			for specId in pairs(byClass) do
				local cn, sn = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
				castbarSpecByNamePrefix[cn .. "_" .. sn] = { classId = classId, specId = specId }
			end
		end
	end
	return castbarSpecByNamePrefix
end

-- Every bar tab built so far, so one visibility change can recolour labels across every panel at
-- once. Panels are built lazily and never torn down, so this only ever grows to the tabs in use.
local barTabs = {}

---Applies a tab's label font, swapping in the red variant when the tab's bar is disabled.
---The font object is what carries the label colour, so this must run after every font swap.
---@param tab Button # The tab button
---@param isActive boolean # True when this is the tab group's currently selected tab
function TRB.Functions.OptionsUi.Tabs:ApplyTabLabelFont(tab, isActive)
	local fonts = TRB.Options.fonts.options
	if tab.isBarDisabled then
		tab.Text:SetFontObject(isActive and fonts.tabRedHighlightSmall or fonts.tabRedSmall)
	else
		tab.Text:SetFontObject(isActive and fonts.tabHighlightSmall or fonts.tabNormalSmall)
	end
end

---Recolours every bar tab label built so far from the visibility settings currently in effect,
---so a disabled bar is obvious from the tab strip without opening the tab.
function TRB.Functions.OptionsUi.Tabs:RefreshBarTabStates()
	for _, entry in ipairs(barTabs) do
		local visSettings = TRB.Functions.OptionsUi.Visibility:ResolveBarVisibilityEntry(entry.classId, entry.specId, entry.visibilityKey)
		---@diagnostic disable-next-line: inject-field
		entry.tab.isBarDisabled = visSettings ~= nil and visSettings.neverShow == true
		local parent = entry.tab:GetParent()
		self:ApplyTabLabelFont(entry.tab, parent ~= nil and parent.lastTabId == entry.tab.id)
	end
end

---Creates a scroll frame container with a child frame for scrollable options content.
---@param name string # Global frame name for the scroll frame
---@param parent Frame # The parent frame
---@param width number? # Width of the scroll frame (default 560)
---@param height number? # Height of the scroll frame (default 540)
---@param scrollChild Frame? # Optional pre-existing child frame; a new one is created if nil
---@return ScrollFrame
function TRB.Functions.OptionsUi.Tabs:CreateScrollFrameContainer(name, parent, width, height, scrollChild)
	width = width or 560
	height = height or 540
	local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	sf:SetWidth(width)
	sf:SetHeight(height)
	if scrollChild then
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = scrollChild
		sf.scrollChild:SetParent(sf)
	else
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = CreateFrame("Frame", nil, sf)
	end
	sf.scrollChild:SetWidth(width)
	sf.scrollChild:SetHeight(height-10)
	sf:SetScrollChild(sf.scrollChild)
	return sf
end

---Creates a bordered tab content frame with an optional embedded scroll frame.
---@param name string # Global frame name for the container
---@param parent Frame # The parent frame
---@param width number? # Width of the container (nil to fill parent width)
---@param height number? # Height of the container (nil to fill parent height)
---@param isManualScrollFrame boolean? # If true, skips creating the embedded scroll frame
---@param headerBuilder fun(container: Frame): Frame|nil # Optional builder for a pinned header above the scroll frame
---@return Frame|BackdropTemplate
function TRB.Functions.OptionsUi.Tabs:CreateTabFrameContainer(name, parent, width, height, isManualScrollFrame, headerBuilder)
	local fillParent = (width == nil and height == nil)
	width = width or 652
	height = height or 523
	local cf = CreateFrame("Frame", name, parent, "BackdropTemplate")
	cf:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	})
	cf:SetBackdropColor(0, 0, 0, 0.5)

	if fillParent then
		-- Caller sets TOPLEFT; stretch to bottom-right of parent, mirroring the TOPLEFT x-padding
		cf:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -5, 0)
	else
		cf:SetWidth(width)
		cf:SetHeight(height)
		cf:SetPoint("TOPLEFT", 0, 0)
	end

	-- A pinned header sits above the scroll frame so it stays put while the tab's content scrolls.
	local headerReservedHeight = 0
	if headerBuilder then
		---@diagnostic disable-next-line: inject-field
		cf.visibilityHeader = headerBuilder(cf)
		headerReservedHeight = TRB.Functions.OptionsUi.Visibility.barTabHeaderReservedHeight
	end

	if not isManualScrollFrame then
		---@diagnostic disable-next-line: inject-field
		cf.scrollFrame = TRB.Functions.OptionsUi.Tabs:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8 - headerReservedHeight)
		cf.scrollFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -5 - headerReservedHeight)
		if fillParent then
			cf.scrollFrame:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", -25, 5)
			-- Keep scrollChild width in sync with the resolved scrollFrame width
			cf.scrollFrame:HookScript("OnSizeChanged", function(self, w, h)
				if self.scrollChild then
					self.scrollChild:SetWidth(w)
				end
			end)
		end
	end
	return cf
end

---Hides every registered Bar Text Variables panel and clears the active panel reference.
function TRB.Functions.OptionsUi.Tabs:HideAllBarTextVariablesPanels()
	local registry = TRB.Frames.barTextVariablesPanelRegistry
	if registry ~= nil then
		for _, panel in pairs(registry) do
			if panel ~= nil then
				panel:Hide()
			end
		end
	end

	if TRB.Frames.barTextVariablesPanel ~= nil then
		TRB.Frames.barTextVariablesPanel:Hide()
	end

	TRB.Frames.barTextVariablesPanel = nil
end

---Shows the Bar Text Variables panel associated with the given scroll child.
---@param scrollChild Frame|nil
function TRB.Functions.OptionsUi.Tabs:ActivateBarTextVariablesPanel(scrollChild)
	self:HideAllBarTextVariablesPanels()

	if scrollChild ~= nil and scrollChild.barTextVariablesPanel ~= nil then
		TRB.Frames.barTextVariablesPanel = scrollChild.barTextVariablesPanel
		TRB.Frames.barTextVariablesPanel:Show()
		if TRB.Frames.barTextVariablesPanel.variablesTable ~= nil then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end
end

---Switches the visible tab in a multi-tab options panel, updating visual states and toggling the bar text variables flyout.
---@param self Button # The tab button that was clicked
---@param tabId string # The key of the tab to switch to
function TRB.Functions.OptionsUi.Tabs.SwitchTab(self, tabId)
	local parent = self:GetParent()
	---@cast parent table
	if parent.lastTab then
		parent.lastTab:Hide()
		local lastTab = parent.tabs[parent.lastTabId]
		TRB.Functions.OptionsUi.Tabs:ApplyTabLabelFont(lastTab, false)
		lastTab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
		lastTab.bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
	end

	-- Lazy construction: build the tab content on first visit
	if parent.tabConstructors and parent.tabConstructors[tabId] then
		parent.tabConstructors[tabId](parent.tabsheets[tabId].constructorFrame)
		parent.tabConstructors[tabId] = nil
	end

	parent.tabsheets[tabId]:Show()
	local activeTab = parent.tabs[tabId]
	TRB.Functions.OptionsUi.Tabs:ApplyTabLabelFont(activeTab, true)
	activeTab:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	activeTab.bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
	parent.lastTab = parent.tabsheets[tabId]
	parent.lastTabId = tabId

	-- Show/hide the Bar Text Variables flyout based on active tab
	if tabId == "barText" then
		-- Swap to the correct spec's variables panel via the tabsheet's scrollChild
		local barTextSheet = parent.tabsheets and parent.tabsheets["barText"]
		local scrollChild = barTextSheet and barTextSheet.scrollFrame and barTextSheet.scrollFrame.scrollChild
		TRB.Functions.OptionsUi.Tabs:ActivateBarTextVariablesPanel(scrollChild)
	else
		TRB.Functions.OptionsUi.Tabs:HideAllBarTextVariablesPanels()
		-- Clear active edit box tracking when leaving the Bar Text tab
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
	end
end

---Creates a clickable tab button with hover highlighting, backdrop styling, and a bottom cover for the tab effect.
---@param name string # Global frame name for the tab button
---@param displayText string # Label text shown on the tab
---@param id string # Unique tab identifier key
---@param parent Frame # The parent frame that owns the tab set
---@param width number? # Tab width in pixels (default 100)
---@return Button|BackdropTemplate
function TRB.Functions.OptionsUi.Tabs:CreateTab(name, displayText, id, parent, width)
	width = width or 100
	local tabHeight = 20
	local tab = CreateFrame("Button", name, parent, "BackdropTemplate")
	---@diagnostic disable-next-line: inject-field
	tab.id = id
	tab:SetSize(width, tabHeight)

	-- Border + background via backdrop
	tab:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

	-- Bottom cover: hides the bottom border to create a tab effect.
	-- Extends slightly below the frame to also cover the top border of what's beneath.
	local bottomCover = tab:CreateTexture(nil, "OVERLAY")
	bottomCover:SetHeight(6)
	bottomCover:SetPoint("BOTTOMLEFT", 1, -1)
	bottomCover:SetPoint("BOTTOMRIGHT", -1, -1)
	bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
	---@diagnostic disable-next-line: inject-field
	tab.bottomCover = bottomCover

	-- Label
	local label = tab:CreateFontString(nil, "OVERLAY")
	label:SetFontObject(TRB.Options.fonts.options.tabNormalSmall)
	label:SetPoint("CENTER", 0, 1)
	label:SetText(displayText)
	---@diagnostic disable-next-line: inject-field
	tab.Text = label

	-- Hover highlight
	tab:SetScript("OnEnter", function(self)
		if parent.lastTabId ~= self.id then
			self:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
			self.bottomCover:SetColorTexture(0.35, 0.35, 0.35, 1.0)
		end
	end)
	tab:SetScript("OnLeave", function(self)
		if parent.lastTabId ~= self.id then
			self:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
			self.bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
		end
	end)

	tab:SetScript("OnClick", function(self)
		TRB.Functions.OptionsUi.Tabs.SwitchTab(self, self.id)
	end)

	return tab
end

---Switches to a specific tab by key for a panel identified by its tab-group name prefix.
---@param namePrefix string The tab-group name prefix (e.g., "Global", "Castbar", "Priest_shadow")
---@param tabKey string The tab key to switch to (e.g., "barText", "barDisplay")
function TRB.Functions.OptionsUi.Tabs:SwitchToTabByNamePrefix(namePrefix, tabKey)
	local tab = _G["TwintopResourceBar_Options_" .. namePrefix .. "_Tab_" .. tabKey]
	if tab then
		TRB.Functions.OptionsUi.Tabs.SwitchTab(tab, tab.id)
	end
end

---Switches to a specific tab by key for a given class/spec's options panel.
---@param classId integer
---@param specId integer
---@param tabKey string The tab key to switch to (e.g., "barText", "barDisplay")
function TRB.Functions.OptionsUi.Tabs:SwitchToTabByClassSpec(classId, specId, tabKey)
	local namePrefix
	if classId == nil then
		namePrefix = "Global"
	else
		local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		namePrefix = className .. "_" .. specName
	end
	TRB.Functions.OptionsUi.Tabs:SwitchToTabByNamePrefix(namePrefix, tabKey)
end

---Switches to the Bar Text tab for a given class/spec. Convenience wrapper around SwitchToTabByClassSpec.
---@param classId integer
---@param specId integer
function TRB.Functions.OptionsUi.Tabs:SwitchToBarTextTabByClassSpec(classId, specId)
	TRB.Functions.OptionsUi.Tabs:SwitchToTabByClassSpec(classId, specId, "barText")
end

---Standard tab key constants used across all options panels.
TRB.Functions.OptionsUi.Tabs.TabKeys = {
	BarDisplay = "barDisplay",
	Thresholds = "thresholds",
	FontText = "fontText",
	AudioTracking = "audioTracking",
	BarText = "barText",
	Miscellaneous = "miscellaneous",
	ResetDefaults = "resetDefaults",
	EnergyBar = "energyBar",
	StaggerBar = "staggerBar",
	HealthBar = "healthBar",
	BarTextures = "barTextures",
	BarVisibility = "barVisibility",
}

---Builds the nested Cast Bar sub-tab group (player / target / focus) inside a spec's Cast Bar tab.
---Each sub-tab is scoped to the given spec so its settings can be overridden per-spec. The namePrefix
---never matches the castbar spec map, so BuildTabGroup's auto-injection is skipped here. Hosted in a
---manual (non-scroll) container so each sub-tab supplies its own scroll frame.
---@param parent Frame # The Cast Bar tab's manual container frame
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi.Tabs:BuildCastbarInnerTabGroup(parent, classId, specId)
	if parent == nil then
		return
	end
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = "CastbarInner_" .. tostring(className) .. "_" .. tostring(specName)
	local innerTabs = {
		{ "castbar", TRB.Localization["ResourcePlayerCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.Castbar:ConstructPanel(scrollChild, classId, specId, TRB.Functions.OptionsUi.Castbar:SpecUsesEmpower(classId, specId))
		end, visibilityKey = "castbar" },
		{ "target", TRB.Localization["ResourceTargetCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.TargetCastbar:ConstructPanel(scrollChild, classId, specId, "targetCastbar")
		end, visibilityKey = "targetCastbar" },
		{ "focus", TRB.Localization["ResourceFocusCastbar"], oUi.tabWidth.small, function(scrollChild)
			TRB.Functions.OptionsUi.TargetCastbar:ConstructPanel(scrollChild, classId, specId, "focusCastbar")
		end, visibilityKey = "focusCastbar" },
	}
	-- The synthesized namePrefix never matches the castbar spec map, so the scope is passed explicitly.
	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, innerTabs, -10, { classId = classId, specId = specId })
end

---Builds the nested Other Bars sub-tab group (GCD / Fatigue / Breath / Death / Feign Death) inside a
---spec's Other Bars tab. Feign Death is only offered to Hunters. Structured exactly like the Cast Bar
---inner group: a manual (non-scroll) container whose sub-tabs each supply their own scroll frame.
---@param parent Frame # The Other Bars tab's manual container frame
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi.Tabs:BuildOtherBarsInnerTabGroup(parent, classId, specId)
	if parent == nil then
		return
	end
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = "OtherBarsInner_" .. tostring(className) .. "_" .. tostring(specName)
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local innerTabs = {}
	for _, barKey in ipairs(registry:GetOtherBarKeys(classId)) do
		local barDef = registry:Get(barKey)
		if barDef ~= nil then
			local capturedKey = barKey
			innerTabs[#innerTabs + 1] = {
				capturedKey,
				barDef.displayName,
				oUi.tabWidth.small,
				function(scrollChild)
					TRB.Functions.OptionsUi.OtherBars:ConstructPanel(scrollChild, classId, specId, capturedKey)
				end,
				visibilityKey = capturedKey,
			}
		end
	end
	if #innerTabs == 0 then
		return
	end
	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, innerTabs, -10, { classId = classId, specId = specId })
end

---Builds a dynamic set of tabs and tabsheets for an options panel.
---Tabs automatically wrap to multiple rows when they would exceed the parent frame's width.
---@param parent Frame The parent frame to attach tabs to (e.g., the spec display panel)
---@param namePrefix string The naming prefix (e.g., "Priest_Shadow")
---@param tabDefinitions table[] Ordered list of tab definitions: { [1]=key:string, [2]=label:string, [3]=width:number, [4]=constructor:function(scrollChild) }. A named `visibilityKey` field marks a bar tab and gives it a pinned enable/disable header.
---@param yCoord number The starting y coordinate for the tabs row. Will be adjusted internally.
---@param specContext table? Explicit { classId, specId } scope; only needed when namePrefix is synthesized (e.g. the castbar sub-tab group)
---@return number yCoord The adjusted yCoord after tabs are placed (for further content below if needed)
function TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord, specContext)
	local optionsUiFuncs = TRB.Functions.OptionsUi.Tabs

	-- Normalize: support both positional { key, label, width, constructor, isManualScrollFrame } and named
	for i, def in ipairs(tabDefinitions) do
		if def[1] == nil and def.key ~= nil then
			def[1] = def.key
			def[2] = def.label
			def[3] = def.width
			def[4] = def.constructor
			def[5] = def.isManualScrollFrame
		end
	end

	-- Inject the all-spec castbar tab once for real spec panels (resolved from namePrefix).
	local castbarSpec = GetCastbarSpecMap()[namePrefix]
	if castbarSpec then
		local hasCastbar = false
		for _, def in ipairs(tabDefinitions) do
			if def[1] == "castbar" then
				hasCastbar = true
				break
			end
		end
		if not hasCastbar then
			local cId, sId = castbarSpec.classId, castbarSpec.specId
			-- Insert immediately after the Health tab; append if the panel has none.
			local insertIndex = #tabDefinitions + 1
			for i, def in ipairs(tabDefinitions) do
				if def[1] == "healthBar" then
					insertIndex = i + 1
					break
				end
			end
			table.insert(tabDefinitions, insertIndex, {
				"castbar",
				TRB.Localization["TabCastbars"],
				oUi.tabWidth.small,
				function(scrollChild)
					-- Nested sub-tabs (player / target / focus), each scoped to this spec.
					TRB.Functions.OptionsUi.Tabs:BuildCastbarInnerTabGroup(scrollChild, cId, sId)
				end,
				true -- manual container: the inner sub-tabs provide their own scroll frames
			})
		end

		-- Other Bars sits immediately after Cast Bars, structured the same way.
		local hasOtherBars = false
		for _, def in ipairs(tabDefinitions) do
			if def[1] == "otherBars" then
				hasOtherBars = true
				break
			end
		end
		if not hasOtherBars then
			local cId, sId = castbarSpec.classId, castbarSpec.specId
			local insertIndex = #tabDefinitions + 1
			for i, def in ipairs(tabDefinitions) do
				if def[1] == "castbar" then
					insertIndex = i + 1
					break
				end
			end
			table.insert(tabDefinitions, insertIndex, {
				"otherBars",
				TRB.Localization["TabOtherBars"],
				oUi.tabWidth.small,
				function(scrollChild)
					TRB.Functions.OptionsUi.Tabs:BuildOtherBarsInnerTabGroup(scrollChild, cId, sId)
				end,
				true -- manual container: the inner sub-tabs provide their own scroll frames
			})
		end
	end

	local tabs = {}
	local tabsheets = {}
	local tabOrder = {}

	local leftPadding = 15
	local rightPadding = 15
	local tabRowHeight = 20
	local borderOverlap = 0 -- rows overlap by this amount so borders touch
	local tabSpacing = 5 -- horizontal gap between tabs
	local maxWidth = parent:GetWidth() - leftPadding - rightPadding

	-- Pass 1: Break definitions into rows based on available width (accounting for spacing)
	local rows = { {} }
	local rowWidths = { 0 }
	local currentRow = 1

	for i, def in ipairs(tabDefinitions) do
		local width = def[3]
		local numInRow = #rows[currentRow]
		local totalWithNew = rowWidths[currentRow] + width + (numInRow > 0 and tabSpacing or 0)
		if numInRow > 0 and totalWithNew > maxWidth then
			currentRow = currentRow + 1
			rows[currentRow] = {}
			rowWidths[currentRow] = 0
		end
		local n = #rows[currentRow]
		rows[currentRow][n + 1] = def
		rowWidths[currentRow] = rowWidths[currentRow] + width + (n > 0 and tabSpacing or 0)
	end

	local numRows = #rows

	-- Pass 2: Create tabs, distribute extra width evenly, and position left-aligned per row
	for rowIndex, rowDefs in ipairs(rows) do
		local rowY = yCoord - ((rowIndex - 1) * (tabRowHeight - borderOverlap))
		local numTabs = #rowDefs
		local totalSpacing = (numTabs - 1) * tabSpacing
		local baseRowWidth = 0
		for _, def in ipairs(rowDefs) do
			baseRowWidth = baseRowWidth + def[3]
		end
		local extraSpace = maxWidth - baseRowWidth - totalSpacing
		local extraPerTab = math.floor(extraSpace / numTabs)
		local remainder = extraSpace - (extraPerTab * numTabs)

		local prevTab = nil
		for colIndex, def in ipairs(rowDefs) do
			local key = def[1]
			local label = def[2]
			local width = def[3] + extraPerTab + (colIndex <= remainder and 1 or 0)
			local frameName = "TwintopResourceBar_Options_" .. namePrefix .. "_Tab_" .. key
			tabs[key] = optionsUiFuncs:CreateTab(frameName, label, key, parent, width)
			tabOrder[#tabOrder + 1] = key

			if colIndex == 1 then
				tabs[key]:SetPoint("TOPLEFT", parent, "TOPLEFT", leftPadding, rowY)
			else
				tabs[key]:SetPoint("LEFT", prevTab, "RIGHT", tabSpacing, 0)
			end

			prevTab = tabs[key]
		end
	end

	-- Offset yCoord past all tab rows
	yCoord = yCoord - (numRows * tabRowHeight) + ((numRows) * borderOverlap)

	-- Resolve which class/spec owns this tab group so bar tabs can render their visibility header.
	-- Spec panels resolve from namePrefix; callers with a synthesized prefix pass their scope
	-- explicitly. No match means global scope (the Global Options and Castbar panels).
	local scope = specContext or GetCastbarSpecMap()[namePrefix]
	local scopeClassId = scope and scope.classId or nil
	local scopeSpecId = scope and scope.specId or nil

	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		local isManual = def[5] or def.isManualScrollFrame
		-- A visibilityKey marks this tab as a bar tab, which pins an enable/disable header on top.
		local visibilityKey = def.visibilityKey
		local headerBuilder = nil
		if visibilityKey ~= nil then
			headerBuilder = function(containerFrame)
				return TRB.Functions.OptionsUi.Visibility:BuildBarTabVisibilityHeader(containerFrame, namePrefix, scopeClassId, scopeSpecId, visibilityKey)
			end
			barTabs[#barTabs + 1] = { tab = tabs[key], classId = scopeClassId, specId = scopeSpecId, visibilityKey = visibilityKey }
		end
		tabsheets[key] = optionsUiFuncs:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel_" .. key, parent, nil, nil, isManual, headerBuilder)
		tabsheets[key]:Hide()
		tabsheets[key]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		---@diagnostic disable-next-line: inject-field
		tabsheets[key].constructorFrame = (not isManual and tabsheets[key].scrollFrame) and tabsheets[key].scrollFrame.scrollChild or tabsheets[key]

		-- Resync the header whenever the tab becomes visible, so visibility changes made on the
		-- Visibility tab (or on the Global panel) are reflected without any cross-tab broadcast.
		if headerBuilder ~= nil then
			tabsheets[key]:HookScript("OnShow", function(self)
				if self.visibilityHeader ~= nil and self.visibilityHeader.Refresh ~= nil then
					self.visibilityHeader:Refresh()
				end
			end)
		end
	end

	-- Show the first tab by default
	local firstKey = tabOrder[1]
	tabsheets[firstKey]:Show()
	---@diagnostic disable-next-line: inject-field
	tabsheets[firstKey].selected = true
	tabs[firstKey]:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	tabs[firstKey].bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
---@diagnostic disable-next-line: inject-field
	parent.tabs = tabs
---@diagnostic disable-next-line: inject-field
	parent.tabsheets = tabsheets
---@diagnostic disable-next-line: inject-field
	parent.lastTab = tabsheets[firstKey]
---@diagnostic disable-next-line: inject-field
	parent.lastTabId = firstKey
---@diagnostic disable-next-line: inject-field
	parent.tabOrder = tabOrder

	-- Deferred until lastTabId exists, since both calls resolve the active tab from it.
	TRB.Functions.OptionsUi.Tabs:ApplyTabLabelFont(tabs[firstKey], true)
	TRB.Functions.OptionsUi.Tabs:RefreshBarTabStates()

	-- Panels are built once and kept, so a profile import or a change made on another panel can
	-- leave these labels stale. Resync them whenever the panel comes back into view.
	parent:HookScript("OnShow", function()
		TRB.Functions.OptionsUi.Tabs:RefreshBarTabStates()
	end)

	-- Store constructors for lazy tab construction.
	-- Only the first (visible) tab is built eagerly; the rest are deferred until first shown.
	---@diagnostic disable-next-line: inject-field
	parent.tabConstructors = {}
	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		local constructor = def[4]
		if constructor then
			parent.tabConstructors[key] = constructor
		end
	end

	-- Eagerly construct only the first tab (it's already visible)
	if firstKey and parent.tabConstructors[firstKey] then
		parent.tabConstructors[firstKey](tabsheets[firstKey].constructorFrame)
		parent.tabConstructors[firstKey] = nil
	end

	return yCoord
end

---Forces a lazily-deferred tab's content to be constructed if it hasn't been already.
---Used when an action on one tab depends on controls/closures created by another tab's
---constructor (e.g. resetting bar text needs the Bar Text editor's ResetTableValues, which
---only exists once that tab has been built). No-op if the tab is already built or unknown.
---@param displayPanel table # The tab group parent frame (holds tabConstructors/tabsheets)
---@param tabId string # The tab key to ensure is constructed
function TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(displayPanel, tabId)
	if displayPanel and displayPanel.tabConstructors and displayPanel.tabConstructors[tabId]
		and displayPanel.tabsheets and displayPanel.tabsheets[tabId] then
		displayPanel.tabConstructors[tabId](displayPanel.tabsheets[tabId].constructorFrame)
		displayPanel.tabConstructors[tabId] = nil
	end
end


TRB.Functions.OptionsUi.TabKeys = TRB.Functions.OptionsUi.Tabs.TabKeys