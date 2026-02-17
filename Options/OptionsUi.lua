---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = {}
local oUi = TRB.Data.constants.optionsUi

local L = TRB.Localization

local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

-- Mapping of all class names to their spec names for bulk global toggle iteration
local allClassSpecs = {
	deathknight = { "blood", "frost", "unholy" },
	demonhunter = { "havoc", "vengeance", "devourer" },
	druid = { "balance", "feral", "guardian", "restoration" },
	evoker = { "devastation", "preservation", "augmentation" },
	hunter = { "beastMastery", "marksmanship", "survival" },
	mage = { "arcane", "fire", "frost" },
	monk = { "brewmaster", "mistweaver", "windwalker" },
	paladin = { "holy", "protection", "retribution" },
	priest = { "discipline", "holy", "shadow" },
	rogue = { "assassination", "outlaw", "subtlety" },
	shaman = { "elemental", "enhancement", "restoration" },
	warlock = { "affliction", "demonology", "destruction" },
	warrior = { "arms", "fury", "protection" }
}

-- Mapping from settings key to checkbox frame suffix
local settingKeyToCheckboxSuffix = {
	bar = "barDimensions",
	comboPoints = "comboPoints",
	healthBar = "healthBar",
	textures = "textures",
	displayBar = "displayBar",
	thresholdIcons = "thresholdIcons",
	thresholdColors = "thresholdColors",
	displayText = "displayText",
	textColors = "textColors",
	precision = "precision"
}

-- Mapping from lowercase class name to classId for frame name resolution
local classNameToId = {
	deathknight = 6,
	demonhunter = 12,
	druid = 11,
	evoker = 13,
	hunter = 3,
	mage = 8,
	monk = 10,
	paladin = 2,
	priest = 5,
	rogue = 4,
	shaman = 7,
	warlock = 9,
	warrior = 1
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

---Returns true if the panel being edited belongs to (or affects) the currently active spec.
---Used to guard live-preview callbacks so editing a non-active spec's settings doesn't
---trigger unnecessary or incorrect bar updates.
---@param classId integer? # Class ID of the panel being edited (nil for global panel)
---@param specId integer? # Spec ID of the panel being edited (nil for global panel)
---@return boolean
function TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId)
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
	
	for className, specs in pairs(allClassSpecs) do
		if global[className] then
			for _, specName in ipairs(specs) do
				if global[className][specName] and global[className][specName][settingKey] ~= nil then
					if global[className][specName][settingKey] then
						allFalse = false
					else
						allTrue = false
					end
				end
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
	local checkboxSuffix = settingKeyToCheckboxSuffix[settingKey]
	
	-- Update settings for all class/specs
	for className, specs in pairs(allClassSpecs) do
		if global[className] then
			for _, specName in ipairs(specs) do
				if global[className][specName] and global[className][specName][settingKey] ~= nil then
					global[className][specName][settingKey] = value
				end
			end
		end
	end
	
	-- Update all existing per-spec checkboxes in the UI across ALL classes
	if checkboxSuffix then
		for className, specs in pairs(allClassSpecs) do
			local classId = classNameToId[className]
			if classId then
				local capitalizedClassName, _ = TRB.Functions.Character:GetClassAndSpecializationNames(classId, nil)
				for _, specName in ipairs(specs) do
					local frameName = "TwintopResourceBar_" .. capitalizedClassName .. "_" .. specName .. "_useGlobal_" .. checkboxSuffix
					local checkbox = _G[frameName]
					if checkbox then
						checkbox:SetChecked(value)
					end
				end
			end
		end
	end
	
	-- Refresh caches for all specs that have been initialized (specCache exists)
	for className, specs in pairs(allClassSpecs) do
		for _, specName in ipairs(specs) do
			local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
			if TRB.Data.specCache[compositeKey] then
				TRB.Functions.Character:FillSpecializationCacheSettings(className, specName)
			end
		end
	end
	
	-- Trigger bar updates for current spec
	TRB.Functions.Character:ResetCaches()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:HideResourceBar()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	else
		TRB.Functions.Bar:Construct()
	end
end

---Builds a bulk global toggle checkbox for the Global Options panel
---@param parent Frame # Parent frame
---@param controls table # Controls table to store the checkbox
---@param controlKey string # Key to store in controls.checkBoxes
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints")
---@param yCoord number # Y coordinate for positioning
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, controlKey, settingKey, yCoord)
	local f = nil
	
	yCoord = yCoord - 30
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes[controlKey] = CreateFrame("CheckButton", "TwintopResourceBar_Global_enableAll_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[controlKey]
	f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnableForAllSpecs"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	f.tooltip = L["CheckboxEnableForAllSpecsTooltip"]
	
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
	
	return yCoord
end

---Refreshes the bulk global toggle checkbox state based on current per-spec settings
---Call this after changing a per-spec "Use global settings" checkbox
---@param settingKey string # The global setting key (e.g., "bar", "comboPoints", "textures")
function TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(settingKey)
	local frameName = "TwintopResourceBar_Global_enableAll_" .. settingKey
	local checkbox = _G[frameName]
	if checkbox then
		local currentState = GetAllSpecsGlobalState(settingKey)
		SetCheckboxTriState(checkbox, currentState)
	end
end

local sounds = {}
local soundsList = {}
local soundPairs = {}
local soundPairsByName = {}
local function FillSoundCache()
	if TRB.Functions.Table:Length(sounds) == 0 then
		sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")

		local x = 1
		for k, v in pairs(soundsList) do
			table.insert(soundPairs, { v, sounds[v] })
			soundPairsByName[sounds[v]] = v
			x = x + 1
		end
	end
end

local fonts = {}
local fontsList = {}
local fontPairs = {}
local fontPairsByName = {}
local function FillFontCache()
	if TRB.Functions.Table:Length(fonts) == 0 then
		fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
		fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")

		local x = 1
		for k, v in pairs(fontsList) do
			table.insert(fontPairs, { v, fonts[v] })
			fontPairsByName[fonts[v]] = v
			x = x + 1
		end
	end
end

local backgrounds = {}
local backgroundsList = {}
local backgroundPairs = {}
local backgroundPairsByName = {}
local function FillBackgroundCache()
	if TRB.Functions.Table:Length(backgrounds) == 0 then
		backgrounds = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
		backgroundsList = TRB.Details.addonData.libs.SharedMedia:List("background")

		local x = 1
		for k, v in pairs(backgroundsList) do
			table.insert(backgroundPairs, { v, backgrounds[v] })
			backgroundPairsByName[backgrounds[v]] = v
			x = x + 1
		end
	end
end

local borders = {}
local bordersList = {}
local borderPairs = {}
local borderPairsByName = {}
local function FillBorderCache()
	if TRB.Functions.Table:Length(borders) == 0 then
		borders = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
		bordersList = TRB.Details.addonData.libs.SharedMedia:List("border")

		local x = 1
		for k, v in pairs(bordersList) do
			table.insert(borderPairs, { v, borders[v] })
			borderPairsByName[borders[v]] = v
			x = x + 1
		end
	end
end

local statusbars = {}
local statusbarsList = {}
local statusbarPairs = {}
local statusbarPairsByName = {}
local function FillStatusbarCache()
	if TRB.Functions.Table:Length(statusbars) == 0 then
		statusbars = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
		statusbarsList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")

		local x = 1
		for k, v in pairs(statusbarsList) do
			table.insert(statusbarPairs, { v, statusbars[v] })
			statusbarPairsByName[statusbars[v]] = v
			x = x + 1
		end
	end
end

local function DropdownSetupMenuWrapper(control)
	control:SetupMenu(control.GeneratorFunction)
end

-- Code modified from this post by Reskie on the WoW Interface forums: http://www.wowinterface.com/forums/showpost.php?p=296574&postcount=18

---comment
---@param parent Frame
---@param title string
---@param minValue number
---@param maxValue number
---@param defaultValue number
---@param stepValue number
---@param numDecimalPlaces integer
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi:BuildSlider(parent, title, minValue, maxValue, defaultValue, stepValue, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minValue, maxValue)
	f:SetValueStep(stepValue)
	f:SetSize(sizeX-36, sizeY)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
	f:SetOrientation("HORIZONTAL")
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
	   bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	   edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	   tile = true,
	   edgeSize = 8,
	   tileSize = 8,
	   insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	end)
	f:SetScript("OnValueChanged", function(self, value)
		self.EditBox:SetText(value)
	end)
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minValue)
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MaxLabel:SetText(maxValue)
	---@diagnostic disable-next-line: inject-field
	f.Title = f:CreateFontString(nil, "OVERLAY")
	f.Title:SetFontObject(GameFontNormal)
	f.Title:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.Title:SetWordWrap(false)
	f.Title:SetPoint("BOTTOM", f, "TOP")
	f.Title:SetText(title)
	---@diagnostic disable-next-line: inject-field
	f.Thumb = f:CreateTexture(nil, "ARTWORK")
	f.Thumb:SetSize(32, 32)
	f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
	eb:EnableMouseWheel(true)
	eb:SetAutoFocus(false)
	eb:SetNumeric(false)
	eb:SetJustifyH("CENTER")
	eb:SetFontObject(GameFontHighlightSmall)
	eb:SetSize(50, 14)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetPoint("Top", f, "Bottom", 0, -1)
	eb:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	eb:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	eb:SetBackdropColor(0, 0, 0, 1)
	eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	eb:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	eb:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	eb:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			f:SetValue(f:GetValue() + f:GetValueStep())
		else
			f:SetValue(f:GetValue() - f:GetValueStep())
		end
	end)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if value then
			local min, max = f:GetMinMaxValues()
			if value >= min and value <= max then
				f:SetValue(value)
			elseif value < min then
				f:SetValue(min)
			elseif value > max then
				f:SetValue(max)
			end
			value = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
			eb:SetText(value)
		else
			f:SetValue(f:GetValue())
		end
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	---@diagnostic disable-next-line: inject-field
	f.Plus = CreateFrame("Button", nil, f)
	f.Plus:SetSize(18, 18)
	f.Plus:RegisterForClicks("AnyUp")
	f.Plus:SetPoint("LEFT", f, "RIGHT", 0, 0)
	f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Plus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() + f:GetValueStep())
	end)
	---@diagnostic disable-next-line: inject-field
	f.Minus = CreateFrame("Button", nil, f)
	f.Minus:SetSize(18, 18)
	f.Minus:RegisterForClicks("AnyUp")
	f.Minus:SetPoint("RIGHT", f, "LEFT", 0, 0)
	f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Minus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	f:SetValue(defaultValue)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(defaultValue)
	eb:SetCursorPosition(0)

	return f
end

---Builds a slider that displays and accepts percentage values but stores decimal values.
---For example, displays "30%" but stores 0.30 internally.
---@param parent Frame
---@param title string
---@param minPercent number # Minimum value in percentage (e.g., 0 for 0%)
---@param maxPercent number # Maximum value in percentage (e.g., 100 for 100%, or 1000 for 1000%)
---@param defaultDecimalValue number # Default value as a decimal (e.g., 0.30 for 30%)
---@param stepPercent number # Step size in percentage (e.g., 1 for 1%)
---@param numDecimalPlaces integer # Decimal places to show in the percentage display (e.g., 0 for "30%", 2 for "30.00%")
---@param sizeX number
---@param sizeY number
---@param posX number
---@param posY number
---@return table|BackdropTemplate|Slider
function TRB.Functions.OptionsUi:BuildPercentageSlider(parent, title, minPercent, maxPercent, defaultDecimalValue, stepPercent, numDecimalPlaces, sizeX, sizeY, posX, posY)
	local f = CreateFrame("Slider", nil, parent, "BackdropTemplate")
---@diagnostic disable-next-line: inject-field
	f.EditBox = CreateFrame("EditBox", nil, f, "BackdropTemplate")
	f:SetPoint("TOPLEFT", posX+18, posY)
	f:SetMinMaxValues(minPercent, maxPercent)
	f:SetValueStep(stepPercent)
	f:SetSize(sizeX-36, sizeY)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)
	f:SetOrientation("HORIZONTAL")
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
	   bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	   edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	   tile = true,
	   edgeSize = 8,
	   tileSize = 8,
	   insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	f:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1.0)
	end)
	f:SetScript("OnValueChanged", function(self, value)
		-- Display as percentage with % suffix
		local displayValue = TRB.Functions.Number:RoundTo(value, numDecimalPlaces)
		self.EditBox:SetText(displayValue .. "%")
	end)
	---@diagnostic disable-next-line: inject-field
	f.MinLabel = f:CreateFontString(nil, "OVERLAY")
	f.MinLabel:SetFontObject(GameFontHighlightSmall)
	f.MinLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MinLabel:SetWordWrap(false)
	f.MinLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MinLabel:SetText(minPercent .. "%")
	---@diagnostic disable-next-line: inject-field
	f.MaxLabel = f:CreateFontString(nil, "OVERLAY")
	f.MaxLabel:SetFontObject(GameFontHighlightSmall)
	f.MaxLabel:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.MaxLabel:SetWordWrap(false)
	f.MaxLabel:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -1)
---@diagnostic disable-next-line: param-type-mismatch
	f.MaxLabel:SetText(maxPercent .. "%")
	---@diagnostic disable-next-line: inject-field
	f.Title = f:CreateFontString(nil, "OVERLAY")
	f.Title:SetFontObject(GameFontNormal)
	f.Title:SetSize(0, 14)
	---@diagnostic disable-next-line: redundant-parameter
	f.Title:SetWordWrap(false)
	f.Title:SetPoint("BOTTOM", f, "TOP")
	f.Title:SetText(title)
	---@diagnostic disable-next-line: inject-field
	f.Thumb = f:CreateTexture(nil, "ARTWORK")
	f.Thumb:SetSize(32, 32)
	f.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	f:SetThumbTexture(f.Thumb)

	local eb = f.EditBox
	eb:EnableMouseWheel(true)
	eb:SetAutoFocus(false)
	eb:SetNumeric(false)
	eb:SetJustifyH("CENTER")
	eb:SetFontObject(GameFontHighlightSmall)
	eb:SetSize(50, 14)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetPoint("Top", f, "Bottom", 0, -1)
	eb:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	eb:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	eb:SetBackdropColor(0, 0, 0, 1)
	eb:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	eb:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	eb:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	eb:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			f:SetValue(f:GetValue() + f:GetValueStep())
		else
			f:SetValue(f:GetValue() - f:GetValueStep())
		end
	end)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function(self)
		-- Parse the input, stripping any % suffix and converting to number
		local inputText = self:GetText()
		inputText = inputText:gsub("%%", "") -- Remove % sign if present
		local value = tonumber(inputText)
		if value then
			local min, max = f:GetMinMaxValues()
			if value >= min and value <= max then
				f:SetValue(value)
			elseif value < min then
				f:SetValue(min)
			elseif value > max then
				f:SetValue(max)
			end
			value = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(value .. "%")
		else
			-- Invalid input, reset to current value
			local currentValue = TRB.Functions.Number:RoundTo(f:GetValue(), numDecimalPlaces)
			eb:SetText(currentValue .. "%")
		end
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	---@diagnostic disable-next-line: inject-field
	f.Plus = CreateFrame("Button", nil, f)
	f.Plus:SetSize(18, 18)
	f.Plus:RegisterForClicks("AnyUp")
	f.Plus:SetPoint("LEFT", f, "RIGHT", 0, 0)
	f.Plus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	f.Plus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	f.Plus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Plus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() + f:GetValueStep())
	end)
	---@diagnostic disable-next-line: inject-field
	f.Minus = CreateFrame("Button", nil, f)
	f.Minus:SetSize(18, 18)
	f.Minus:RegisterForClicks("AnyUp")
	f.Minus:SetPoint("RIGHT", f, "LEFT", 0, 0)
	f.Minus:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	f.Minus:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	f.Minus:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	f.Minus:SetScript("OnClick", function(self)
		f:SetValue(f:GetValue() - f:GetValueStep())
	end)

	-- Set initial value (convert decimal to percentage for display)
	local initialPercent = defaultDecimalValue * 100
	f:SetValue(initialPercent)
---@diagnostic disable-next-line: param-type-mismatch
	eb:SetText(TRB.Functions.Number:RoundTo(initialPercent, numDecimalPlaces) .. "%")
	eb:SetCursorPosition(0)

	return f
end

function TRB.Functions.OptionsUi:BuildTextBox(parent, text, maxLetters, width, height, xPos, yPos)
	local f = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	f:SetPoint("TOPLEFT", xPos, yPos)
	f:SetAutoFocus(false)
	f:SetMaxLetters(maxLetters)
	f:SetJustifyH("LEFT")
	f:SetFontObject(GameFontHighlight)
	f:SetSize(width, height)
	f:SetTextInsets(4, 4, 0, 0)
	---@diagnostic disable-next-line: missing-fields
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	f:SetBackdropColor(0, 0, 0, 1)
	f:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	f:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	f:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	f:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	f:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	f:SetText(text)
	f:SetCursorPosition(0)

	return f
end

function TRB.Functions.OptionsUi:EditBoxSetTextMinMax(box, value)
	local min, max = box:GetMinMaxValues()
	if value > max then
		value = max
	elseif value < min then
		value = min
	end
	box.EditBox:SetText(value)
	return value
end

function TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, a, callback)
	ColorPickerFrame:SetupColorPickerAndShow({
		swatchFunc = callback,
		opacityFunc = callback,
		cancelFunc = callback,--cancelCallback,
		r = r,
		g = g,
		b = b,
		opacity = 1-a,
		hasOpacity = (a ~= nil)
	})
end

function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
	local r, g, b, a
	if color then
		r = color.r
		g = color.g
		b = color.b
		a = color.a
	else
		r, g, b = ColorPickerFrame:GetColorRGB()
		a = ColorPickerFrame:GetColorAlpha()
	end
	return r, g, b, a
end

function TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, colorControlsTable, key, frameType, frame, classId, specId)
	if button == "LeftButton" then
		-- Handle both table format { color = "FFRRGGBB" } and direct string format "FFRRGGBB"
		local colorValue = colorTable[key]
		local isNestedTable = type(colorValue) == "table" and colorValue.color ~= nil
		local colorString = isNestedTable and colorValue.color or colorValue
		
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
		TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
			local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
			colorControlsTable[key].Texture:SetColorTexture(r_1, g_1, b_1, a_1)
			local newColorString = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
			
			-- Update the color in the appropriate format
			if isNestedTable then
				colorTable[key].color = newColorString
			else
				colorTable[key] = newColorString
			end
		
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				if frame ~= nil then
					if frameType == "backdrop" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropColor(f, nil, r_1, g_1, b_1, a_1)
							end
						else
							TRB.Functions.Color:SetBackdropColor(frame, nil, r_1, g_1, b_1, a_1)
						end
					elseif frameType == "border" then
						-- Handle both single frame and array of frames
						if type(frame) == "table" and frame[1] ~= nil then
							for _, f in ipairs(frame) do
								TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(f, nil, newColorString)
							end
						else
							TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(frame, nil, newColorString)
						end
					elseif frameType == "bar" then
						TRB.Functions.Color:SetStatusBarColorFromRGBAString(frame, nil, newColorString)
					elseif frameType == "threshold" then
						TRB.Functions.Color:SetThresholdColor(frame, newColorString, true, classId, specId)
					end			
				elseif frameType == "health" then
					TRB.Functions.Character:UpdateHealthValues()
				end

				-- Clear color caches and trigger resource bar update to apply correct spec colors
				TRB.Data.cache.colors.backdrop = {}
				TRB.Data.cache.colors.border = {}
				TRB.Data.cache.colors.bar = {}
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end)
	end
end

---Gets the primary bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi:GetPrimaryBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			return primaryNode:GetContainerFrame()
		end
	end
	return nil
end

---Gets all secondary bar container frames (combo points, etc.) for use in color picker callbacks
---@return table<number, Frame>
function TRB.Functions.OptionsUi:GetSecondaryBackdropFrames()
	local frames = {}
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.secondary then
		local nodeCount = barGroups.secondary:GetNodeCount()
		for i = 1, nodeCount do
			local node = barGroups.secondary:GetNode(i)
			if node then
				local containerFrame = node:GetContainerFrame()
				if containerFrame then
					table.insert(frames, containerFrame)
				end
			end
		end
	end
	return frames
end

---Gets the health bar's container frame for use in color picker callbacks
---@return Frame|nil
function TRB.Functions.OptionsUi:GetHealthBackdropFrame()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups and barGroups.health then
		local healthNode = barGroups.health:GetNode(1)
		if healthNode then
			return healthNode:GetContainerFrame()
		end
	end
	return nil
end

function TRB.Functions.OptionsUi:BuildColorPicker(parent, description, settingsEntry, sizeTotal, sizeFrame, posX, posY)
	local f = CreateFrame("Button", nil, parent, "BackdropTemplate")
	f:SetSize(sizeFrame, sizeFrame)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, 
		tileSize=4, 
		edgeSize=12
	})
	---@diagnostic disable-next-line: inject-field
	f.Texture = f:CreateTexture(nil)
	f.Texture:ClearAllPoints()
	f.Texture:SetPoint("TOPLEFT", 4, -4)
	f.Texture:SetPoint("BOTTOMRIGHT", -4, 4)
	f.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(settingsEntry, true))
	f:EnableMouse(true)
	---@diagnostic disable-next-line: inject-field
	f.Font = f:CreateFontString(nil)
	f.Font:SetPoint("LEFT", f, "RIGHT", 10, 0)
	f.Font:SetFontObject(GameFontHighlight)
	f.Font:SetText(description)
	---@diagnostic disable-next-line: redundant-parameter
	f.Font:SetWordWrap(true)
	f.Font:SetJustifyH("LEFT")
	f.Font:SetSize(sizeTotal - sizeFrame - 25, sizeFrame)
	return f
end

---Builds standard TRB color picker with an optional enable/disable checkbox
---@param parent frame
---@param controls table
---@param controlType string
---@param colorTable table
---@param namePrefix string
---@param value TRB.Classes.OptionsUi.Color
---@param yCoord number
---@return number
---@return table|BackdropTemplate|Button
---@return CheckButton
function TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, controlType, colorTable, namePrefix, value)
	local fCheckbox = nil
	local fColor = nil

	controls.colors[controlType] = controls.colors[controlType] or {}

	yCoord = yCoord - 30
	if value.hasEnabledCheckbox == true then
		fCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_threshold" .. value.name, parent, "ChatConfigCheckButtonTemplate")
		controls.checkBoxes["threshold" .. value.name] = fCheckbox
		fCheckbox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(fCheckbox:GetName() .. 'Text'):SetText(value.enabledCheckboxLocalization)
		fCheckbox.tooltip = value.enabledCheckboxTooltipLocalization
		fCheckbox:SetChecked(colorTable[value.name].enabled)
		fCheckbox:SetScript("OnClick", function(self, ...)
			colorTable[value.name].enabled = self:GetChecked()
		end)
	end

	controls.colors.threshold[value.name] = TRB.Functions.OptionsUi:BuildColorPicker(parent, value.colorLocalization, colorTable[value.name].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	fColor = controls.colors.threshold[value.name]

	if value.colorScript ~= nil and type(value.colorScript) == "function" then
		fColor:SetScript("OnMouseDown", value.colorScript(self, button))
	else
		fColor:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorTable, controls.colors[controlType], value.name)
		end)
	end
	
	return yCoord, fColor, fCheckbox
end

function TRB.Functions.OptionsUi:BuildSectionHeader(parent, title, posX, posY)
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(500)
	f:SetHeight(30)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormalLarge)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 14)
	f.font:SetJustifyH("LEFT")
	f.font:SetSize(500, 30)
	f.font:SetText(title)
	return f
end

function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(parent, var, desc, posX, posY, offset, width, height, height2, justifyH, fontFile)
	height = height or 30
	height2 = height2 or (height * 3)
	justifyH = justifyH or "LEFT"
	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil)
	f.font:SetFontObject(GameFontNormal)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetSize(0, 20)
	f.font:SetJustifyH("RIGHT")
	f.font:SetJustifyV("TOP")
	f.font:SetSize(offset, height)
	f.font:SetText(var)

---@diagnostic disable-next-line: inject-field
	f.description = CreateFrame("Frame", nil, parent)
	local fd = f.description
	fd:ClearAllPoints()
	fd:SetPoint("TOPLEFT", parent)
	fd:SetPoint("TOPLEFT", posX+10, posY-height)
	fd:SetWidth(width-5)
	fd:SetHeight(height2)
	---@diagnostic disable-next-line: inject-field
	fd.font = fd:CreateFontString(nil)
	fd.font:SetFontObject(GameFontHighlight)
	
	if fontFile ~= nil then
		fd.font:SetFont(fontFile, 12)
	end

	fd.font:SetPoint("LEFT", fd, "LEFT")
	fd.font:SetSize(0, 16)
	fd.font:SetJustifyH(justifyH)
	fd.font:SetJustifyV("TOP")
	fd.font:SetSize(width, height2)
	fd.font:SetText(desc)
---@diagnostic disable-next-line: redundant-parameter
	fd.font:SetWordWrap(true)

	return f
end

function TRB.Functions.OptionsUi:BuildButton(parent, text, posX, posY, width, height)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	f:SetText(text)
---@diagnostic disable-next-line: param-type-mismatch
	f:SetNormalFontObject("GameFontNormal")
	---@diagnostic disable-next-line: inject-field
	f.ntex = f:CreateTexture()
	f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.ntex:SetAllPoints()
	f:SetNormalTexture(f.ntex)
	---@diagnostic disable-next-line: inject-field
	f.htex = f:CreateTexture()
	f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.htex:SetAllPoints()
	f:SetHighlightTexture(f.htex)
	---@diagnostic disable-next-line: inject-field
	f.ptex = f:CreateTexture()
	f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	---@diagnostic disable-next-line: missing-parameter
	f.ptex:SetAllPoints()
	f:SetPushedTexture(f.ptex)

	return f
end

---Builds an export button anchored to the top-right corner of its parent panel.
---Used for "Export Bar Display", "Export Thresholds", "Export Bar Text", etc.
---@param parent Frame The parent panel
---@param text string Button label text
---@param yCoord number Vertical offset from parent's top
---@param height? number Button height (default 25)
---@return Button
function TRB.Functions.OptionsUi:BuildExportButton(parent, text, yCoord, height)
	height = height or 25
	local f = TRB.Functions.OptionsUi:BuildButton(parent, text, 0, 0, 225, height)
	f:ClearAllPoints()
	f:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, yCoord)
	return f
end

---Builds the spec title row: header + enabled checkbox + import button + export button,
---all anchored from the right side of the parent so they stay right-aligned on resize.
---@param parent Frame The spec display panel
---@param controls table The controls table for this spec
---@param specLabel string Localized spec name (e.g. L["PriestDisciplineFull"])
---@param enabledSettingRef table Reference table where .enabled lives (e.g. TRB.Data.settings.core.enabled.priest)
---@param enabledKey string Key into enabledSettingRef (e.g. "discipline")
---@param checkboxName string Global checkbox frame name (e.g. "TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled")
---@param checkboxControlKey string Key in controls.checkBoxes (e.g. "disciplinePriestEnabled")
---@param exportControlKey string Key in controls.buttons for the export button (e.g. "exportButton_Priest_Discipline_All")
---@param exportCallback function OnClick handler for export button
---@return number yCoord The updated yCoord after the title row
function TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, specLabel, enabledSettingRef, enabledKey, checkboxName, checkboxControlKey, exportControlKey, exportCallback)
	local yCoord = 0

	-- Section header (left-aligned)
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, specLabel, oUi.xCoord, yCoord - 5)

	-- Export button (rightmost, anchored to parent's top-right)
	controls.buttons[exportControlKey] = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 0, 0, 150, 20)
	local exportBtn = controls.buttons[exportControlKey]
	exportBtn:ClearAllPoints()
	exportBtn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, yCoord - 10)
	exportBtn:SetScript("OnClick", exportCallback)

	-- Import button (anchored to left of export)
	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 0, 0, 90, 20)
	local importBtn = controls.buttons.importButton
	importBtn:ClearAllPoints()
	importBtn:SetPoint("RIGHT", exportBtn, "LEFT", -5, 0)
	importBtn:SetFrameLevel(10000)
	importBtn:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	-- Enabled checkbox (anchored to left of import, with gap for label text)
	controls.checkBoxes[checkboxControlKey] = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
	local cb = controls.checkBoxes[checkboxControlKey]
	getglobal(cb:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	cb.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], specLabel)
	cb:SetChecked(enabledSettingRef[enabledKey])
	cb:SetScript("OnClick", function(self, ...)
		enabledSettingRef[enabledKey] = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)
	end)
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(cb, enabledSettingRef[enabledKey], true)

	-- Position checkbox: anchor its right edge left of import, leaving room for the label text
	-- ChatConfigCheckButtonTemplate renders text to the RIGHT of the frame, so we offset enough for it
	cb:SetPoint("RIGHT", importBtn, "LEFT", -75, 0)

	return yCoord - 37
end

---Builds a Label object for the Options UI
---@param parent frame
---@param text string
---@param posX number
---@param posY number
---@param width number
---@param height number
---@param fontObject Font?
---@param hAlign string?
---@return table|Frame
function TRB.Functions.OptionsUi:BuildLabel(parent, text, posX, posY, width, height, fontObject, hAlign)
	if fontObject == nil then
		fontObject = GameFontNormal
	end

	if hAlign == nil or (string.upper(hAlign) ~= "LEFT" and string.upper(hAlign) ~= "CENTER" and string.upper(hAlign) ~= "RIGHT") then
		hAlign = "LEFT"
	end

	local f = CreateFrame("Frame", nil, parent)
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", parent)
	f:SetPoint("TOPLEFT", posX, posY)
	f:SetWidth(width)
	f:SetHeight(height)
	---@diagnostic disable-next-line: inject-field
	f.font = f:CreateFontString(nil, "BACKGROUND")
	f.font:SetFontObject(fontObject)
	f.font:SetPoint("LEFT", f, "LEFT")
	f.font:SetJustifyH(hAlign)
	f.font:SetSize(width, height)
	f.font:SetText(text)

	return f
end

function TRB.Functions.OptionsUi:CreateScrollFrameContainer(name, parent, width, height, scrollChild)
	width = width or 560
	height = height or 540
	local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	sf:SetWidth(width)
	sf:SetHeight(height)
	if scrollChild then
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = scrollChild
	else
		---@diagnostic disable-next-line: inject-field
		sf.scrollChild = CreateFrame("Frame")
	end
	sf.scrollChild:SetWidth(width)
	sf.scrollChild:SetHeight(height-10)
	sf:SetScrollChild(sf.scrollChild)
	return sf
end

function TRB.Functions.OptionsUi:CreateTabFrameContainer(name, parent, width, height, isManualScrollFrame)
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

	if not isManualScrollFrame then
		---@diagnostic disable-next-line: inject-field
		cf.scrollFrame = TRB.Functions.OptionsUi:CreateScrollFrameContainer(name .. "ScrollFrame", cf, width - 30, height - 8)
		cf.scrollFrame:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -5)
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

function TRB.Functions.OptionsUi:SwitchTab(self, tabId)
	local parent = self:GetParent()
	if parent.lastTab then
		parent.lastTab:Hide()
		local lastTab = parent.tabs[parent.lastTabId]
		lastTab.Text:SetFontObject(TRB.Options.fonts.options.tabNormalSmall)
		lastTab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
		lastTab.bottomCover:SetColorTexture(0.1, 0.1, 0.1, 0.8)
	end
	parent.tabsheets[tabId]:Show()
	local activeTab = parent.tabs[tabId]
	activeTab.Text:SetFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	activeTab:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	activeTab.bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
	parent.lastTab = parent.tabsheets[tabId]
	parent.lastTabId = tabId

	-- Show/hide the Bar Text Variables flyout based on active tab
	if tabId == "barText" then
		-- Swap to the correct spec's variables panel via the tabsheet's scrollChild
		local barTextSheet = parent.tabsheets and parent.tabsheets["barText"]
		local scrollChild = barTextSheet and barTextSheet.scrollFrame and barTextSheet.scrollFrame.scrollChild
		if scrollChild and scrollChild.barTextVariablesPanel then
			-- Hide the previous panel if it's different
			if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel ~= scrollChild.barTextVariablesPanel then
				TRB.Frames.barTextVariablesPanel:Hide()
			end
			TRB.Frames.barTextVariablesPanel = scrollChild.barTextVariablesPanel
		end
		if TRB.Frames.barTextVariablesPanel then
			TRB.Frames.barTextVariablesPanel:Show()
			if TRB.Frames.barTextVariablesPanel.variablesTable then
				TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
			end
		end
	else
		if TRB.Frames.barTextVariablesPanel then
			TRB.Frames.barTextVariablesPanel:Hide()
		end
		-- Clear active edit box tracking when leaving the Bar Text tab
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
	end
end

function TRB.Functions.OptionsUi:CreateTab(name, displayText, id, parent, width)
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
		TRB.Functions.OptionsUi:SwitchTab(self, self.id)
	end)

	return tab
end

---Switches to a specific tab by key for a given class/spec's options panel.
---@param classId integer
---@param specId integer
---@param tabKey string The tab key to switch to (e.g., "barText", "barDisplay")
function TRB.Functions.OptionsUi:SwitchToTabByClassSpec(classId, specId, tabKey)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local tab = _G["TwintopResourceBar_Options_" .. namePrefix .. "_Tab_" .. tabKey]
	if tab then
		TRB.Functions.OptionsUi:SwitchTab(tab, tab.id)
	end
end

---Switches to the Bar Text tab for a given class/spec. Convenience wrapper around SwitchToTabByClassSpec.
---@param classId integer
---@param specId integer
function TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	TRB.Functions.OptionsUi:SwitchToTabByClassSpec(classId, specId, "barText")
end

---Standard tab key constants used across all options panels.
TRB.Functions.OptionsUi.TabKeys = {
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

---Builds a dynamic set of tabs and tabsheets for an options panel.
---Tabs automatically wrap to multiple rows when they would exceed the parent frame's width.
---@param parent Frame The parent frame to attach tabs to (e.g., the spec display panel)
---@param namePrefix string The naming prefix (e.g., "Priest_Shadow")
---@param tabDefinitions table[] Ordered list of tab definitions: { [1]=key:string, [2]=label:string, [3]=width:number, [4]=constructor:function(scrollChild) }
---@param yCoord number The starting y coordinate for the tabs row. Will be adjusted internally.
---@return number yCoord The adjusted yCoord after tabs are placed (for further content below if needed)
function TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
	local optionsUiFuncs = TRB.Functions.OptionsUi

	-- Normalize: support both positional { key, label, width, constructor } and named { key=, label=, width=, constructor= }
	for i, def in ipairs(tabDefinitions) do
		if def[1] == nil and def.key ~= nil then
			def[1] = def.key
			def[2] = def.label
			def[3] = def.width
			def[4] = def.constructor
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

	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		tabsheets[key] = optionsUiFuncs:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel_" .. key, parent)
		tabsheets[key]:Hide()
		tabsheets[key]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	end

	-- Show the first tab by default
	local firstKey = tabOrder[1]
	tabsheets[firstKey]:Show()
	---@diagnostic disable-next-line: inject-field
	tabsheets[firstKey].selected = true
	tabs[firstKey].Text:SetFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	tabs[firstKey]:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
	tabs[firstKey].bottomCover:SetColorTexture(0.5, 0.5, 0.5, 1.0)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[firstKey]
	parent.lastTabId = firstKey
	parent.tabOrder = tabOrder

	-- Call each tab's constructor to populate its content
	for _, def in ipairs(tabDefinitions) do
		local key = def[1]
		local constructor = def[4]
		if constructor then
			constructor(tabsheets[key].scrollFrame.scrollChild)
		end
	end

	return yCoord
end

function TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, name, cache, classId, specId)
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

	-- Store reference so SwitchTab and nav selection can show/hide it
	TRB.Frames.barTextVariablesPanel = cf
	-- Also register in the per-spec lookup table so we can swap panels on spec switch
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
					-- Section header click — do nothing
					scrollingTable:ClearSelection()
					return true
				end

				if column == 1 then
					-- "Add" button column clicked — insert variable at cursor
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
					-- Normal click — show description and select the row
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

---Attaches undo/redo support (Ctrl+Z / Ctrl+Y) to an EditBox.
---Text snapshots are recorded on a debounced timer so rapid typing collapses into
---a single history entry.  The public helpers `editBox:ResetUndoHistory()` and
---`editBox:ResetUndoHistory(initialText)` are added for external use (e.g. when
---the user switches to a different bar-text entry).
local UNDO_MAX_HISTORY = 50
local UNDO_DEBOUNCE_SEC = 0.4

local function AttachUndoRedo(editBox)
	-- Private state stored directly on the frame
	editBox._undoHistory  = { editBox:GetText() or "" }
	editBox._undoCursors  = { 0 }
	editBox._undoIndex    = 1
	editBox._undoSuppress = false  -- flag: true while we are programmatically setting text
	editBox._undoTimer    = nil

	--- Reset the undo stack (call when loading a different entry).
	---@param initialText? string  If given, seeds the stack with this text.
	function editBox:ResetUndoHistory(initialText)
		if self._undoTimer then self._undoTimer:Cancel(); self._undoTimer = nil end
		local t = initialText or self:GetText() or ""
		self._undoHistory  = { t }
		self._undoCursors  = { self:GetCursorPosition() or 0 }
		self._undoIndex    = 1
	end

	-- Helper: push current text onto the stack (trimming any future entries).
	local function PushState(self)
		local text   = self:GetText()
		local cursor = self:GetCursorPosition() or 0
		-- Don't push if identical to the current entry
		if self._undoHistory[self._undoIndex] == text then return end
		-- Trim any redo entries beyond the current index
		for i = #self._undoHistory, self._undoIndex + 1, -1 do
			table.remove(self._undoHistory, i)
			table.remove(self._undoCursors, i)
		end
		-- Push
		table.insert(self._undoHistory, text)
		table.insert(self._undoCursors, cursor)
		-- Cap size
		if #self._undoHistory > UNDO_MAX_HISTORY then
			table.remove(self._undoHistory, 1)
			table.remove(self._undoCursors, 1)
		end
		self._undoIndex = #self._undoHistory
	end

	-- Record text changes (debounced, user-input only)
	editBox:HookScript("OnTextChanged", function(self, userInput)
		if self._undoSuppress or not userInput then return end
		if self._undoTimer then self._undoTimer:Cancel() end
		self._undoTimer = C_Timer.NewTimer(UNDO_DEBOUNCE_SEC, function()
			self._undoTimer = nil
			PushState(self)
		end)
	end)

	-- Intercept Ctrl+Z (undo), Ctrl+Y / Ctrl+Shift+Z (redo)
	editBox:SetScript("OnKeyDown", function(self, key)
		local handled = false
		if IsControlKeyDown() then
			local isRedo = (key == "Y") or (key == "Z" and IsShiftKeyDown())
			if key == "Z" and not IsShiftKeyDown() then
				handled = true
				-- Flush any pending debounce so the current state is saved first
				if self._undoTimer then
					self._undoTimer:Cancel()
					self._undoTimer = nil
					PushState(self)
				end
				if self._undoIndex > 1 then
					self._undoIndex = self._undoIndex - 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			elseif isRedo then
				handled = true
				if self._undoIndex < #self._undoHistory then
					self._undoIndex = self._undoIndex + 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			end
		end
		-- Prevent keystrokes from leaking to game keybinds.
		-- Must be called AFTER all processing (WoW requirement).
		self:SetPropagateKeyboardInput(false)
	end)
end

function TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, name, text, width, height, xPos, yPos)
	local s = CreateFrame("ScrollFrame", "TRB_" .. name .. "_BarTextBox", parent, "UIPanelScrollFrameTemplate, BackdropTemplate") -- or your actual parent instead
	s:SetSize(width, height)
	s:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, yPos)
	
---@diagnostic disable-next-line: inject-field
	s.ScrollFrame = CreateFrame("EditBox", nil, s, "BackdropTemplate")
	local e = s.ScrollFrame
	e:SetTextInsets(4, 4, 0, 0)
	s:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	s:SetBackdropColor(0, 0, 0, 1)
	s:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	e:SetScript("OnEnter", function(self)
		self:GetParent():SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	e:SetScript("OnLeave", function(self)
		self:GetParent():SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	e:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	e:SetCursorPosition(0)
	e:SetScript("OnCursorChanged", function(self, arg1, arg2, arg3, arg4)
		local vs = self:GetParent():GetVerticalScroll()
		local h  = self:GetParent():GetHeight()
	
		if vs+arg2 > 0 or 0 > vs+arg2-arg4+h then
			self:GetParent():SetVerticalScroll(arg2*-1)
		end
	end)

	e:SetMultiLine(true)
	e:SetFontObject(ChatFontNormal)
	e:SetWidth(width)
	e:SetText(text)
	e:SetAutoFocus(false)

	-- Track this EditBox as the active bar text editor when it gains focus.
	-- We remember both the EditBox and cursor position so the side panel
	-- "Add" button can insert variables at the right place even after focus
	-- moves away.
	e:HookScript("OnEditFocusGained", function(self)
		TRB.Frames.activeBarTextEditBox = self
	end)
	e:HookScript("OnEditFocusLost", function(self)
		TRB.Frames.activeBarTextCursorPosition = self:GetCursorPosition()
	end)

	-- Clicking anywhere in the scroll frame (not just on text) gives focus to the EditBox
	s:EnableMouse(true)
	s:SetScript("OnMouseDown", function(self)
		e:SetFocus()
	end)

	-- Keep EditBox width in sync if the ScrollFrame resizes
	s:HookScript("OnSizeChanged", function(self, w, h)
		e:SetWidth(w)
	end)

	s:SetScrollChild(e)
	return e
end

function TRB.Functions.OptionsUi:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText, setSelectedFunc)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	
	local lsmPairs
	local lsmPairsByName

	if lsmType == "statusbar" then
		FillStatusbarCache()
		lsmPairs = statusbarPairs
		lsmPairsByName = statusbarPairs
	elseif lsmType == "background" then
		FillBackgroundCache()
		lsmPairs = backgroundPairs
		lsmPairsByName = backgroundPairs
	elseif lsmType == "border" then
		FillBorderCache()
		lsmPairs = borderPairs
		lsmPairsByName = borderPairs
	end

	dropDowns[varName] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. varName .. "_" .. lsmType, parent, "WowStyle1DropdownTemplate")
	dropDowns[varName]:SetWidth(oUi.sliderWidth)
	dropDowns[varName].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
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
	dropDowns[varName]:SetPoint("TOPLEFT", xCoord, yCoord-30)
end

function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(checkbox, enable)
	if enable then
		checkbox:Enable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 1, 1)
	else
		checkbox:Disable()
		getglobal(checkbox:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
	end
end

function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(checkbox, enable, changeText)
	if enable then
		getglobal(checkbox:GetName().."Text"):SetTextColor(0, 1, 0)

		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Enabled"])
		end
	else
		getglobal(checkbox:GetName().."Text"):SetTextColor(1, 0, 0)
		
		if changeText == true then
			getglobal(checkbox:GetName().."Text"):SetText(L["Disabled"])
		end
	end
end

local function AdjustBarBorder()
	local specCacheEntry = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	if TRB.Frames.barGroups ~= nil then
		TRB.Functions.Bar:ApplyBarGroupsLayout(specCacheEntry, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(specCacheEntry, TRB.Frames.barGroups)
	end
end

function TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil	
	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	controls.barPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarPositionSize"], oUi.xCoord, yCoord)

	-- Show Edit Mode informational notice
	yCoord = yCoord - 30
	controls.editModeNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.editModeNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.editModeNotice:SetWidth(550)
	controls.editModeNotice:SetJustifyH("LEFT")
	controls.editModeNotice:SetText("|cFFCCCCCC" .. L["EditModePositionOverrideNotice"] .. "|r")

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalBarDimensions = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_barDimensions", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalBarDimensions
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDimensions"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].bar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].bar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("bar")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllBarDimensions", "bar", yCoord)
	end

	yCoord = yCoord - 40
	title = L["BarWidth"]
	controls.width = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.width = value

		local maxBorderSize = math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1
		local borderSize = math.min(maxBorderSize, spec.bar.border)
		controls.borderWidth:SetValue(borderSize)
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end
	end)

	title = L["BarHeight"]
	controls.height = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.height = value

		local maxBorderSize = math.max(math.min(math.floor((spec.bar.height) / TRB.Data.constants.borderWidthFactor), math.floor((spec.bar.width) / TRB.Data.constants.borderWidthFactor))-1, 0)
		local borderSize = math.min(maxBorderSize, spec.bar.border)

		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))
		controls.borderWidth.EditBox:SetText(tostring(borderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end

			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end
	end)

	title = L["BarHorizontalPosition"]
	yCoord = yCoord - 60
	controls.horizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.bar.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.xPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = L["BarVerticalPosition"]
	controls.vertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.bar.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.yPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = L["BarBorderWidth"]
	yCoord = yCoord - 60
	controls.borderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.border = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			AdjustBarBorder()
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end

		local minsliderWidth = math.max((spec.bar.border)*2+1, 120)
		local minsliderHeight = math.max((spec.bar.border)*2+1, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
		controls.height.MinLabel:SetText(tostring(minsliderHeight))
		controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
		controls.width.MinLabel:SetText(tostring(minsliderWidth))
	end)

	controls.dragAndDropMessage = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	controls.dragAndDropMessage:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	controls.dragAndDropMessage:SetWidth(oUi.maxOptionsWidth - oUi.xCoord2 - oUi.xPadding2)
	controls.dragAndDropMessage:SetJustifyH("LEFT")
	controls.dragAndDropMessage:SetText(L["DragAndDropEditModeMessage"])

	yCoord = yCoord - 30

	return yCoord
end

---Configuration for ancillary bar dimension options
---@class TRB.Classes.OptionsUi.AncillaryBarConfig
---@field settingKey string The key in spec settings (e.g., "comboPoints", "healthBar", "manaBar")
---@field displayName string The localized display name for the bar
---@field primaryResourceString string? The primary resource name (for "relative to" label)
---@field globalSettingKey string? The key in global settings (nil if no global checkbox)
---@field globalTooltip string? Localized string for global checkbox tooltip
---@field sectionHeader string? Localized string for section header (defaults to SecondaryPositionAndSize formatted)
---@field includeSpacing boolean? Whether to include spacing slider (default false)
---@field widthDivisor number? Divisor for max width slider (default 1, use 6 for combo points)
---@field useSmallerSanityChecks boolean? Use comboPointsMaxHeight/Width instead of barMaxHeight/Width (default false)

---Generates dimension options for an ancillary bar (combo points, health bar, mana bar, etc.)
---@param parent Frame
---@param controls table
---@param spec table
---@param classId number?
---@param specId number?
---@param yCoord number
---@param config TRB.Classes.OptionsUi.AncillaryBarConfig
---@return number yCoord
function TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, config)
	local settingKey = config.settingKey
	local displayName = config.displayName
	local primaryResourceString = config.primaryResourceString or L["Resource"]
	local globalSettingKey = config.globalSettingKey
	local globalTooltip = config.globalTooltip
	local sectionHeader = config.sectionHeader or string.format(L["SecondaryPositionAndSize"], displayName)
	local includeSpacing = config.includeSpacing or false
	local widthDivisor = config.widthDivisor or 1
	local useSmallerSanityChecks = config.useSmallerSanityChecks or false

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	-- Section header
	controls[settingKey .. "PositionSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeader, oUi.xCoord, yCoord)

	-- Global checkbox (if applicable)
	if globalSettingKey and classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes["useGlobal" .. settingKey:gsub("^%l", string.upper)] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes["useGlobal" .. settingKey:gsub("^%l", string.upper)]
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = globalTooltip or L["CheckboxUseGlobalTooltip_ComboPoints"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName][globalSettingKey])
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName][globalSettingKey] = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(globalSettingKey)
		end)
	elseif globalSettingKey and classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKey:gsub("^%l", string.upper), globalSettingKey, yCoord)
	end

	-- Width and Height sliders
	local maxWidthValue = TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / widthDivisor, 0, "floor")
	local maxHeightValue = sanityCheckValues.barMaxHeight

	yCoord = yCoord - 40
	title = string.format(L["SecondaryWidth"], displayName)
	controls[settingKey .. "Width"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, maxWidthValue, spec[settingKey].width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].width = value

		local effectiveWidth = spec[settingKey].fullWidth and spec.bar.width or spec[settingKey].width
		local maxBorderSize = math.max(math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor)) - 1, 0)
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetValue(borderSize)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = string.format(L["SecondaryHeight"], displayName)
	controls[settingKey .. "Height"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, maxHeightValue, spec[settingKey].height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].height = value

		local effectiveWidth = spec[settingKey].fullWidth and spec.bar.width or spec[settingKey].width
		local maxBorderSize = math.max(math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor)) - 1, 0)
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))
		controls[settingKey .. "BorderWidth"].EditBox:SetText(tostring(borderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Horizontal and Vertical position sliders
	title = string.format(L["SecondaryHorizontalPosition"], displayName)
	yCoord = yCoord - 60
	controls[settingKey .. "Horizontal"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec[settingKey].xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Horizontal"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].xPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = string.format(L["SecondaryVerticalPosition"], displayName)
	controls[settingKey .. "Vertical"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec[settingKey].yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Vertical"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].yPos = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Border width slider
	title = string.format(L["SecondaryBorderWidth"], displayName)
	yCoord = yCoord - 60
	controls[settingKey .. "BorderWidth"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec[settingKey].border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "BorderWidth"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].border = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end

		local effectiveWidth = spec[settingKey].fullWidth and spec.bar.width or spec[settingKey].width
		local minsliderWidth = math.max(spec[settingKey].border*2, 1)
		local minsliderHeight = math.max(spec[settingKey].border*2, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		local scMaxHeight = useSmallerSanityChecks and scValues.comboPointsMaxHeight or scValues.barMaxHeight
		local scMaxWidth = useSmallerSanityChecks and scValues.comboPointsMaxWidth or scValues.barMaxWidth
		controls[settingKey .. "Height"]:SetMinMaxValues(minsliderHeight, scMaxHeight)
		controls[settingKey .. "Height"].MinLabel:SetText(tostring(minsliderHeight))
		if not spec[settingKey].fullWidth then
			controls[settingKey .. "Width"]:SetMinMaxValues(minsliderWidth, scMaxWidth)
			controls[settingKey .. "Width"].MinLabel:SetText(tostring(minsliderWidth))
		end
	end)

	-- Spacing slider (if applicable)
	if includeSpacing then
		title = string.format(L["SecondarySpacing"], displayName)
		controls.comboPointSpacing = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.comboPoints.spacing = value

			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	-- Relative To dropdown
	yCoord = yCoord - 40

	local barRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "RelativeTo", parent, "WowStyle1DropdownTemplate")
	barRelativeTo:SetWidth(oUi.sliderWidth)
	barRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["SecondaryRelativeTo"], displayName, primaryResourceString), oUi.xCoord, yCoord)
	barRelativeTo.label.font:SetFontObject(GameFontNormal)
	
	local relativeTo = {}
	relativeTo[L["PositionAboveLeft"]] = "TOPLEFT"
	relativeTo[L["PositionAboveMiddle"]] = "TOP"
	relativeTo[L["PositionAboveRight"]] = "TOPRIGHT"
	relativeTo[L["PositionBelowLeft"]] = "BOTTOMLEFT"
	relativeTo[L["PositionBelowMiddle"]] = "BOTTOM"
	relativeTo[L["PositionBelowRight"]] = "BOTTOMRIGHT"
	local relativeToList = {
		L["PositionAboveLeft"],
		L["PositionAboveMiddle"],
		L["PositionAboveRight"],
		L["PositionBelowLeft"],
		L["PositionBelowMiddle"],
		L["PositionBelowRight"]
	}

	local function RelativeToIsSelected(value)
		return value == spec[settingKey].relativeTo
	end
	
	local function RelativeToSetSelected(newValue)
		spec[settingKey].relativeTo = newValue
		
		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec[settingKey].relativeToName = k
			end
		end
		barRelativeTo:SetDefaultText(spec[settingKey].relativeToName)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barRelativeTo:SetupMenu(RelativeToGenerator)
	barRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	
	-- Full Width checkbox
	controls.checkBoxes[settingKey .. "FullWidth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_" .. settingKey .. "FullWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[settingKey .. "FullWidth"]
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["SecondaryFullBarWidth"], displayName))
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format(L["SecondaryFullBarWidthTooltip"], displayName, displayName, displayName)
	f:SetChecked(spec[settingKey].fullWidth)
	f:SetScript("OnClick", function(self, ...)
		spec[settingKey].fullWidth = self:GetChecked()
		
		-- Update border max based on new effective width
		local effectiveWidth = spec[settingKey].fullWidth and spec.bar.width or spec[settingKey].width
		local maxBorderSize = math.max(math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor)) - 1, 0)
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetValue(borderSize)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	return yCoord
end

--- Legacy wrapper for combo point dimension options
function TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString, includeSpacing)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceEnergy"]
	end
	
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	if includeSpacing == nil then
		includeSpacing = true
	end

	return TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
		settingKey = "comboPoints",
		displayName = secondaryResourceString,
		primaryResourceString = primaryResourceString,
		globalSettingKey = "comboPoints",
		globalTooltip = L["CheckboxUseGlobalTooltip_ComboPoints"],
		includeSpacing = includeSpacing,
		widthDivisor = 6,
		useSmallerSanityChecks = true
	})
end

--- Legacy wrapper for health bar dimension options
function TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceMana"]
	end

	return TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
		settingKey = "healthBar",
		displayName = L["HealthBar"],
		primaryResourceString = primaryResourceString,
		globalSettingKey = "healthBar",
		globalTooltip = L["CheckboxUseGlobalTooltip_HealthBar"],
		sectionHeader = L["HealthBarPositionAndSize"],
		includeSpacing = false,
		widthDivisor = 1,
		useSmallerSanityChecks = false
	})
end

--[[
	Custom Bar Options UI Functions
	These functions work with bars stored under settings.bars.<key>, settings.colors.bars.<key>,
	and settings.textures.bars.<key> using the BarTypeDefinition system.
]]

---Generates dimension options for a custom bar
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param primaryResourceString string # Primary resource name for "relative to" label
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, primaryResourceString)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil
	
	-- Get the bar settings from the nested structure
	local barSettings = barTypeDef:GetSettings(spec)
	if not barSettings then
		return yCoord
	end
	
	local displayName = barTypeDef.displayName

	-- Section header
	local headerText = string.format(L["SecondaryPositionAndSize"], displayName)
	controls[barTypeDef.key .. "DimensionsSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)
	
	-- Width slider
	yCoord = yCoord - 40
	local widthMin = barTypeDef.isMultiNode and 10 or 30
	local widthMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	local widthDivisor = barTypeDef.isMultiNode and 6 or 1
	
	controls[barTypeDef.key .. "Width"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryWidth"], displayName),
		widthMin, math.ceil(widthMax / widthDivisor), barSettings.width, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.width = value
		
		local effectiveWidth = barSettings.fullWidth and spec.bar.width or barSettings.width
		local effectiveHeight = barSettings.fullWidth and spec.bar.height or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)
	
	-- Height slider
	controls[barTypeDef.key .. "Height"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryHeight"], displayName), 
		1, (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100, barSettings.height, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.height = value
		
		local effectiveWidth = barSettings.fullWidth and spec.bar.width or barSettings.width
		local effectiveHeight = barSettings.fullWidth and spec.bar.height or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))
		controls[barTypeDef.key .. "Border"].EditBox:SetText(tostring(borderSize))
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)
	
	-- X Position slider
	yCoord = yCoord - 60
	local xPosMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	controls[barTypeDef.key .. "XPos"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryHorizontalPosition"], displayName), 
		math.ceil(-xPosMax / 2), math.floor(xPosMax / 2), barSettings.xPos, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "XPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.xPos = value
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)
	
	-- Y Position slider
	local yPosMax = (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100
	controls[barTypeDef.key .. "YPos"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryVerticalPosition"], displayName), 
		math.ceil(-yPosMax / 2), math.floor(yPosMax / 2), barSettings.yPos, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "YPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.yPos = value
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)
	
	-- Border slider
	yCoord = yCoord - 60
	-- When fullWidth is checked, use main bar dimensions for border max (matching Health Bar behavior)
	local effectiveWidthForBorder = barSettings.fullWidth and spec.bar.width or barSettings.width
	local effectiveHeightForBorder = barSettings.fullWidth and spec.bar.height or barSettings.height
	local maxBorderHeight = math.min(math.floor(effectiveHeightForBorder / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidthForBorder / TRB.Data.constants.borderWidthFactor))
	-- Ensure maxBorderHeight is at least as large as the current border value to prevent slider errors
	maxBorderHeight = math.max(maxBorderHeight, barSettings.border)
	controls[barTypeDef.key .. "Border"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryBorderWidth"], displayName), 
		0, maxBorderHeight, barSettings.border, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Border"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.border = value
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
		
		local minSliderWidth = math.max(barSettings.border * 2 + 1, widthMin)
		local minSliderHeight = math.max(barSettings.border * 2 + 1, 1)
		local heightSliderMax = (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100
		
		controls[barTypeDef.key .. "Height"]:SetMinMaxValues(minSliderHeight, heightSliderMax)
		controls[barTypeDef.key .. "Height"].MinLabel:SetText(tostring(minSliderHeight))
		if not barSettings.fullWidth then
			controls[barTypeDef.key .. "Width"]:SetMinMaxValues(minSliderWidth, math.ceil(widthMax / widthDivisor))
			controls[barTypeDef.key .. "Width"].MinLabel:SetText(tostring(minSliderWidth))
		end
	end)
	
	-- Spacing slider (only for multi-node bars)
	if barTypeDef.hasSpacing then
		controls[barTypeDef.key .. "Spacing"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondarySpacing"], displayName), 
			-20, 20, barSettings.spacing, 1, 0,
			oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls[barTypeDef.key .. "Spacing"]:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			barSettings.spacing = value
			
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end
	
	-- Relative To dropdown
	yCoord = yCoord - 60
	local relativeTo = {
		[L["PositionAboveLeft"]] = "TOPLEFT",
		[L["PositionAboveMiddle"]] = "TOP",
		[L["PositionAboveRight"]] = "TOPRIGHT",
		[L["PositionBelowLeft"]] = "BOTTOMLEFT",
		[L["PositionBelowMiddle"]] = "BOTTOM",
		[L["PositionBelowRight"]] = "BOTTOMRIGHT"
	}
	local relativeToList = {
		L["PositionAboveLeft"], L["PositionAboveMiddle"], L["PositionAboveRight"],
		L["PositionBelowLeft"], L["PositionBelowMiddle"], L["PositionBelowRight"]
	}

	controls[barTypeDef.key .. "RelativeTo"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_RelativeTo", parent, "WowStyle1DropdownTemplate")
	local barRelativeTo = controls[barTypeDef.key .. "RelativeTo"]
	barRelativeTo:SetWidth(oUi.dropdownWidth)
	barRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["SecondaryRelativeTo"], displayName, primaryResourceString), oUi.xCoord, yCoord)
	barRelativeTo.label.font:SetFontObject(GameFontNormal)
	barRelativeTo:SetDefaultText(barSettings.relativeToName)

	local function RelativeToIsSelected(value)
		return value == barSettings.relativeTo
	end
	
	local function RelativeToSetSelected(newValue)
		barSettings.relativeTo = newValue
		for k, v in pairs(relativeTo) do
			if v == newValue then
				barSettings.relativeToName = k
			end
		end
		barRelativeTo:SetDefaultText(barSettings.relativeToName)

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for _, displayNameItem in ipairs(relativeToList) do
			rootDescription:CreateRadio(displayNameItem, RelativeToIsSelected, RelativeToSetSelected, relativeTo[displayNameItem])
		end
	end
	barRelativeTo:SetupMenu(RelativeToGenerator)
	barRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	
	-- Full Width checkbox
	controls[barTypeDef.key .. "FullWidth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_FullWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls[barTypeDef.key .. "FullWidth"]
	f:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding, yCoord - 30)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["SecondaryFullBarWidth"], displayName))
	---@diagnostic disable-next-line: inject-field
	f.tooltip = string.format(L["SecondaryFullBarWidthTooltip"], displayName, displayName, displayName)
	f:SetChecked(barSettings.fullWidth)
	f:SetScript("OnClick", function(self, ...)
		barSettings.fullWidth = self:GetChecked()
		
		-- Update border max based on new effective width/height (matching Health Bar behavior)
		local effectiveWidth = barSettings.fullWidth and spec.bar.width or barSettings.width
		local effectiveHeight = barSettings.fullWidth and spec.bar.height or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))
		
		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	return yCoord
end

---Generates color options for a custom bar with simple bar/border/background colors
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil
	
	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end
	
	local displayName = barTypeDef.displayName
	
	-- Section header
	local headerText = string.format(L["CustomBarColorHeader"], displayName)
	controls[barTypeDef.key .. "ColorSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)
	
	yCoord = yCoord - 30
	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]
	
	-- For threshold-based color bars (like Stagger), use the threshold color UI
	if barTypeDef.colorCurveType == "step" or barTypeDef.colorCurveType == "linear" then
		return TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	end

	-- Simple bar/border/background colors
	-- Bar Color
	
	if colorSettings.bar then
		local barColorValue = type(colorSettings.bar) == "table" and colorSettings.bar.color or colorSettings.bar
		colorControls.bar = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), barColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.bar
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", barTypeDef.key)
		end)
		yCoord = yCoord - 30
	end
	
	-- Per-node colors (for multi-node bars like Warrior defensives)
	if barTypeDef.nodeColors and colorSettings.nodeColors then
		colorControls.nodeColors = colorControls.nodeColors or {}
		
		for _, nodeConfig in ipairs(barTypeDef.nodeColors) do
			local nodeKey = nodeConfig.key
			local nodeDisplayName = nodeConfig.displayName
			local nodeColorSettings = colorSettings.nodeColors[nodeKey]
			
			if nodeColorSettings then
				colorControls.nodeColors[nodeKey] = colorControls.nodeColors[nodeKey] or {}
				local nodeControls = colorControls.nodeColors[nodeKey]
				
				if nodeConfig.hasEnabled then
					-- Build checkbox and color picker manually for node with enable option					
					-- Create enable checkbox
					local checkboxName = "TwintopResourceBar_" .. namePrefix .. "_" .. nodeKey .. "_Enabled"
					nodeControls.enabled = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
					local fCheckbox = nodeControls.enabled
					fCheckbox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
					getglobal(fCheckbox:GetName() .. 'Text'):SetText(nodeDisplayName)
					fCheckbox.tooltip = nodeDisplayName
					fCheckbox:SetChecked(nodeColorSettings.enabled)
					fCheckbox:SetScript("OnClick", function(self, ...)
						nodeColorSettings.enabled = self:GetChecked()
					end)
					
					-- Create color picker
					nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeDisplayName, nodeColorSettings.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
					f = nodeControls.color
					f:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[nodeKey], nodeControls, "color", barTypeDef.key .. "_node")
					end)
				else
					-- Simple color picker without enable checkbox
					local nodeColorValue = nodeColorSettings.color or nodeColorSettings
					nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeDisplayName, nodeColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
					f = nodeControls.color
					f:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[nodeKey], nodeControls, "color", barTypeDef.key .. "_node")
					end)
				end
				yCoord = yCoord - 30
			end
		end
	end	
	
	-- Border Color
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", barTypeDef.key)
		end)
		yCoord = yCoord - 30
	end
	
	-- Background Color
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", barTypeDef.key)
		end)
		yCoord = yCoord - 30
	end
	
	return yCoord
end

---Generates color options for a custom bar with threshold-based colors (step/linear)
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param onChangeCallback function? # Optional callback to call after changes (overrides barTypeDef.onChangeCallback)
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, onChangeCallback)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil
	
	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end
	
	-- Determine the callback to use (parameter overrides definition)
	local changeCallback = onChangeCallback or barTypeDef.onChangeCallback
	
	-- Helper to call the change callback
	local function triggerChange()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
		if changeCallback then
			changeCallback()
		end
	end
	
	local displayName = barTypeDef.displayName
	
	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]
	
	-- Get localized strings from barTypeDef (resolved at registration time, with fallbacks to generic labels)
	local colorTypeLabel = barTypeDef.colorTypeLabel or L["ColorType"]
	local colorTypeStepLabel = barTypeDef.colorTypeStepLabel or L["ColorTypeStep"]
	local colorTypeLinearLabel = barTypeDef.colorTypeLinearLabel or L["ColorTypeLinear"]
	local colorTypeNoneLabel = barTypeDef.colorTypeNoneLabel or L["ColorTypeNone"]
	
	-- Color Transition Type dropdown
	-- Note: yCoord already positioned at header row, so dropdown label goes here
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown[barTypeDef.key .. "ColorCurveType"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetWidth(oUi.sliderWidth)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, colorTypeLabel, oUi.xCoord, yCoord)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label.font:SetFontObject(GameFontNormal)

	local function ColorCurveTypeIsSelected(value)
		return value == colorSettings.type
	end

	local function ColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return colorTypeStepLabel
		elseif value == "linear" then
			return colorTypeLinearLabel
		else
			return colorTypeNoneLabel
		end
	end

	local function ColorCurveTypeSetSelected(newValue)
		colorSettings.type = newValue
		controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(newValue))
		triggerChange()
	end

	local function ColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(colorTypeStepLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(colorTypeLinearLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(colorTypeNoneLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "none")
	end

	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetupMenu(ColorCurveTypeGenerator)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(colorSettings.type))
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	-- Advance yCoord past the dropdown (dropdown + its label takes about 50 units)
	yCoord = yCoord - 80

	-- Get threshold levels from definition (required for threshold-based bars)
	local thresholdLevels = barTypeDef.thresholdLevels
	if not thresholdLevels or #thresholdLevels == 0 then
		-- Early exit if no threshold levels defined
		return yCoord
	end
	
	-- Build threshold sliders (skip first one - no slider needed for base/low)
	-- Use percentage sliders: display percentages, store as decimals
	-- Default max is 100%, but can be overridden by barTypeDef.maxThresholdPercent (e.g., 1000 for stagger)
	local maxThresholdPercent = barTypeDef.maxThresholdPercent or 100
	for i, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if i > 1 and colorSettings[thresholdKey] and colorSettings[thresholdKey].threshold ~= nil then
			-- Use resolved sliderLabel string from thresholdLevel, or fall back to generic formatted label
			local sliderLabel = thresholdLevel.sliderLabel or string.format(L["CustomBarThreshold"], displayName, thresholdKey:gsub("^%l", string.upper))
			controls[barTypeDef.key .. thresholdKey .. "Threshold"] = TRB.Functions.OptionsUi:BuildPercentageSlider(parent, sliderLabel, 
				0, maxThresholdPercent, colorSettings[thresholdKey].threshold, 1, 0,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
			if thresholdLevel.sliderTooltip then
				controls[barTypeDef.key .. thresholdKey .. "Threshold"].tooltip = thresholdLevel.sliderTooltip
			end
			controls[barTypeDef.key .. thresholdKey .. "Threshold"]:SetScript("OnValueChanged", function(self, value)
				-- Slider value is in percentage (0-maxThresholdPercent), store as decimal
				local displayValue = TRB.Functions.Number:RoundTo(value, 0)
				self.EditBox:SetText(displayValue .. "%")
				colorSettings[thresholdKey].threshold = value / 100
				triggerChange()
			end)
			yCoord = yCoord - 60
		end
	end
	
	-- Build color pickers for each threshold
	for _, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if colorSettings[thresholdKey] and colorSettings[thresholdKey].color then
			-- Use resolved colorLabel string from thresholdLevel
			local colorLabel = thresholdLevel.colorLabel
			colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorLabel, colorSettings[thresholdKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
			f = colorControls[thresholdKey]
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, barTypeDef.key)
			end)
			yCoord2 = yCoord2 - 30
		end
	end
	
	-- Border and background colors
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", barTypeDef.key)
		end)
		yCoord2 = yCoord2 - 30
	end
	
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", barTypeDef.key)
		end)
		yCoord2 = yCoord2 - 30
	end
	
	return math.min(yCoord, yCoord2)
end

---Generates visibility options for a custom bar
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarVisibilityOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil
	
	-- Check if displayBar has the visibility key for this bar
	if not spec.displayBar or spec.displayBar[barTypeDef.visibilityKey] == nil then
		return yCoord
	end
	
	local displayName = barTypeDef.displayName
	
	-- Visibility options mapping
	local visibilityOptions = {
		[L["ShowBarVisibilityAlways"]] = "always",
		[L["ShowBarVisibilityCombat"]] = "combat",
		[L["ShowBarVisibilityNever"]] = "never"
	}
	local visibilityOptionsList = {
		L["ShowBarVisibilityAlways"],
		L["ShowBarVisibilityCombat"],
		L["ShowBarVisibilityNever"]
	}

	-- Get display name for current value
	local function GetVisibilityDisplayName(value)
		for displayNameItem, enumValue in pairs(visibilityOptions) do
			if enumValue == value then
				return displayNameItem
			end
		end
		return L["ShowBarVisibilityCombat"] -- Default fallback
	end

	-- Visibility dropdown
	local visibilityLabel = string.format(L["ShowBarVisibilityCustom"], displayName)
	controls.dropDown = controls.dropDown or {}
	controls.dropDown[barTypeDef.key .. "Visibility"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_Visibility", parent, "WowStyle1DropdownTemplate")
	controls.dropDown[barTypeDef.key .. "Visibility"]:SetWidth(oUi.sliderWidth)
	controls.dropDown[barTypeDef.key .. "Visibility"].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, visibilityLabel, oUi.xCoord, yCoord)
	controls.dropDown[barTypeDef.key .. "Visibility"].label.font:SetFontObject(GameFontNormal)

	local function VisibilityIsSelected(value)
		return value == spec.displayBar[barTypeDef.visibilityKey].visibility
	end

	local function VisibilitySetSelected(newValue)
		spec.displayBar[barTypeDef.visibilityKey].visibility = newValue
		controls.dropDown[barTypeDef.key .. "Visibility"]:SetDefaultText(GetVisibilityDisplayName(newValue))
		
		-- Refresh cache to ensure global settings pick up spec-specific overrides
		TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
		TRB.Functions.Character:ResetCaches()
		
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Frames.barGroups ~= nil then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
				TRB.Functions.EditMode:UpdateWrapperSize(settings)
				TRB.Functions.Bar:HideResourceBar()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			else
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	local function VisibilityGenerator(dropdown, rootDescription)
		for _, displayNameItem in ipairs(visibilityOptionsList) do
			rootDescription:CreateRadio(displayNameItem, VisibilityIsSelected, VisibilitySetSelected, visibilityOptions[displayNameItem])
		end
	end

	controls.dropDown[barTypeDef.key .. "Visibility"]:SetupMenu(VisibilityGenerator)
	controls.dropDown[barTypeDef.key .. "Visibility"]:SetDefaultText(GetVisibilityDisplayName(spec.displayBar[barTypeDef.visibilityKey].visibility))
	controls.dropDown[barTypeDef.key .. "Visibility"]:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 70

	-- Custom bar smooth checkbox
	yCoord = yCoord - 65
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes[barTypeDef.key .. "Smooth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Smooth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[barTypeDef.key .. "Smooth"]
	f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
	f.tooltip = L["CheckboxSmoothBarTooltip"]
	f:SetChecked(spec.displayBar[barTypeDef.visibilityKey].smooth)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar[barTypeDef.visibilityKey].smooth = self:GetChecked()
		-- Refresh cache
		TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
		TRB.Functions.Character:ResetCaches()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Frames.barGroups ~= nil then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			end
		end
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls, textures, newValue, variable, includeComboPoints, includeManaBar, customBars)
	local newName = statusbarPairsByName[newValue]
	if includeComboPoints == nil then
		includeComboPoints = false
	end
	if includeManaBar == nil then
		includeManaBar = false
	end
	if customBars == nil then
		customBars = {}
	end

	textures[variable.."Bar"] = newValue
	textures[variable.."BarName"] = newName
	DropdownSetupMenuWrapper(controls[variable.."Bar"])
	if textures.textureLock then
		textures.resourceBar = newValue
		textures.resourceBarName = newName
		DropdownSetupMenuWrapper(controls.resourceBar)

		if includeComboPoints then
			textures.comboPointsBar = newValue
			textures.comboPointsBarName = newName
			DropdownSetupMenuWrapper(controls.comboPointsBar)
		end

		if includeManaBar then
			textures.manaBarBar = newValue
			textures.manaBarBarName = newName
			DropdownSetupMenuWrapper(controls.manaBarBar)
		end

		-- Sync custom bar textures
		for _, barTypeDef in ipairs(customBars) do
			local barKey = barTypeDef.key .. "Bar"
			textures[barKey] = newValue
			textures[barKey .. "Name"] = newName
			DropdownSetupMenuWrapper(controls[barKey])
		end

		textures.healthBar = newValue
		textures.healthBarName = newName
		DropdownSetupMenuWrapper(controls.healthBar)
	end
	
	TRB.Functions.Character:ResetCaches()
	if TRB.Frames.barGroups ~= nil then
		local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	else
		TRB.Functions.Bar:Construct()
	end
end

function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, classId, specId, yCoord, includeComboPoints, secondaryResourceString, includeManaBar, customBars)
	if includeComboPoints == nil then
		includeComboPoints = false
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
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				else
					TRB.Functions.Bar:Construct()
				end
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("textures")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllTextures", "textures", yCoord)
	end
	
	controls.dropDown.textures = {}

	yCoord = yCoord - 30

	local function StatusbarSetValue(variable, newValue)
		TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(controls.dropDown.textures, spec.textures, newValue, variable, includeComboPoints, includeManaBar, customBars)
	end

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
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		else
			TRB.Functions.Bar:Construct()
		end
	end

	-- ===== BAR TEXTURES SUBSECTION =====
	controls.barTexturesSubsection = TRB.Functions.OptionsUi:BuildLabel(parent, L["BarTexturesSectionHeader"], oUi.xCoord, yCoord, 500, 20, GameFontNormalMed2)

	yCoord = yCoord - 20

	-- Row 1: Primary Bar (left), Health Bar (right)
	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "resourceBar", L["MainBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("resource", newValue)
		end)

	TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord2, yCoord, "statusbar", "healthBar", L["HealthBarTexture"], L["StatusBarTextures"],
		function(newValue)
			StatusbarSetValue("health", newValue)
		end)

	-- Row 2: Secondary / Combo Points (left, if applicable), Mana Bar (right, if applicable)
	if includeComboPoints then
		yCoord = yCoord - 60
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "statusbar", "comboPointsBar", string.format(L["SecondaryBarTexture"], secondaryResourceString), L["StatusBarTextures"],
			function(newValue)
				StatusbarSetValue("comboPoints", newValue)
			end)
	end

	-- Row 3: Mana Bar (left, if applicable and no combo points), or add to row 2 right side
	if includeManaBar then
		if not includeComboPoints then
			yCoord = yCoord - 60
		end
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, includeComboPoints and oUi.xCoord2 or oUi.xCoord, yCoord, "statusbar", "manaBarBar", L["ManaBarTexture"], L["StatusBarTextures"],
			function(newValue)
				StatusbarSetValue("manaBar", newValue)
			end)
	end

	-- Custom bars (e.g., Stagger) - uses flat keys like staggerBar, staggerBarName
	local customBarPlacedOnLeft = not (includeComboPoints and includeManaBar)
	for i, barTypeDef in ipairs(customBars) do
		-- Determine position: alternate left/right, starting new row as needed
		local useLeftColumn = (i % 2 == 1) or not customBarPlacedOnLeft
		if useLeftColumn then
			yCoord = yCoord - 60
		end
		local xPos = useLeftColumn and oUi.xCoord or oUi.xCoord2
		local barKey = barTypeDef.key .. "Bar"
		local barLabel = string.format(L["CustomBarTextureBar"], barTypeDef.displayName)
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "statusbar", barKey, barLabel, L["StatusBarTextures"],
			function(newValue)
				StatusbarSetValue(barTypeDef.key, newValue)
			end)
		customBarPlacedOnLeft = useLeftColumn
	end

	yCoord = yCoord - 70

	-- ===== BORDER TEXTURES SUBSECTION =====
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


	-- Row 2: Secondary / Combo Points (left, if applicable)
	if includeComboPoints then
		yCoord = yCoord - 60
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "border", "comboPointsBorder", string.format(L["SecondaryBorderTexture"], secondaryResourceString), L["BorderTextures"],
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
				end

				RefreshBar()
			end)
	end

	-- Row 3: Mana Bar Border (left, if applicable and no combo points), or add to row 2 right side
	if includeManaBar then
		if not includeComboPoints then
			yCoord = yCoord - 60
		end
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, includeComboPoints and oUi.xCoord2 or oUi.xCoord, yCoord, "border", "manaBarBorder", L["ManaBarBorderTexture"], L["BorderTextures"],
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
				end

				RefreshBar()
			end)
	end

	-- Custom bar borders (e.g., Stagger) - uses flat keys like staggerBorder
	customBarPlacedOnLeft = not (includeComboPoints and includeManaBar)
	for i, barTypeDef in ipairs(customBars) do
		local useLeftColumn = (i % 2 == 1) or not customBarPlacedOnLeft
		if useLeftColumn then
			yCoord = yCoord - 60
		end
		local xPos = useLeftColumn and oUi.xCoord or oUi.xCoord2
		local borderKey = barTypeDef.key .. "Border"
		local borderLabel = string.format(L["CustomBarTextureBorder"], barTypeDef.displayName)
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "border", borderKey, borderLabel, L["BorderTextures"],
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
					-- Sync other custom bars
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
			end)
		customBarPlacedOnLeft = useLeftColumn
	end

	yCoord = yCoord - 70

	-- ===== BACKGROUND TEXTURES SUBSECTION =====
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


	-- Row 2: Secondary / Combo Points (left, if applicable)
	if includeComboPoints then
	yCoord = yCoord - 60
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, oUi.xCoord, yCoord, "background", "comboPointsBackground", string.format(L["SecondaryBackgroundTexture"], secondaryResourceString), L["BackgroundTextures"],
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
	end

	-- Row 3: Mana Bar Background (left, if applicable and no combo points), or add to row 2 right side
	if includeManaBar then
		if not includeComboPoints then
			yCoord = yCoord - 60
		end
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, includeComboPoints and oUi.xCoord2 or oUi.xCoord, yCoord, "background", "manaBarBackground", L["ManaBarBackgroundTexture"], L["BackgroundTextures"],
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
	end

	-- Custom bar backgrounds (e.g., Stagger) - uses flat keys like staggerBackground
	customBarPlacedOnLeft = not (includeComboPoints and includeManaBar)
	for i, barTypeDef in ipairs(customBars) do
		local useLeftColumn = (i % 2 == 1) or not customBarPlacedOnLeft
		if useLeftColumn then
			yCoord = yCoord - 60
		end
		local xPos = useLeftColumn and oUi.xCoord or oUi.xCoord2
		local bgKey = barTypeDef.key .. "Background"
		local bgLabel = string.format(L["CustomBarTextureBackground"], barTypeDef.displayName)
		TRB.Functions.OptionsUi:CreateLsmDropdown(parent, controls.dropDown.textures, spec.textures, classId, specId, xPos, yCoord, "background", bgKey, bgLabel, L["BackgroundTextures"],
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
					-- Sync other custom bars
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
			end)
		customBarPlacedOnLeft = useLeftColumn
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

function TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeFlashAlpha, flashAlphaName, flashAlphaNameShort, includeSecondaryVisibility, secondaryResourceString, includeHealthVisibility, includeManaBarVisibility)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.barDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalDisplayBar = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_displayBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalDisplayBar
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDisplay"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayBar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayBar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				else
					TRB.Functions.Bar:Construct()
				end
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("displayBar")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayBar", "displayBar", yCoord)
	end

	yCoord = yCoord - 30
	
	-- Bar visibility options mapping
	local visibilityOptions = {
		[L["ShowBarVisibilityAlways"]] = "always",
		[L["ShowBarVisibilityCombat"]] = "combat",
		[L["ShowBarVisibilityNever"]] = "never"
	}
	local visibilityOptionsList = {
		L["ShowBarVisibilityAlways"],
		L["ShowBarVisibilityCombat"],
		L["ShowBarVisibilityNever"]
	}

	-- Get display name for current value
	local function GetVisibilityDisplayName(value)
		for displayName, enumValue in pairs(visibilityOptions) do
			if enumValue == value then
				return displayName
			end
		end
		return L["ShowBarVisibilityCombat"] -- Default fallback
	end

	-- Primary bar visibility dropdown
	local primaryLabel = string.format(L["ShowBarVisibilityPrimary"], primaryResourceString or L["ResourceMana"])
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.primaryVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_PrimaryVisibility", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.primaryVisibility:SetWidth(oUi.sliderWidth)
	controls.dropDown.primaryVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, primaryLabel, oUi.xCoord, yCoord)
	controls.dropDown.primaryVisibility.label.font:SetFontObject(GameFontNormal)

	local function PrimaryVisibilityIsSelected(value)
		return value == spec.displayBar.primary.visibility
	end

	local function PrimaryVisibilitySetSelected(newValue)
		spec.displayBar.primary.visibility = newValue
		controls.dropDown.primaryVisibility:SetDefaultText(GetVisibilityDisplayName(newValue))
		if classId ~= nil and specId ~= nil then
			-- Spec panel
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				-- Reapply layout to adjust positioning for the visibility change
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
				end
				TRB.Functions.Bar:HideResourceBar()
			end
		else
			-- Global panel: refresh current character's cache if using global displayBar
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
				end
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	local function PrimaryVisibilityGenerator(dropdown, rootDescription)
		for _, displayName in ipairs(visibilityOptionsList) do
			rootDescription:CreateRadio(displayName, PrimaryVisibilityIsSelected, PrimaryVisibilitySetSelected, visibilityOptions[displayName])
		end
	end

	controls.dropDown.primaryVisibility:SetupMenu(PrimaryVisibilityGenerator)
	controls.dropDown.primaryVisibility:SetDefaultText(GetVisibilityDisplayName(spec.displayBar.primary.visibility))
	controls.dropDown.primaryVisibility:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	-- Health bar visibility dropdown (only if includeHealthVisibility is true)
	if includeHealthVisibility and spec.displayBar.health ~= nil then
		local healthLabel = L["ShowBarVisibilityHealth"]
		controls.dropDown.healthVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_HealthVisibility", parent, "WowStyle1DropdownTemplate")
		controls.dropDown.healthVisibility:SetWidth(oUi.sliderWidth)
		controls.dropDown.healthVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, healthLabel, oUi.xCoord2, yCoord)
		controls.dropDown.healthVisibility.label.font:SetFontObject(GameFontNormal)

		local function HealthVisibilityIsSelected(value)
			return value == spec.displayBar.health.visibility
		end

		local function HealthVisibilitySetSelected(newValue)
			spec.displayBar.health.visibility = newValue
			controls.dropDown.healthVisibility:SetDefaultText(GetVisibilityDisplayName(newValue))
			if classId ~= nil and specId ~= nil then
				-- Spec panel
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					-- Reapply layout to adjust positioning for the visibility change
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			end
		end

		local function HealthVisibilityGenerator(dropdown, rootDescription)
			for _, displayName in ipairs(visibilityOptionsList) do
				rootDescription:CreateRadio(displayName, HealthVisibilityIsSelected, HealthVisibilitySetSelected, visibilityOptions[displayName])
			end
		end

		controls.dropDown.healthVisibility:SetupMenu(HealthVisibilityGenerator)
		controls.dropDown.healthVisibility:SetDefaultText(GetVisibilityDisplayName(spec.displayBar.health.visibility))
		controls.dropDown.healthVisibility:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)
	end

	-- Smooth animation checkboxes (same row, below the visibility dropdowns)
	yCoord = yCoord - 65
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.primarySmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_PrimarySmooth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.primarySmooth
	f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
	f.tooltip = L["CheckboxSmoothBarTooltip"]
	f:SetChecked(spec.displayBar.primary.smooth)
	f:SetScript("OnClick", function(self, ...)
		spec.displayBar.primary.smooth = self:GetChecked()
		-- Refresh cache to pick up the new smooth setting
		if classId ~= nil and specId ~= nil then
			-- Spec panel: refresh that spec's cache
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
			if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				end
			end
		else
			-- Global panel: refresh current character's cache if using global displayBar
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				end
			end
		end
	end)

	if includeHealthVisibility and spec.displayBar.health ~= nil then
		controls.checkBoxes.healthSmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_HealthSmooth", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.healthSmooth
		f:SetPoint("TOPLEFT", oUi.xCoord2 + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
		f.tooltip = L["CheckboxSmoothBarTooltip"]
		f:SetChecked(spec.displayBar.health.smooth)
		f:SetScript("OnClick", function(self, ...)
			spec.displayBar.health.smooth = self:GetChecked()
			-- Refresh cache to pick up the new smooth setting
			if classId ~= nil and specId ~= nil then
				-- Spec panel: refresh that spec's cache
				TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			end
		end)
	end

	-- Secondary bar visibility dropdown (only if includeSecondaryVisibility is true)
	if includeSecondaryVisibility then
		yCoord = yCoord - 30
		local secondaryLabel = string.format(L["ShowBarVisibilitySecondary"], secondaryResourceString or L["ResourceComboPoints"])
		controls.dropDown.secondaryVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_SecondaryVisibility", parent, "WowStyle1DropdownTemplate")
		controls.dropDown.secondaryVisibility:SetWidth(oUi.sliderWidth)
		controls.dropDown.secondaryVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, secondaryLabel, oUi.xCoord, yCoord)
		controls.dropDown.secondaryVisibility.label.font:SetFontObject(GameFontNormal)

		local function SecondaryVisibilityIsSelected(value)
			return value == spec.displayBar.secondary.visibility
		end

		local function SecondaryVisibilitySetSelected(newValue)
			spec.displayBar.secondary.visibility = newValue
			controls.dropDown.secondaryVisibility:SetDefaultText(GetVisibilityDisplayName(newValue))
			if classId ~= nil and specId ~= nil then
				-- Spec panel
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					-- Reapply layout to adjust positioning for the visibility change
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			end
		end

		local function SecondaryVisibilityGenerator(dropdown, rootDescription)
			for _, displayName in ipairs(visibilityOptionsList) do
				rootDescription:CreateRadio(displayName, SecondaryVisibilityIsSelected, SecondaryVisibilitySetSelected, visibilityOptions[displayName])
			end
		end

		controls.dropDown.secondaryVisibility:SetupMenu(SecondaryVisibilityGenerator)
		controls.dropDown.secondaryVisibility:SetDefaultText(GetVisibilityDisplayName(spec.displayBar.secondary.visibility))
		controls.dropDown.secondaryVisibility:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

		-- Secondary smooth checkbox
		yCoord = yCoord - 65
		controls.checkBoxes.secondarySmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_SecondarySmooth", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secondarySmooth
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
		f.tooltip = L["CheckboxSmoothBarTooltip"]
		f:SetChecked(spec.displayBar.secondary.smooth)
		f:SetScript("OnClick", function(self, ...)
			spec.displayBar.secondary.smooth = self:GetChecked()
			-- Refresh cache to pick up the new smooth setting
			if classId ~= nil and specId ~= nil then
				-- Spec panel: refresh that spec's cache
				TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			end
		end)
	end

	-- Mana bar visibility dropdown (only if includeManaBarVisibility is true)
	if includeManaBarVisibility and spec.displayBar.mana ~= nil then
		yCoord = yCoord - 30
		local manaLabel = L["ShowBarVisibilityMana"]
		controls.dropDown.manaVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ManaVisibility", parent, "WowStyle1DropdownTemplate")
		controls.dropDown.manaVisibility:SetWidth(oUi.sliderWidth)
		controls.dropDown.manaVisibility.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, manaLabel, oUi.xCoord, yCoord)
		controls.dropDown.manaVisibility.label.font:SetFontObject(GameFontNormal)

		local function ManaVisibilityIsSelected(value)
			return value == spec.displayBar.mana.visibility
		end

		local function ManaVisibilitySetSelected(newValue)
			spec.displayBar.mana.visibility = newValue
			controls.dropDown.manaVisibility:SetDefaultText(GetVisibilityDisplayName(newValue))
			if classId ~= nil and specId ~= nil then
				-- Spec panel: also update specCache for immediate effect
				if TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].settings and TRB.Data.specCache[TRB.Data.character.compositeKey].settings.displayBar then
					TRB.Data.specCache[TRB.Data.character.compositeKey].settings.displayBar.mana.visibility = newValue
				end
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					-- Reapply layout to adjust positioning for the visibility change
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
						TRB.Functions.EditMode:UpdateWrapperSize(TRB.Data.specCache[TRB.Data.character.compositeKey].settings)
					end
					TRB.Functions.Bar:HideResourceBar()
				end
			end
		end

		local function ManaVisibilityGenerator(dropdown, rootDescription)
			for _, displayName in ipairs(visibilityOptionsList) do
				rootDescription:CreateRadio(displayName, ManaVisibilityIsSelected, ManaVisibilitySetSelected, visibilityOptions[displayName])
			end
		end

		controls.dropDown.manaVisibility:SetupMenu(ManaVisibilityGenerator)
		controls.dropDown.manaVisibility:SetDefaultText(GetVisibilityDisplayName(spec.displayBar.mana.visibility))
		controls.dropDown.manaVisibility:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

		-- Mana smooth checkbox
		yCoord = yCoord - 65
		controls.checkBoxes.manaSmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_ManaSmooth", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaSmooth
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
		f.tooltip = L["CheckboxSmoothBarTooltip"]
		f:SetChecked(spec.displayBar.mana.smooth)
		f:SetScript("OnClick", function(self, ...)
			spec.displayBar.mana.smooth = self:GetChecked()
			-- Refresh cache to pick up the new smooth setting
			if classId ~= nil and specId ~= nil then
				-- Spec panel: refresh that spec's cache
				TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
				if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			else
				-- Global panel: refresh current character's cache if using global displayBar
				if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
					local lowerClassName = string.lower(TRB.Data.character.className)
					local currentSpecName = TRB.Data.character.specName
					TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
					TRB.Functions.Character:ResetCaches()
					if TRB.Frames.barGroups ~= nil then
						local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
						TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					end
				end
			end
		end)
	end

	if includeFlashAlpha then
		yCoord = yCoord - 50
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
		yCoord = yCoord - 10
	end

	local yCoord2 = yCoord - 40

	if includeFlashAlpha then
		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Checkbox_FlashEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord2)
		getglobal(f:GetName() .. 'Text'):SetText(string.format(L["FlashBar"], flashAlphaNameShort))
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["FlashBarTooltip"], flashAlphaName)
		f:SetChecked(spec.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashEnabled = self:GetChecked()
		end)
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, classId, specId, yCoord, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
	
	yCoord = yCoord - 30
	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinePositionHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdIcons = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdIcons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdIcons
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdIcons"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdIcons = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName, isHealer)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdIcons")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdIcons", "thresholdIcons", yCoord)
	end
	
	yCoord = yCoord - 20
	local thresholdIconRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdIconRelativeTo", parent, "WowStyle1DropdownTemplate")
	thresholdIconRelativeTo:SetWidth(oUi.sliderWidth)
	thresholdIconRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdIconRelativePosition"], oUi.xCoord, yCoord)
	thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["PositionAbove"]] = "TOP"
	relativeTo[L["PositionMiddle"]] = "CENTER"
	relativeTo[L["PositionBelow"]] = "BOTTOM"
	local relativeToList = {
		L["PositionAbove"],
		L["PositionMiddle"],
		L["PositionBelow"]
	}

	local function RelativeToIsSelected(value)
		return value == spec.thresholds.icons.relativeTo
	end
	
	local function RelativeToSetSelected(newValue)
		spec.thresholds.icons.relativeTo = newValue
		
		for k, v in pairs(relativeTo) do
			if v == newValue then
				spec.thresholds.icons.relativeToName = k
				break
			end
		end
		thresholdIconRelativeTo:SetDefaultText(spec.thresholds.icons.relativeToName)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	thresholdIconRelativeTo:SetupMenu(RelativeToGenerator)
	thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconShow"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconShowTooltip"]
	f:SetChecked(spec.thresholds.icons.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.enabled = self:GetChecked()

		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	controls.checkBoxes.thresholdIconDesaturated = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_ThresholdIconDesaturated", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdIconDesaturated
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding*2, yCoord-50)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdIconDesaturate"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["ThresholdIconDesaturateTooltip"]
	f:SetChecked(spec.thresholds.icons.desaturated)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.icons.desaturated = self:GetChecked()
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconDesaturated, spec.thresholds.icons.enabled)

	yCoord = yCoord - 100
	title = L["ThresholdIconWidth"]
	controls.thresholdIconWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.width = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = spec.thresholds.icons.border
	
		if maxBorderSize < borderSize then
			maxBorderSize = borderSize
		end

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconHeight"]
	controls.thresholdIconHeight = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.height = value

		local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = spec.thresholds.icons.border
	
		if maxBorderSize < borderSize then
			maxBorderSize = borderSize
		end

		controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
		controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)


	title = L["ThresholdIconHorizontal"]
	yCoord = yCoord - 60
	controls.thresholdIconHorizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.xPos = value
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdIconVertical"]
	controls.thresholdIconVertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.yPos = value
		
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

	title = L["ThresholdIconBorderWidth"]
	yCoord = yCoord - 60
	controls.thresholdIconBorderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.icons.border = value

		local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
		local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

		controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
		controls.thresholdIconHeight.MinLabel:SetText(tostring(minsliderHeight))
		controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
		controls.thresholdIconWidth.MinLabel:SetText(tostring(minsliderWidth))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)

	title = L["ThresholdLineWidth"]
	controls.thresholdWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.thresholds.properties.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.thresholds.properties.width = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil) then
			TRB.Functions.Threshold:RedrawThresholdLines()
		end
	end)
	
	yCoord = yCoord - 40
	controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thresholdOverlapBorder
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOverlapBorderCheckbox"])
	f.tooltip = L["ThresholdOverlapBorderCheckboxTooltip"]
	f:SetChecked(spec.thresholds.properties.overlapBorder)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.properties.overlapBorder = self:GetChecked()
		TRB.Functions.Threshold:RedrawThresholdLines()
	end)

	return yCoord
end

---Generates Threshold Line color options for the specialization, including custom colors if provided.
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer?
---@param specId integer?
---@param yCoord number
---@param localizationResource string
---@param under boolean?
---@param over boolean?
---@param unusable boolean?
---@param outOfRange boolean?
---@param custom TRB.Classes.OptionsUi.Color[]?
---@return number
function TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, classId, specId, yCoord, localizationResource, under, over, unusable, outOfRange, custom)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	
	controls.colors.threshold = controls.colors.threshold or {}

	if classId == nill then
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsForDpsAndTanksHeader"], oUi.xCoord, yCoord)
	else
		yCoord = yCoord - 30
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLineColorsHeader"], oUi.xCoord, yCoord)
	end
	
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalThresholdColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_thresholdColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalThresholdColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_ThresholdColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].thresholdColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Threshold:RedrawThresholdLines()
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("thresholdColors")
		end)
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllThresholdColors", "thresholdColors", yCoord)
	end

	if under == true then
		yCoord = yCoord - 30
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdUnderMinimum"], localizationResource), spec.colors.threshold.under.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)
	end

	if over == true then
		yCoord = yCoord - 30
		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["ThresholdOverMinimum"], localizationResource), spec.colors.threshold.over.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)
	end

	if unusable == true then
		yCoord = yCoord - 30
		controls.colors.threshold.unusable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdUnusable"], spec.colors.threshold.unusable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)
	end

	if outOfRange == true then
		yCoord = yCoord - 30
		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord+10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeShowCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeShowCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.show)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.show = self:GetChecked()

			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)

		controls.checkBoxes.thresholdOutOfRangeColorEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_thresholdOutOfRangeColorEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRangeColorEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText(L["ThresholdOutOfRangeCheckbox"])
		f.tooltip = L["ThresholdOutOfRangeCheckboxTooltip"]
		f:SetChecked(spec.colors.threshold.outOfRange.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.threshold.outOfRange.enabled = self:GetChecked()
			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].thresholdColors) then
				if not spec.colors.threshold.outOfRange.show or (spec.colors.threshold.outOfRange.show and spec.colors.threshold.outOfRange.enabled) then
					TRB.Functions.Character:EnableSpellRangeCheckUpdate()
				else
					TRB.Functions.Character:DisableSpellRangeCheckUpdate()
				end
			end
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.thresholdOutOfRangeColorEnabled, spec.colors.threshold.outOfRange.show)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ThresholdOutOfRange"], spec.colors.threshold.outOfRange.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)
	end

	if custom ~= nil and #custom > 0 then
		for _, value in pairs(custom) do
			yCoord, _, _ = TRB.Functions.OptionsUi:BuildColorPickerWithEnable(parent, yCoord, controls, "threshold", spec.colors.threshold, namePrefix, value)
		end
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap)
	local f = nil
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, primaryResourceString, spec.colors.bar.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetResourceFrame and node:GetResourceFrame() or nil
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarBorderColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorBase"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = barBorderFrame
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetBorderFrame and node:GetBorderFrame() or borderFrame
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	if includeOvercap then
		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Border_Option_overcapBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BorderColorOvercapToggle"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["BorderColorOvercapToggleTooltip"], primaryResourceString)
		f:SetChecked(spec.colors.bar.borderOvercap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.borderOvercap.enabled = self:GetChecked()
		end)

		controls.colors.borderOvercap = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["BorderColorOvercap"], primaryResourceString), spec.colors.bar.borderOvercap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)
	end

	if isHealer then
	end

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local L = TRB.Localization or {}

	-- Build the header
	controls.healthBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarColorHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	-- Create a lightweight bar type definition-like object for Health Bar
	-- This allows us to use the generic threshold color function while keeping
	-- the Health Bar's settings at spec.colors.healthBar (not spec.colors.bars.health)
	-- IMPORTANT: Pass resolved localized strings, NOT localization keys
	local healthBarTypeDef = {
		key = "health",
		displayName = L["HealthBar"]:gsub(" Bar$", ""), -- "Health" instead of "Health Bar" for labels like "Health border"
		colorCurveType = "step",
		thresholdLevels = {
			{ key = "low", colorLabel = L["HealthBarColorLow"] },
			{ key = "medium", colorLabel = L["HealthBarColorMedium"], sliderLabel = L["HealthBarThresholdMedium"], sliderTooltip = L["HealthBarThresholdMediumTooltip"] },
			{ key = "high", colorLabel = L["HealthBarColorHigh"], sliderLabel = L["HealthBarThresholdHigh"], sliderTooltip = L["HealthBarThresholdHighTooltip"] }
		},
		colorTypeLabel = L["HealthBarColorType"],
		colorTypeStepLabel = L["HealthBarColorTypeStep"],
		colorTypeLinearLabel = L["HealthBarColorTypeLinear"],
		colorTypeNoneLabel = L["HealthBarColorTypeNone"],
		-- Custom GetColors to retrieve from spec.colors.healthBar instead of spec.colors.bars.health
		GetColors = function(self, specSettings)
			if specSettings and specSettings.colors then
				return specSettings.colors.healthBar
			end
			return nil
		end
	}

	-- Use the generic threshold color function with the Health Bar callback
	return TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(
		parent, controls, spec, classId, specId, yCoord, healthBarTypeDef,
		function()
			TRB.Functions.Character:UpdateHealthValues()
		end
	)
end

function TRB.Functions.OptionsUi:GenerateStaggerBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.staggerBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorHeader"], oUi.xCoord, yCoord)

	-- Color Transition Type dropdown
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.staggerColorCurveType = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_StaggerColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.staggerColorCurveType:SetWidth(oUi.sliderWidth)
	controls.dropDown.staggerColorCurveType.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorType"], oUi.xCoord, yCoord)
	controls.dropDown.staggerColorCurveType.label.font:SetFontObject(GameFontNormal)

	local function StaggerColorCurveTypeIsSelected(value)
		return value == spec.colors.comboPoints.type
	end

	local function StaggerColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return L["StaggerBarColorTypeStep"]
		elseif value == "linear" then
			return L["StaggerBarColorTypeLinear"]
		else
			return L["StaggerBarColorTypeNone"]
		end
	end

	local function StaggerColorCurveTypeSetSelected(newValue)
		spec.colors.comboPoints.type = newValue
		controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function StaggerColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["StaggerBarColorTypeStep"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(L["StaggerBarColorTypeLinear"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(L["StaggerBarColorTypeNone"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "none")
	end

	controls.dropDown.staggerColorCurveType:SetupMenu(StaggerColorCurveTypeGenerator)
	controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(spec.colors.comboPoints.type))
	controls.dropDown.staggerColorCurveType:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)


	-- Medium Stagger Threshold Slider
	yCoord = yCoord - 80
	controls.staggerThresholdMedium = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdMedium"], 0, 1, spec.colors.comboPoints.medium.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdMedium.tooltip = L["StaggerBarThresholdMediumTooltip"]
	controls.staggerThresholdMedium:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.medium.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.medium.threshold = spec.colors.comboPoints.heavy.threshold
			controls.staggerThresholdMedium.EditBox:SetText(spec.colors.comboPoints.medium.threshold)
			controls.staggerThresholdMedium:SetValue(spec.colors.comboPoints.medium.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Heavy Stagger Threshold Slider
	yCoord = yCoord - 60
	controls.staggerThresholdHeavy = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdHeavy"], 0, 1, spec.colors.comboPoints.heavy.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdHeavy.tooltip = L["StaggerBarThresholdHeavyTooltip"]
	controls.staggerThresholdHeavy:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.heavy.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.heavy.threshold = spec.colors.comboPoints.medium.threshold
			controls.staggerThresholdHeavy.EditBox:SetText(spec.colors.comboPoints.heavy.threshold)
			controls.staggerThresholdHeavy:SetValue(spec.colors.comboPoints.heavy.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	
	-- Light Stagger Color
	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.colors.comboPoints.light = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorLight"], spec.colors.comboPoints.light.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.light
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "light", "stagger")
	end)

	-- Medium Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.medium = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorMedium"], spec.colors.comboPoints.medium.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.medium
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "medium", "stagger")
	end)

	-- Heavy Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.heavy = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorHeavy"], spec.colors.comboPoints.heavy.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.heavy
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "heavy", "stagger")
	end)
	
	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBorder = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBorder
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "border", "border", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)
	
	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBackground = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBackground
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord2 - 20

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.overcappingConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["OvercappingConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.overcapModeRelative = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Relative", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeRelative
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapRelativeOffset"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "relative" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(true)
		controls.checkBoxes.overcapModeFixed:SetChecked(false)
		spec.overcap.mode = "relative"
	end)

	title = string.format(L["OvercapRelativeOffsetAmount"], primaryResourceString)
	controls.overcapRelative = TRB.Functions.OptionsUi:BuildSlider(parent, title, -primaryResourceMax, 0, spec.overcap.relative, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapRelative:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.relative = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.overcapModeFixed = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Fixed", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeFixed
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapFixedValue"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "fixed" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(false)
		controls.checkBoxes.overcapModeFixed:SetChecked(true)
		spec.overcap.mode = "fixed"
	end)

	title = string.format(L["OvercapAbove"], primaryResourceString)
	controls.overcapFixed = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, primaryResourceMax, spec.overcap.fixed, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapFixed:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.fixed = value
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMin, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.maxResourceConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["MaxResourceValue"], primaryResourceString)
	controls.checkBoxes.maxResourceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_maxResourceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maxResourceEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaxResourceEnabled"])
	f.tooltip = L["MaxResourceEnabledTooltip"]
	f:SetChecked(spec.maxResource.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.maxResource.enabled = self:GetChecked()
	end)
	
	controls.maxResourceValue = TRB.Functions.OptionsUi:BuildSlider(parent, title, primaryResourceMin, primaryResourceMax, spec.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.maxResourceValue:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.maxResource.value = value
		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			if TRB.Frames.barGroups ~= nil and TRB.Data.character.compositeKey then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end
	end)

	return yCoord
end

---Generates the "End Of" buff color options UI (active buff color checkbox + color picker, ending color checkbox + color picker)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, activeColorKey, endColorKey, checkboxLabel, checkboxTooltip, activeColorLabel, endColorLabel, additionalColors (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	-- Active buff color checkbox + color picker
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}

	controls.checkBoxes[config.activeColorKey .. "BarChange"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.activeColorKey .. "Change", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[config.activeColorKey .. "BarChange"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.checkboxLabel)
	f.tooltip = config.checkboxTooltip
	f:SetChecked(spec.colors.bar[config.activeColorKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar[config.activeColorKey].enabled = self:GetChecked()
	end)

	controls.colors[config.activeColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.activeColorLabel, spec.colors.bar[config.activeColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.activeColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.activeColorKey)
	end)

	-- End of buff color checkbox + color picker
	yCoord = yCoord - 30
	controls.checkBoxes["endOf" .. config.endOfKey] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.endOfKey .. "ColorChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.endCheckboxLabel)
	f.tooltip = config.endCheckboxTooltip
	f:SetChecked(spec.endOf[config.endOfKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOf[config.endOfKey].enabled = self:GetChecked()
	end)

	controls.colors[config.endColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.endColorLabel, spec.colors.bar[config.endColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.endColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.endColorKey)
	end)

	-- Additional colors (optional)
	if config.additionalColors ~= nil then
		for _, colorConfig in ipairs(config.additionalColors) do
			yCoord = yCoord - 30
			controls.checkBoxes[colorConfig.key .. "Change"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. colorConfig.key .. "Change", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes[colorConfig.key .. "Change"]
			f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(f:GetName() .. 'Text'):SetText(colorConfig.checkboxLabel)
			f.tooltip = colorConfig.checkboxTooltip
			f:SetChecked(spec.colors.bar[colorConfig.key].enabled)
			f:SetScript("OnClick", function(self, ...)
				spec.colors.bar[colorConfig.key].enabled = self:GetChecked()
			end)

			controls.colors[colorConfig.key] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorConfig.colorLabel, spec.colors.bar[colorConfig.key].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = controls.colors[colorConfig.key]
			local capturedKey = colorConfig.key
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, capturedKey)
			end)
		end
	end

	return yCoord
end

---Generates the "End Of" buff configuration options UI (GCD/Time radio buttons and sliders)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, sectionHeader, gcdRadioLabel, gcdSliderLabel, timeRadioLabel, timeSliderLabel, gcdSliderMax (optional), timeSliderMax (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	local endOfSettings = spec.endOf[config.endOfKey]
	local gcdSliderMax = config.gcdSliderMax or 30
	local timeSliderMax = config.timeSliderMax or 15

	controls.checkBoxes = controls.checkBoxes or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, config.sectionHeader, oUi.xCoord, yCoord)

	yCoord = yCoord - 40

	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeGCDs", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.gcdRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(true)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(false)
		endOfSettings.mode = "gcd"
	end)

	controls["endOf" .. config.endOfKey .. "GCDs"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.gcdSliderLabel, 0.5, gcdSliderMax, endOfSettings.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "GCDs"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		endOfSettings.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeTime", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.timeRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(false)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(true)
		endOfSettings.mode = "time"
	end)

	controls["endOf" .. config.endOfKey .. "Time"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.timeSliderLabel, 0, timeSliderMax, endOfSettings.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "Time"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		endOfSettings.timeMax = value
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown.fonts = {}

	controls.textDisplayDefaultSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultBarTextFontSettingsHeader"], oUi.xCoord, yCoord)

	-- Show informational notice about how default font settings work
	yCoord = yCoord - 30
	controls.defaultFontNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.defaultFontNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.defaultFontNotice:SetWidth(550)
	controls.defaultFontNotice:SetJustifyH("LEFT")
	controls.defaultFontNotice:SetText("|cFFCCCCCC" .. L["DefaultFontSettingsNotice"] .. "|r")

	if specId ~= nil and classId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobal = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_displayText", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobal
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_Font"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("displayText")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayText", "displayText", yCoord)
	end
	yCoord = yCoord - 30

	FillFontCache()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFaceDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	local function FontFaceIsSelected(value)
		return value == spec.displayText.default.fontFace
	end
	
	local function FontFaceSetSelected(newValue)
		spec.displayText.default.fontFace = newValue
		spec.displayText.default.fontFaceName = fontPairsByName[newValue]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 30
	controls.colors.text.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DefaultFontColor"], spec.displayText.default.color.color,
																		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.color
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.displayText.default, controls.colors.text, "color")
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	yCoord = yCoord - 60
	title = L["DefaultFontSize"]
	controls.fontSizeDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.default.fontSize, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontSizeDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.displayText.default.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	local lowerClassName = string.lower(className)
	controls.checkBoxes.useGlobalTextColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_textColors", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.useGlobalTextColors
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	f.tooltip = L["CheckboxUseGlobalTooltip_TextColors"]
	f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textColors)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.global[lowerClassName][specName].textColors = self:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("textColors")
	end)

	return yCoord
end

function TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalPrecision = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_precision", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalPrecision
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalTooltip_Precision"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].precision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].precision = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("precision")
		end)
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllPrecision", "precision", yCoord)
		yCoord = yCoord + 25 -- Offset adjustment for consistency with per-spec layout
	end
	yCoord = yCoord - 50

	title = L["SecondaryDecimalPrecision"]
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.secondary, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.secondary = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
	end)

	if (classId == nil and specId == nil) or -- Global
		(classId == 2) or -- Paladin
		(classId == 5) or -- Priest
		(classId == 7) or -- Shaman
		(classId == 8) or -- Mage
		(classId == 9) or -- Warlock
		(classId == 10 and specId == 2) or -- Monk Mistweaver
		(classId == 11) or -- Druid
		(classId == 13) -- Evoker
		then
		title = L["ManaDecimalPrecision"]
		controls.precisionMana = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.mana, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.precisionMana:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.precision.mana = value
			TRB.Data.snapshotData.attributes.cacheRefresh = true
		end)
	end

	yCoord = yCoord - 60

	title = L["HealthDecimalPrecision"]
	controls.precisionHealth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.health, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionHealth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.health = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
	end)


	return yCoord
end

function TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, name, spec, classId, specId, yCoord, localization, localizationTooltip, defaultValue, maximumValue)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	
	controls.checkBoxes[name] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Checkbox", parent, "ChatConfigCheckButtonTemplate")

	local f = controls.checkBoxes[name]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(localization)
	f.tooltip = localizationTooltip
	f:SetChecked(spec.audio[name].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio[name].enabled = self:GetChecked()
		if spec.audio[name].enabled then
			PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)
	TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)

	yCoord = yCoord - 60
	return yCoord
end

function TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)
	FillSoundCache()
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.dropDown = controls.dropDown or {}

	controls.dropDown[name .. "Audio"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Audio", parent, "WowStyle1DropdownTemplate")
	local dd = controls.dropDown[name .. "Audio"]
	dd:SetWidth(oUi.sliderWidth)
	dd:SetDefaultText(spec.audio[name].soundName)
	local function IsSelected(value)
		return value == spec.audio[name].sound
	end
	
	local function SetSelected(newValue)
		spec.audio[name].sound = newValue
		spec.audio[name].soundName = soundPairsByName[newValue]
		dd:SetDefaultText(spec.audio[name].soundName)
		PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(soundPairs) do
			rootDescription:CreateRadio(v[1], IsSelected, SetSelected, v[2])
		end
		rootDescription:SetScrollMode(400)

	end
	dd:SetupMenu(Generator)
	dd:SetPoint("TOPLEFT", oUi.xPadding2, yCoord-20)
end

-- Delete-bar-text confirmation dialog.  Defined once (outside GenerateBarTextEditor)
-- so that every spec shares a single dialog whose OnAccept works entirely from the
-- per-invocation data payload — no closure references to the wrong spec's locals.
StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteBarText"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	OnShow = function(self, data)
		self:SetFormattedText(data.message)
		self.data = data
	end,
	OnAccept = function(self)
		local d = self.data
		d.btt:SetSelection()
		table.remove(d.displayText.barText, d.row)
		d.setTableValues(d.displayText, d.btt)
		TRB.Functions.BarText:CreateBarTextFrames(d.classId, d.specId)
		d.barTextOptionsFrame:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
}

---
---@param parent frame
---@param controls table
---@param spec table
---@param classId integer
---@param specId integer
---@param yCoord number
function TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, classId, specId, yCoord, cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local namePrefix = className .. "_" .. specName .. "_barTextEditor"
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
	
	local columns = {
		{
			["name"] = "GUID",
			["width"] = 1,
			["align"] = "CENTER"
		},
		{
			["name"] = "Name",
			["width"] = 100,
			["align"] = "LEFT",
			--[[["color"] = { 
				["r"] = 0.5, 
				["g"] = 0.5, 
				["b"] = 1.0, 
				["a"] = 1.0 
			},
			["colorargs"] = nil,
			["bgcolor"] = {
				["r"] = 1.0, 
				["g"] = 0.0, 
				["b"] = 0.0, 
				["a"] = 1.0 
			}, -- red backgrounds, eww!
			["defaultsort"] = "dsc",
			["sortnext"]= 4,
			["comparesort"] = function (cella, cellb, column)
				return cella.value < cellb.value;
			end,
			["DoCellUpdate"] = nil,]]
		},
		{
			["name"] = "Bound To",
			["width"] = 150,
			["align"] = "LEFT"
		},
		{
			["name"] = "Bar Text",
			["width"] = 320,
			["align"] = "LEFT"
		},
		{
			["name"] = "",
			["width"] = 15,--260,
			["align"] = "CENTER",
			["color"] = {
				["r"] = 1,
				["g"] = 0,
				["b"] = 0,
				["a"] = 1,
			}
		}
	}

	---@type TRB.Classes.Settings.DisplayTextEntry
	---@diagnostic disable-next-line: missing-fields
	local workingBarText = {}

	controls.barTextContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local btc = controls.barTextContainer

	btc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	btc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	btc:SetHeight(120)

	yCoord = yCoord - 105
	local btoHeight = 400
	local barTextTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, btc, false, false)

	-- Dynamically resize "Bar Text" column (index 4) to fill available width
	btc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[5].width
		local newBarTextWidth = math.max(200, w - fixedWidth - 30) -- 30 for internal padding/scrollbar
		columns[4].width = newBarTextWidth
		barTextTable:SetDisplayCols(columns)
	end)
	
	local addButton = TRB.Functions.OptionsUi:BuildButton(parent, L["AddNewBarTextArea"], 0, 0, 175, 25)

	local barTextOptionsFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame", parent, "BackdropTemplate")
	barTextOptionsFrame:SetPoint("TOPLEFT", btc, "BOTTOMLEFT", 0, -10)
	barTextOptionsFrame:SetPoint("TOPRIGHT", btc, "BOTTOMRIGHT", 0, -10)
	barTextOptionsFrame:SetHeight(btoHeight)
	barTextOptionsFrame:Hide()

	-- Place addButton in the same row as Name / Enabled, anchored to top-right of barTextOptionsFrame
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", barTextOptionsFrame, "TOPRIGHT", -5, 5)

	local oldYCoord = yCoord - btoHeight

	yCoord = 0

	local barTextName = TRB.Functions.OptionsUi:BuildTextBox(barTextOptionsFrame, "", 200, 300, 20, oUi.xCoord, yCoord)
---@diagnostic disable-next-line: inject-field
	barTextName.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["Name"], oUi.xCoord, yCoord+25)
	barTextName.label.font:SetFontObject(GameFontNormal)
	
	local barTextEntryEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_TextEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	barTextEntryEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(barTextEntryEnabled:GetName() .. 'Text'):SetText(L["Enabled"])
---@diagnostic disable-next-line: inject-field
	barTextEntryEnabled.tooltip = L["BarTextEntryEnabledTooltip"]

	yCoord = yCoord - 55
	title = L["HorizontalOffset"]
	local barTextHorizontal = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxWidth), math.floor(sanityCheckValues.barMaxWidth), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	barTextHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.xPos = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	title = L["VerticalOffset"]
	local barTextVertical = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxHeight), math.floor(sanityCheckValues.barMaxHeight), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	barTextVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.yPos = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	yCoord = yCoord - 40
	local barTextRelativeToFrame = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeToFrame", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeToFrame:SetWidth(oUi.sliderWidth)
	barTextRelativeToFrame.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["BoundToBar"], oUi.xCoord, yCoord)
	barTextRelativeToFrame.label.font:SetFontObject(GameFontNormal)

	local relativeToFrame = {}
	relativeToFrame[L["MainResourceBar"]] = "Resource"
	relativeToFrame[L["HealthBar"]] = "HealthBar"
	relativeToFrame[L["Screen"]] = "UIParent"
	local relativeToFrameList = {
		L["MainResourceBar"],
		L["HealthBar"],
		L["Screen"],
	}
	
	if (classId == 1 and specId == 3) then -- Protection Warrior
		relativeToFrame[L["IgnorePain"]] = "IgnorePain"
		relativeToFrame[L["ShieldBlock"]] = "ShieldBlock"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["IgnorePain"],
			L["ShieldBlock"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 2) then -- Paladin
		relativeToFrame[L["HolyPower1"]] = "ComboPoint_1"
		relativeToFrame[L["HolyPower2"]] = "ComboPoint_2"
		relativeToFrame[L["HolyPower3"]] = "ComboPoint_3"
		relativeToFrame[L["HolyPower4"]] = "ComboPoint_4"
		relativeToFrame[L["HolyPower5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["HolyPower1"],
			L["HolyPower2"],
			L["HolyPower3"],
			L["HolyPower4"],
			L["HolyPower5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 1) then -- Assassination Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 2) then -- Outlaw Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 3) then -- Subtlety Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["HealthBar"],
			L["Screen"],
		}
	--elseif (classId == 5 and specId == 1) then -- Discipline Priest
	--	relativeToFrame[L["PowerWordRadianceCharge1"]] = "PowerWord_Radiance_1"
	--	relativeToFrame[L["PowerWordRadianceCharge2"]] = "PowerWord_Radiance_2"
	--	relativeToFrameList = {
	--		L["MainResourceBar"],
	--		L["PowerWordRadianceCharge1"],
	--		L["PowerWordRadianceCharge2"],
	--		L["HealthBar"],
	--		L["Screen"],
	--	}
	--elseif (classId == 5 and specId == 2) then -- Holy Priest
	--	relativeToFrame[L["HolyWordSerenityCharge1"]] = "HolyWord_Serenity_1"
	--	relativeToFrame[L["HolyWordSerenityCharge2"]] = "HolyWord_Serenity_2"
	--	relativeToFrame[L["HolyWordSanctifyCharge1"]] = "HolyWord_Sanctify_1"
	--	relativeToFrame[L["HolyWordSanctifyCharge2"]] = "HolyWord_Sanctify_2"
	--	relativeToFrame[L["HolyWordChastiseCharge1"]] = "HolyWord_Chastise_1"
	--	relativeToFrameList = {
	--		L["MainResourceBar"],
	--		L["HolyWordSerenityCharge1"],
	--		L["HolyWordSerenityCharge2"],
	--		L["HolyWordSanctifyCharge1"],
	--		L["HolyWordSanctifyCharge2"],
	--		L["HolyWordChastiseCharge1"],
	--		L["HealthBar"],
	--		L["Screen"],
	--	}
	elseif (classId == 5 and specId == 3) then -- Shadow Priest (mana bar support)
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 6) then -- Death Knight
		relativeToFrame[L["Rune1"]] = "ComboPoint_1"
		relativeToFrame[L["Rune2"]] = "ComboPoint_2"
		relativeToFrame[L["Rune3"]] = "ComboPoint_3"
		relativeToFrame[L["Rune4"]] = "ComboPoint_4"
		relativeToFrame[L["Rune5"]] = "ComboPoint_5"
		relativeToFrame[L["Rune6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Rune1"],
			L["Rune2"],
			L["Rune3"],
			L["Rune4"],
			L["Rune5"],
			L["Rune6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 7 and specId == 1) then -- Elemental Shaman (mana bar support)
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 7 and specId == 2) then -- Enhancement Shaman
		relativeToFrame[L["Maelstrom1"]] = "ComboPoint_1"
		relativeToFrame[L["Maelstrom2"]] = "ComboPoint_2"
		relativeToFrame[L["Maelstrom3"]] = "ComboPoint_3"
		relativeToFrame[L["Maelstrom4"]] = "ComboPoint_4"
		relativeToFrame[L["Maelstrom5"]] = "ComboPoint_5"
		relativeToFrame[L["Maelstrom6"]] = "ComboPoint_6"
		relativeToFrame[L["Maelstrom7"]] = "ComboPoint_7"
		relativeToFrame[L["Maelstrom8"]] = "ComboPoint_8"
		relativeToFrame[L["Maelstrom9"]] = "ComboPoint_9"
		relativeToFrame[L["Maelstrom10"]] = "ComboPoint_10"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Maelstrom1"],
			L["Maelstrom2"],
			L["Maelstrom3"],
			L["Maelstrom4"],
			L["Maelstrom5"],
			L["Maelstrom6"],
			L["Maelstrom7"],
			L["Maelstrom8"],
			L["Maelstrom9"],
			L["Maelstrom10"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 8 and specId == 1) then -- Arcane Mage
		relativeToFrame[L["ArcaneCharge1"]] = "ComboPoint_1"
		relativeToFrame[L["ArcaneCharge2"]] = "ComboPoint_2"
		relativeToFrame[L["ArcaneCharge3"]] = "ComboPoint_3"
		relativeToFrame[L["ArcaneCharge4"]] = "ComboPoint_4"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ArcaneCharge1"],
			L["ArcaneCharge2"],
			L["ArcaneCharge3"],
			L["ArcaneCharge4"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 9) then -- Warlock
		relativeToFrame[L["SoulShard1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulShard2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulShard3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulShard4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulShard5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulShard1"],
			L["SoulShard2"],
			L["SoulShard3"],
			L["SoulShard4"],
			L["SoulShard5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 10 and specId == 1) then -- Brewmaster Monk
		relativeToFrame[L["Stagger"]] = "ComboPoint_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Stagger"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 10 and specId == 3) then -- Windwalker Monk
		relativeToFrame[L["Chi1"]] = "ComboPoint_1"
		relativeToFrame[L["Chi2"]] = "ComboPoint_2"
		relativeToFrame[L["Chi3"]] = "ComboPoint_3"
		relativeToFrame[L["Chi4"]] = "ComboPoint_4"
		relativeToFrame[L["Chi5"]] = "ComboPoint_5"
		relativeToFrame[L["Chi6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Chi1"],
			L["Chi2"],
			L["Chi3"],
			L["Chi4"],
			L["Chi5"],
			L["Chi6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 11 and specId == 1) then -- Balance Druid (mana bar support)
		relativeToFrame[L["AstralPowerBar"]] = "AstralPowerBar"
		relativeToFrame[L["RageBar"]] = "RageBar"
		relativeToFrame[L["EnergyBar"]] = "EnergyBar"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["AstralPowerBar"],
			L["RageBar"],
			L["EnergyBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 11 and specId > 1 and specId <= 4) then -- Non-Balance Druid
		relativeToFrame[L["RageBar"]] = "RageBar"
		relativeToFrame[L["EnergyBar"]] = "EnergyBar"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["RageBar"],
			L["EnergyBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 2) then -- Vengeance Demon Hunter
		relativeToFrame[L["SoulFragment1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulFragment2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulFragment3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulFragment4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulFragment5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragment1"],
			L["SoulFragment2"],
			L["SoulFragment3"],
			L["SoulFragment4"],
			L["SoulFragment5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 3) then -- Devourer Demon Hunter
		relativeToFrame[L["SoulFragments"]] = "ComboPoint_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragments"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 13) then -- Evoker
		relativeToFrame[L["Essence1"]] = "ComboPoint_1"
		relativeToFrame[L["Essence2"]] = "ComboPoint_2"
		relativeToFrame[L["Essence3"]] = "ComboPoint_3"
		relativeToFrame[L["Essence4"]] = "ComboPoint_4"
		relativeToFrame[L["Essence5"]] = "ComboPoint_5"
		relativeToFrame[L["Essence6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Essence1"],
			L["Essence2"],
			L["Essence3"],
			L["Essence4"],
			L["Essence5"],
			L["Essence6"],
			L["HealthBar"],
			L["Screen"],
		}
	end

	local function RelativeToFrameIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeToFrame
		else
			return false
		end
	end
	
	local function RelativeToFrameSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeToFrame = newValue
			
			for k, v in pairs(relativeToFrame) do
				if v == newValue then
					workingBarText.position.relativeToFrameName = k
				end
			end
			barTextRelativeToFrame:SetDefaultText(workingBarText.position.relativeToFrameName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function RelativeToFrameGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToFrameList) do
			rootDescription:CreateRadio(v, RelativeToFrameIsSelected, RelativeToFrameSetSelected, relativeToFrame[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
	barTextRelativeToFrame:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
	
	local barTextRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeTo", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeTo:SetWidth(oUi.sliderWidth)
	barTextRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextRelativeTo.label.font:SetFontObject(GameFontNormal)
	
	local relativeTo = {}
	relativeTo[L["PositionTopLeft"]] = "TOPLEFT"
	relativeTo[L["PositionTop"]] = "TOP"
	relativeTo[L["PositionTopRight"]] = "TOPRIGHT"
	relativeTo[L["PositionLeft"]] = "LEFT"
	relativeTo[L["PositionCenter"]] = "CENTER"
	relativeTo[L["PositionRight"]] = "RIGHT"
	relativeTo[L["PositionBottomLeft"]] = "BOTTOMLEFT"
	relativeTo[L["PositionBottom"]] = "BOTTOM"
	relativeTo[L["PositionBottomRight"]] = "BOTTOMRIGHT"
	local relativeToList = {
		L["PositionTopLeft"],
		L["PositionTop"],
		L["PositionTopRight"],
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
		L["PositionBottomLeft"],
		L["PositionBottom"],
		L["PositionBottomRight"]
	}

	local function RelativeToIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeTo
		else
			return false
		end
	end
	
	local function RelativeToSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeTo = newValue
			
			for k, v in pairs(relativeTo) do
				if v == newValue then
					workingBarText.position.relativeToName = k
				end
			end
			barTextRelativeTo:SetDefaultText(workingBarText.position.relativeToName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeTo:SetupMenu(RelativeToGenerator)
	barTextRelativeTo:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)

	yCoord = yCoord - 60

	controls.colors.text = controls.colors.text or {}
	
	FillFontCache()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFace", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)
	
	local function FontFaceIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontFace
		else
			return false
		end
	end
	
	local function FontFaceSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontFace = newValue
			workingBarText.fontFaceName = fontPairsByName[newValue]
			barTextFontFace:SetDefaultText(workingBarText.fontFaceName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local useDefaultFontFace = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontFace", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontFace:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontFace:GetName() .. 'Text'):SetText(L["UseDefaultFontFace"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontFace.tooltip = L["UseDefaultFontFaceTooltip"]
	useDefaultFontFace:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontFace = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)


	local barTextFontJustifyHorizontal = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextFontJustifyHorizontal", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontJustifyHorizontal:SetWidth(oUi.sliderWidth)
	barTextFontJustifyHorizontal.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextFontJustifyHorizontal.label.font:SetFontObject(GameFontNormal)
	
	local fontJustifyHorizontal = {}
	fontJustifyHorizontal[L["PositionLeft"]] = "LEFT"
	fontJustifyHorizontal[L["PositionCenter"]] = "CENTER"
	fontJustifyHorizontal[L["PositionRight"]] = "RIGHT"
	local fontJustifyHorizontalList = {
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
	}

	local function FontJustifyHorizontalIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontJustifyHorizontal
		else
			return false
		end
	end
	
	local function FontJustifyHorizontalSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontJustifyHorizontal = newValue
			
			for k, v in pairs(fontJustifyHorizontal) do
				if v == newValue then
					workingBarText.fontJustifyHorizontalName = k
				end
			end
			barTextFontJustifyHorizontal:SetDefaultText(workingBarText.fontJustifyHorizontalName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
	end

	local function FontJustifyHorizontalGenerator(dropdown, rootDescription)
		for k, v in pairs(fontJustifyHorizontalList) do
			rootDescription:CreateRadio(v, FontJustifyHorizontalIsSelected, FontJustifyHorizontalSetSelected, fontJustifyHorizontal[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)
	barTextFontJustifyHorizontal:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	
	yCoord = yCoord - 100
	title = L["FontSize"]
	local fontSize = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, 6, 300, 18, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontSize:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	local useDefaultFontSize = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontSize", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontSize:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-40)
	getglobal(useDefaultFontSize:GetName() .. 'Text'):SetText(L["UseDefaultFontSize"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontSize.tooltip = L["UseDefaultFontSizeTooltip"]
	useDefaultFontSize:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontSize = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	controls.colors = controls.colors or {}
	controls.colors.barText = controls.colors.barText or {}
	controls.colors.barText.color = TRB.Functions.OptionsUi:BuildColorPicker(barTextOptionsFrame, L["FontColor"], (workingBarText.color and workingBarText.color.color) or "FFFFFFFF",
																			oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	local barTextColor = controls.colors.barText.color
	barTextColor:SetScript("OnMouseDown", function(self, button, ...)
		-- Ensure color table is properly initialized before opening color picker
		--[[if workingBarText.color == nil then
			workingBarText.color = { color = "FFFFFFFF" }
		elseif type(workingBarText.color) == "string" then
			workingBarText.color = { color = workingBarText.color }
		elseif workingBarText.color.color == nil then
			workingBarText.color.color = "FFFFFFFF"
		end]]
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, workingBarText, controls.colors.barText, "color")
	end)

	local useDefaultFontColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontColor", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontColor:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(useDefaultFontColor:GetName() .. 'Text'):SetText(L["UseDefaultFontColor"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontColor.tooltip = L["UseDefaultFontColorTooltip"]
	useDefaultFontColor:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontColor = self:GetChecked()
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)


	yCoord = yCoord - 70
	controls.labels.barText = TRB.Functions.OptionsUi:BuildLabel(barTextOptionsFrame, L["BarText"], oUi.xCoord, yCoord, 90, 20)

	yCoord = yCoord - 20
	local barText = TRB.Functions.OptionsUi:CreateBarTextInputPanel(barTextOptionsFrame, namePrefix .. "_Text", "",
													590, 45, oUi.xCoord, yCoord)
	-- Make editbox scroll frame fill the parent width (accounting for scrollbar buttons)
	local barTextScrollFrame = barText:GetParent() --[[@as Frame]]
	barTextScrollFrame:ClearAllPoints()
	barTextScrollFrame:SetPoint("TOPLEFT", barTextOptionsFrame, "TOPLEFT", oUi.xCoord, yCoord)
	barTextScrollFrame:SetPoint("RIGHT", barTextOptionsFrame, "RIGHT", -30, 0)
	barText:SetCursorPosition(0)

	-- When the bar text editor frame is shown (selecting/adding a bar text area),
	-- mark the EditBox as active so the side panel "+" buttons turn green.
	barTextOptionsFrame:HookScript("OnShow", function()
		TRB.Frames.activeBarTextEditBox = barText
		TRB.Frames.activeBarTextCursorPosition = barText:GetCursorPosition()
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	-- When the bar text editor frame is hidden (deleting a bar text area or switching panels),
	-- clear the active EditBox so the "+" buttons revert to gray/disabled.
	barTextOptionsFrame:HookScript("OnHide", function()
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	---@param displayText TRB.Classes.Settings.DisplayText
	---@param btt table # LibScrollingTable
	local function SetTableValues(displayText, btt)
		local dataTable = {}
		local entries = TRB.Functions.Table:Length(displayText.barText)
		if entries > 0 then
			for i = 1, entries do
				local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(displayText.barText[i].color.color, true)
				table.insert(dataTable, {
					cols = {
						{
							value = displayText.barText[i].guid
						},
						{
							value = displayText.barText[i].name,
						},
						{
							value = displayText.barText[i].position.relativeToFrameName,
						},
						{
							value = displayText.barText[i].text,
						},
						{
							value = "X",
						}
					}
				})
			end
		end
		btt:SetData(dataTable)
		btt:EnableSelection(true)
	end

	---@return TRB.Classes.Settings.DisplayTextEntry
	local function GetNewDisplayTextEntry()
		return {
			enabled = true,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontColor = false,
			name = L["NewBarTextEntry"],
			text = "",
			guid = TRB.Functions.String:Guid(),
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	end

	---@param guid string
	---@param dt TRB.Classes.Settings.DisplayText
	local function FillBarTextEditorFields(guid, dt)
		local found = false
		local e = TRB.Functions.Table:Length(dt.barText)
		if e > 0 then
			for i = 1, e do
				if dt.barText[i].guid == guid then
					workingBarText = dt.barText[i]
					found = true
					break
				end
			end
		end

		if not found then
			return
		end

		barTextName:SetText(workingBarText.name)
		barTextEntryEnabled:SetChecked(workingBarText.enabled)
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		
		barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
		barTextRelativeTo:SetupMenu(RelativeToGenerator)
		barTextFontFace:SetupMenu(FontFaceGenerator)
		barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)

		fontSize:SetValue(workingBarText.fontSize)
		barTextColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString((workingBarText.color and workingBarText.color.color) or "FFFFFFFF", true))
		barText:SetText(workingBarText.text)
		-- Reset undo history so the newly loaded text is the baseline
		if barText.ResetUndoHistory then
			barText:ResetUndoHistory(workingBarText.text)
		end

		TRB.Functions.OptionsUi:EditBoxSetTextMinMax(barTextHorizontal, workingBarText.position.xPos)
		TRB.Functions.OptionsUi:EditBoxSetTextMinMax(barTextVertical, workingBarText.position.yPos)
		
		useDefaultFontColor:SetChecked(workingBarText.useDefaultFontColor)
		useDefaultFontFace:SetChecked(workingBarText.useDefaultFontFace)
		useDefaultFontSize:SetChecked(workingBarText.useDefaultFontSize)
		
		barTextOptionsFrame:Show()
	end

	SetTableValues(spec.displayText, barTextTable)

	addButton:SetScript("OnClick", function(self, ...)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		local newEntry = GetNewDisplayTextEntry()
		table.insert(displayText.barText, newEntry)
		SetTableValues(displayText, barTextTable)
		barTextTable:SetSelection(TRB.Functions.Table:Length(displayText.barText))
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		FillBarTextEditorFields(newEntry.guid, displayText)
	end)
	
	barTextEntryEnabled:SetScript("OnClick", function(self, ...)
		workingBarText.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	barTextName:SetScript("OnTextChanged", function(self, input)
		workingBarText.name = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
	end)

	barText:SetScript("OnTextChanged", function(self, input)
		workingBarText.text = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
		TRB.Data.cache.barText = {}
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
	end)

	-- Attach undo/redo AFTER SetScript("OnTextChanged") so the HookScript
	-- recording handler is guaranteed to persist.
	AttachUndoRedo(barText)

	barTextTable:RegisterEvents({
		OnClick = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				local currentSelection = scrollingTable:GetSelection()

				if realrow ~= nil and realrow > 0 then
					local guid = data[realrow].cols[1].value

					if column == 5 then
						StaticPopup_Show("TwintopResourceBar_ConfirmDeleteBarText", nil, nil, {
							message = string.format(L["BarTextDeleteConfirmation"], data[realrow].cols[2].value),
							displayText = spec.displayText,
							row = realrow,
							btt = scrollingTable,
							classId = classId,
							specId = specId,
							barTextOptionsFrame = barTextOptionsFrame,
							setTableValues = SetTableValues,
						})
					else
						FillBarTextEditorFields(guid, spec.displayText)
						C_Timer.After(0, function()
							C_Timer.After(0.05, function()
								local newSelection = scrollingTable:GetSelection()

								if newSelection == nil then
									barTextTable:SetSelection(currentSelection)
								end
							end)
						end)
					end
				end
			end
		end
	})

	local function ResetTableValues(barText)
		spec.displayText.barText = barText
		TRB.Data.specCache[compositeKey].settings.displayText.barText = barText
		SetTableValues(spec.displayText, barTextTable)
		_G["TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame"]:Hide()
		
		if classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
			TRB.Data.cache.barText = {}
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			-- Hide all existing bar text frames before recreating to prevent stale text from persisting
			TRB.Functions.BarText:Hide(spec)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		end
		TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	end

	controls.barTextFields = {}
	controls.barTextFields.barTextTable = barTextTable
	controls.barTextFields.ResetTableValues = ResetTableValues

	yCoord = oldYCoord
	local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix, cache, classId, specId)
	-- Tag the scroll child's ancestor (the tabsheet parent) so SwitchTab/SelectCategory can find the right panel
	---@diagnostic disable-next-line: inject-field
	parent.barTextVariablesPanel = variablesPanel
	TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
end
