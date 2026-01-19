local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on a Warlock!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Warlock = {}
TRB.Options.Warlock.Affliction = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.affliction = {}

--Affliction
---Loads default bar text settings for Affliction
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function AfflictionLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Warlock.AfflictionLoadDefaultBarTextSettings = AfflictionLoadDefaultBarTextSettings

---Loads default settings for Affliction
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function AfflictionLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF4D4DFF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
			},
			bar = {
				border="FF000099",
				background="66000000",
				base="FF0000FF",
			},
				comboPoints = {
				border="FF4749B5",
				background="66000000",
				base="FF8788EE",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
				consistentUnfilledColor = false,
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = AfflictionLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Demonology
---Loads default bar text settings for Demonology
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DemonologyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Warlock.DemonologyLoadDefaultBarTextSettings = DemonologyLoadDefaultBarTextSettings

---Loads default settings for Demonology
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function DemonologyLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF4D4DFF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
			},
			bar = {
				border="FF000099",
				background="66000000",
				base="FF0000FF"
			},
			comboPoints = {
				border="FF4749B5",
				background="66000000",
				base="FF8788EE",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=14,
				color="FFFFFFFF",
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = DemonologyLoadDefaultBarTextSettings(classic)
	end

	return settings
end
TRB.Options.Warlock.DemonologyLoadDefaultSettings = DemonologyLoadDefaultSettings

-- Destruction
---Loads default bar text settings for Destruction
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DestructionLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Warlock.DestructionLoadDefaultBarTextSettings = DestructionLoadDefaultBarTextSettings

---Loads default settings for Destruction
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function DestructionLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 0,
			resource = 0
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF4D4DFF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
			},
			bar = {
				border="FF000099",
				background="66000000",
				base="FF0000FF",
			},
			comboPoints = {
				border="FF4749B5",
				background="66000000",
				base="FF8788EE",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				unusable = {
					color = "FFFF0000"
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			}
		},
		displayText={
			default = {
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = DestructionLoadDefaultBarTextSettings(classic)
	end

	return settings
end
TRB.Options.Warlock.DestructionLoadDefaultSettings = DestructionLoadDefaultSettings

---Loads default settings for Warlock
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.warlock.affliction = AfflictionLoadDefaultSettings(includeBarText, classic)
	settings.warlock.demonology = DemonologyLoadDefaultSettings(includeBarText, classic)
	settings.warlock.destruction = DestructionLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Warlock.LoadDefaultSettings = LoadDefaultSettings

--[[

Affliction Option Menus

]]

local function AfflictionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.affliction
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.affliction = AfflictionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.affliction = AfflictionLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AfflictionLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AfflictionLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function AfflictionConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warlock_Affliction_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 9, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 9, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"], L["ResourceSoulShards"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 9, 1, yCoord, true, L["ResourceSoulShards"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceSoulShards"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceSoulShards"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxUseHighestForAll"])
	f.tooltip = L["WarlockSoulShardsCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsBorderColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerSoulShardsBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["WarlockSoulShardsCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 9, 1, yCoord)
end

local function AfflictionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warlock_Affliction_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 9, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 9, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 9, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 9, 1, yCoord)
end

local function AfflictionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 9
	local specId = 1
	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5

	controls.buttons.exportButton_Warlock_Affliction_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end


local function AfflictionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warlock_Affliction_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 9, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 9, 1, yCoord, cache)
end

local function AfflictionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(9, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warlock or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.afflictionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warlock_Affliction", UIParent)
	interfaceSettingsFrame.afflictionDisplayPanel.name = L["WarlockAfflictionFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.afflictionDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["affliction"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.afflictionDisplayPanel, L["WarlockAfflictionFull"])
	
	parent = interfaceSettingsFrame.afflictionDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockAfflictionFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.afflictionWarlockEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_afflictionWarlockEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.afflictionWarlockEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarlockAfflictionFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.warlock.affliction)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.warlock.affliction = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.afflictionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.affliction, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.afflictionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.affliction, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Warlock_Affliction_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Warlock_Affliction_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 9, 1, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	--[[
		This spec doesn't use Threshold Lines. Make the width 1 instead of 100
	]]
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 1, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	--[[
		This spec doesn't use Threshold Lines. Make the width 1 instead of 100
	]]
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 1, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking. Don't let these tabs be made/rendered.
		]]
		if i == 2 or i == 4 then
			tabs[i]:Hide()
		else
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		end
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.affliction = controls

	AfflictionConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--AfflictionConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	AfflictionConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--AfflictionConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	AfflictionConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	AfflictionConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end



local function DemonologyConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.demonology

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonology
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warlock_Demonology_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Demonology_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDemonologyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 9, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 9, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 9, 2, yCoord, L["ResourceMana"], L["ResourceSoulShards"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 9, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 9, 2, yCoord, true, L["ResourceSoulShards"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 9, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceSoulShards"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 9, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 9, 2, yCoord, L["ResourceMana"], false)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceSoulShards"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Demonology_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxUseHighestForAll"])
	f.tooltip = L["WarlockSoulShardsCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsBorderColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerSoulShardsBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Demonology_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["WarlockSoulShardsCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 9, 2, yCoord)
end

local function DemonologyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.demonology

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonology
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warlock_Demonology_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Demonology_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDemonologyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 9, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 9, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 9, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 9, 2, yCoord)
end

local function DemonologyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 9
	local specId = 2
	local spec = TRB.Data.settings.warlock.demonology

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonology
	local yCoord = 5

	controls.buttons.exportButton_Warlock_Demonology_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Demonology_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDemonologyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function DemonologyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.demonology
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.demonology
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warlock_Demonology_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Demonology_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDemonologyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 9, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 9, 2, yCoord, cache)
end

local function DemonologyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.demonology

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.demonology
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warlock_Demonology_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarlockDemonologyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.demonology = DemonologyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Demonology_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarlockDemonologyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.demonology = DemonologyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Demonology_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarlockDemonologyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DemonologyLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Demonology_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarlockDemonologyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DemonologyLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Demonology_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Demonology_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Demonology_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Demonology_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function DemonologyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(9, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warlock or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.demonologyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_".. namePrefix, UIParent)
	interfaceSettingsFrame.demonologyDisplayPanel.name = L["WarlockDemonologyFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.demonologyDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["demonology"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.demonologyDisplayPanel, L["WarlockDemonologyFull"])
	
	parent = interfaceSettingsFrame.demonologyDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockDemonologyFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.demonologyWarlockEnabled = CreateFrame("CheckButton", "TwintopResourceBar" .. namePrefix .. "_demonologyWarlockEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.demonologyWarlockEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarlockDemonologyFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.warlock.demonology)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.warlock.demonology = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.demonologyWarlockEnabled, TRB.Data.settings.core.enabled.warlock.demonology, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.demonologyWarlockEnabled, TRB.Data.settings.core.enabled.warlock.demonology, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Warlock_Demonology_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Warlock_Demonology_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDemonologyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 9, 2, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	--[[
		This spec doesn't use Threshold Lines. Make the width 1 instead of 100
	]]
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 1, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	--[[
		This spec doesn't use Audio & Tracking. Make the width 1 instead of 120
	]]
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 1, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking. Don't let these tabs be made/rendered.
		]]
		if i == 2 or i == 4 then
			tabs[i]:Hide()
		else
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		end
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.demonology = controls

	DemonologyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--DemonologyConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DemonologyConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--DemonologyConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DemonologyConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DemonologyConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function DestructionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.destruction

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.destruction
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warlock_Destruction_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarlockDestructionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.destruction = DestructionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Destruction_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarlockDestructionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.destruction = DestructionLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Destruction_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarlockDestructionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DestructionLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Destruction_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarlockDestructionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DestructionLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Destruction_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Destruction_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Destruction_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Destruction_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function DestructionConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.destruction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.destruction
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warlock_Destruction_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Destruction_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDestructionFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 9, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 9, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 9, 3, yCoord, L["ResourceMana"], L["ResourceSoulShards"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 9, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 9, 3, yCoord, true, L["ResourceSoulShards"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 9, 3, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceSoulShards"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 9, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 9, 3, yCoord, L["ResourceMana"], false)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceSoulShards"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Destruction_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxUseHighestForAll"])
	f.tooltip = L["WarlockSoulShardsCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Destruction_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["WarlockSoulShardsCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 9, 3, yCoord)
end

local function DestructionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.destruction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.destruction
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warlock_Destruction_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Destruction_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDestructionFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 9, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 9, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 9, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)
end

local function DestructionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.destruction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.destruction
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warlock_Destruction_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Destruction_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDestructionFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 9, 3, false, false, false, true, false, false)
	end)

	controls.textAudioSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
end

local function DestructionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.destruction
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.destruction
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warlock_Destruction_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Destruction_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDestructionFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 9, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 9, 3, yCoord, cache)
end

local function DestructionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(9, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.destruction or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.destructionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_".. namePrefix, UIParent)
	interfaceSettingsFrame.destructionDisplayPanel.name = L["WarlockDestructionFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.destructionDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["destruction"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.destructionDisplayPanel, L["WarlockDestructionFull"])
	
	parent = interfaceSettingsFrame.destructionDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockDestructionFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.destructionWarlockEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .. "_destructionWarlockEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.destructionWarlockEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarlockDestructionFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.warlock.destruction)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.warlock.destruction = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.destructionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.destruction, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.destructionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.destruction, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Warlock_Destruction_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Warlock_Destruction_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockDestructionFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 9, 3, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	--[[
		This spec doesn't use Threshold Lines. Make the width 1 instead of 100
	]]
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 1, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	--[[
		This spec doesn't use Audio & Tracking. Make the width 1 instead of 120
	]]
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 1, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking. Don't let these tabs be made/rendered.
		]]
		if i == 2 or i == 4 then
			tabs[i]:Hide()
		else
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_".. namePrefix .. "_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		end
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.destruction = controls

	DestructionConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--DestructionConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DestructionConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--DestructionConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DestructionConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DestructionConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	
	AfflictionConstructOptionsPanel(specCache.affliction)
	DemonologyConstructOptionsPanel(specCache.demonology)
	DestructionConstructOptionsPanel(specCache.destruction)
end
TRB.Options.Warlock.ConstructOptionsPanel = ConstructOptionsPanel