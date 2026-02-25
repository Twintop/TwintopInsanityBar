local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Mage = {}
TRB.Options.Mage.Arcane = {}
TRB.Options.Mage.Fire = {}
TRB.Options.Mage.Frost = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.mage_arcane = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.mage_fire = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost = {}

-- Arcane
---Loads default bar text settings for Arcane
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ArcaneLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Mage.ArcaneLoadDefaultBarTextSettings = ArcaneLoadDefaultBarTextSettings

---Loads default settings for Arcane
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ArcaneLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true, absorbMode = "appended", showAbsorb = true },
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
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
				}
			},
			bar = {
				border = {
					color = "FF000099"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0000FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF00AAFF"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF1A1AFA"
				},
				penultimate = {
					color = "FFFF9900"
				},
				final = {
					color = "FFFF0000"
				},
				sameColor=true
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
			},
			barText = {}
		},
		audio = {
			arcaneChargeThreshold1={
				name = L["MageAudioArcaneChargeThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 2
				}
			},
			arcaneChargeThreshold2={
				name = L["MageAudioArcaneChargeThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 4
				}
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = ArcaneLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Fire
---Loads default bar text settings for Fire
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FireLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Mage.FireLoadDefaultBarTextSettings = FireLoadDefaultBarTextSettings

---Loads default settings for Fire
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function FireLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true, absorbMode = "appended", showAbsorb = true },
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
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
				}
			},
			bar = {
				border = {
					color = "FF000099"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0000FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = FireLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Frost
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FrostLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Mage.FrostLoadDefaultBarTextSettings = FrostLoadDefaultBarTextSettings

---Loads default settings for Frost
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function FrostLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true, absorbMode = "appended", showAbsorb = true },
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
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
				}
			},
			bar = {
				border = {
					color = "FF000099"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0000FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF0071DF"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF55E2FF"
				},
				penultimate = {
					color = "FFFF9900"
				},
				final = {
					color = "FFFF0000"
				},
				sameColor = false
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = {
					color = "FFFFFFFF"
				},
			},
			barText = {}
		},
		audio = {
			iciclesThreshold1 = {
				name = L["MageAudioIciclesThreshold1"],
				enabled = false,
				sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = FrostLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Mage
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.mage.arcane = ArcaneLoadDefaultSettings(includeBarText, classic)
	settings.mage.fire = FireLoadDefaultSettings(includeBarText, classic)
	settings.mage.frost = FrostLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Mage.LoadDefaultSettings = LoadDefaultSettings


--[[

Arcane Option Menus

]]

local function ArcaneConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mage_arcane
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Mage_Arcane_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MageArcaneFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.arcane = ArcaneLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Arcane_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MageArcaneFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.arcane = ArcaneLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Arcane_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MageArcaneFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ArcaneLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Arcane_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MageArcaneFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ArcaneLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ArcaneConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 8, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], false, true)
end

local function ArcaneConstructArcaneChargesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], L["ResourceArcaneCharges"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MageArcaneChargesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceArcaneCharges"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerArcaneChargesBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageArcaneChargesColorPickerPenultimate"], spec.colors.comboPoints.penultimate.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageArcaneChargesColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageArcaneChargesColorPickerFinal"], spec.colors.comboPoints.final.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Mage_Arcane_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MageArcaneChargesCheckboxUseHighestForAll"])
	f.tooltip = L["MageArcaneChargesCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)
end

local function ArcaneConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 8, 1, yCoord)
end

local function ArcaneConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 8, 1, yCoord, true, L["ResourceArcaneCharges"])
end

local function ArcaneConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceArcaneCharges"], true)
end

local function ArcaneConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Mage_Arcane_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Mage_Arcane_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageArcaneFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 8, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 8, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 8, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 1, yCoord)
end

local function ArcaneConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 1
	local spec = TRB.Data.settings.mage.arcane

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Mage_Arcane_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Mage_Arcane_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageArcaneFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 8, 1, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "arcaneChargeThreshold1", spec, classId, specId, yCoord, L["MageAudioCheckboxArcaneChargeThreshold1"], L["MageAudioCheckboxArcaneChargeThreshold1Tooltip"])

	controls.mage_arcaneChargeThreshold1Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["MageArcaneChargeThresholdSliderTitle"], 0, 4, spec.audio["arcaneChargeThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.mage_arcaneChargeThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["arcaneChargeThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "arcaneChargeThreshold2", spec, classId, specId, yCoord, L["MageAudioCheckboxArcaneChargeThreshold2"], L["MageAudioCheckboxArcaneChargeThreshold2Tooltip"])

	controls.mage_arcaneChargeThreshold2Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["MageArcaneChargeThresholdSliderTitle"], 0, 4, spec.audio["arcaneChargeThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.mage_arcaneChargeThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["arcaneChargeThreshold2"].configuration.thresholdValue = value
	end)
end

local function ArcaneConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Mage_Arcane_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Mage_Arcane_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageArcaneFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 8, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 8, 1, yCoord, cache)
end

local function ArcaneConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(8, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.mage_arcane or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.arcaneDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Mage_Arcane")
	TRB.Options.OptionsFrame:RegisterSpecPanel("mage", "mage_arcane", L["MageArcaneFull"], interfaceSettingsFrame.arcaneDisplayPanel)
	
	parent = interfaceSettingsFrame.arcaneDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["MageArcaneFull"],
		TRB.Data.settings.core.enabled.mage, "arcane",
		"TwintopResourceBar_Mage_Arcane_arcaneMageEnabled", "arcaneMageEnabled",
		"exportButton_Mage_Arcane_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageArcaneFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 8, 1, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_arcane = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = ArcaneConstructManaBarPanel },
		{ key = "arcaneChargesBar", label = L["TabArcaneCharges"], width = oUi.tabWidth.small, constructor = ArcaneConstructArcaneChargesPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = ArcaneConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = ArcaneConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = ArcaneConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = ArcaneConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = ArcaneConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) ArcaneConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = ArcaneConstructResetDefaultsPanel },
	}, yCoord)
end


-- Fire Option Menus
local function FireConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mage_fire
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Mage_Fire_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MageFireFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.fire = FireLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Fire_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MageFireFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.fire = FireLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Fire_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MageFireFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FireLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Fire_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MageFireFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FireLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FireConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 8, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"], false, false)
end

local function FireConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 8, 2, yCoord)
end

local function FireConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 8, 2, yCoord)
end

local function FireConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)
end

local function FireConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Mage_Fire_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Mage_Fire_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFireFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 8, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 8, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 8, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 2, yCoord)
end

local function FireConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 2
	local spec = TRB.Data.settings.mage.fire

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Mage_Fire_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Mage_Fire_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFireFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 8, 2, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function FireConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Mage_Fire_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Mage_Fire_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFireFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 8, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 8, 2, yCoord, cache)
end

local function FireConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(8, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.mage_fire or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.fireDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Mage_Fire")
	TRB.Options.OptionsFrame:RegisterSpecPanel("mage", "mage_fire", L["MageFireFull"], interfaceSettingsFrame.fireDisplayPanel)
	
	parent = interfaceSettingsFrame.fireDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["MageFireFull"],
		TRB.Data.settings.core.enabled.mage, "fire",
		"TwintopResourceBar_Mage_Fire_fireMageEnabled", "fireMageEnabled",
		"exportButton_Mage_Fire_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFireFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 8, 2, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_fire = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = FireConstructManaBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FireConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = FireConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = FireConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = FireConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) FireConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = FireConstructResetDefaultsPanel },
	}, yCoord)
end

-- Frost Option Menus
local function FrostConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Mage_Frost_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["MageFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.frost = FrostLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Frost_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["MageFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.mage.frost = FrostLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Frost_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["MageFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FrostLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Mage_Frost_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["MageFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FrostLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FrostConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 8, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], false, false)
end

local function FrostConstructIciclesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], L["ResourceIcicles"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MageFrostIciclesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageFrostColorPickerIciclesBase"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageFrostColorPickerIciclesBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageFrostColorPickerIciclesPenultimate"], spec.colors.comboPoints.penultimate.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageFrostColorPickerIciclesBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageFrostColorPickerIciclesFinal"], spec.colors.comboPoints.final.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Mage_Frost_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MageFrostCheckboxSameColorIcicles"])
	f.tooltip = L["MageFrostCheckboxSameColorIciclesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sameColor = self:GetChecked()
	end)
end

local function FrostConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 8, 3, yCoord)
end

local function FrostConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 8, 3, yCoord, true, L["ResourceIcicles"])
end

local function FrostConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceIcicles"], true)
end

local function FrostConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Mage_Frost_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Mage_Frost_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFrostFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 8, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 8, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 8, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 3, yCoord)
end

local function FrostConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 8
	local specId = 3
	local spec = TRB.Data.settings.mage.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Mage_Frost_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Mage_Frost_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFrostFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 8, 3, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "iciclesThreshold1", spec, classId, specId, yCoord, L["MageAudioCheckboxIciclesThreshold1"], L["MageAudioCheckboxIciclesThreshold1Tooltip"])
	controls.mage_iciclesThreshold1Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["MageIciclesThresholdSliderTitle"], 0, 5, spec.audio["iciclesThreshold1"].configuration.thresholdValue, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.mage_iciclesThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		local newValue = value
		spec.audio["iciclesThreshold1"].configuration.thresholdValue = newValue
		self:SetValue(newValue)
	end)

	yCoord = yCoord - 60
end

local function FrostConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Mage_Frost_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Mage_Frost_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFrostFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 8, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 8, 3, yCoord, cache)
end

local function FrostConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(8, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.mage_frost or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.frostDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Mage_Frost")
	TRB.Options.OptionsFrame:RegisterSpecPanel("mage", "mage_frost", L["MageFrostFull"], interfaceSettingsFrame.frostDisplayPanel)
	
	parent = interfaceSettingsFrame.frostDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["MageFrostFull"],
		TRB.Data.settings.core.enabled.mage, "frost",
		"TwintopResourceBar_Mage_Frost_frostMageEnabled", "frostMageEnabled",
		"exportButton_Mage_Frost_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["MageFrostFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 8, 3, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = FrostConstructManaBarPanel },
		{ key = "iciclesBar", label = L["TabIcicles"], width = oUi.tabWidth.small, constructor = FrostConstructIciclesBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FrostConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = FrostConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = FrostConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = FrostConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = FrostConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) FrostConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = FrostConstructResetDefaultsPanel },
	}, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("mage", L["Mage"])

	ArcaneConstructOptionsPanel(specCache.mage_arcane)
	FireConstructOptionsPanel(specCache.mage_fire)
	FrostConstructOptionsPanel(specCache.mage_frost)

	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Mage.ConstructOptionsPanel = ConstructOptionsPanel
