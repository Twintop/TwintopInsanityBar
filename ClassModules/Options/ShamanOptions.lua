local _, TRB = ...
if TRB.Data.character.classId ~= 7 then --Only do this if we're on a Shaman!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Shaman = {}
TRB.Options.Shaman.Elemental = {}
TRB.Options.Shaman.Enhancement = {}
TRB.Options.Shaman.Restoration = {}

TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = {}

local ELEMENTAL_MAX_MAELSTROM = 175

-- Elemental

---Loads default bar text settings for Elemental
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ElementalLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("ascendanceTime", "ascendance", classic, "CENTER", "RIGHT"),
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end

	local manaBarTextSettings = TRB.Functions.Settings:LoadDefaultManaBarTextSettings(classic)
	for k,v in pairs(manaBarTextSettings) do table.insert(textSettings, v) end

	return textSettings
end
TRB.Options.Shaman.ElementalLoadDefaultBarTextSettings = ElementalLoadDefaultBarTextSettings

---Loads default settings for Elemental
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ElementalLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				earthShock = {
					enabled = true,
				},
				earthquake = {
					enabled = true,
				},
				earthquakeTargeted = {
					enabled = true,
				},
				elementalBlast = {
					enabled = true,
				},
			}
		},
		maxResource = {
			value = ELEMENTAL_MAX_MAELSTROM,
			enabled = false
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			mana = "never",
			dragonriding = true
		},
		endOfAscendance = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = ELEMENTAL_MAX_MAELSTROM
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			mana = TRB.Functions.Settings:DefaultManaBarDimensions(classic),
		},
		colors = {
			text = {
				current = {
					color = "FF6563E0"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF995BDD"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				manaBar = {
					color = "FF0000FF"
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border="FF00008D",
				overcapEnabled=true,
				borderOvercap="FFFF0000",
				background="66000000",
				base="FF0055FF",
				earthShock="FF00096A",
				inAscendance="FFFA8128",
				inAscendance1GCD="FFFF0000",
				flashAlpha=0.70,
				flashPeriod=0.5,
				flashEnabled=true,
			},
				threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
				},
				special = {
					color = "FFFF00FF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			bars = {
				mana = TRB.Functions.Settings:DefaultManaBarColors(),
			},
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
			esReady={
				name = L["ShamanElementalAudioEarthShockReady"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, true),
	}

	if includeBarText then
		settings.displayText.barText = ElementalLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Enhancement
---Loads default bar text settings for Enhancement
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function EnhancementLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("ascendanceTime", "ascendance", classic, "CENTER", "CENTER"),
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Shaman.EnhancementLoadDefaultBarTextSettings = EnhancementLoadDefaultBarTextSettings

---Loads default settings for Enhancement
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function EnhancementLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		endOfAscendance = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
		colors = {
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				inAscendance="FFFA8128",
				inAscendance1GCD="FFFF0000",
			},
			comboPoints = {
				border="ff0071df",
				background="66000000",
				base="ff55e2ff",
				overflowBase = {
					color = "FF0077DD"
				},
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
				compressedView=true
			},
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
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = EnhancementLoadDefaultBarTextSettings(classic)
	end

	return settings
end


-- Restoration
---Loads default bar text settings for Restoration
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function RestorationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("ascendanceTime", "ascendance", classic, "CENTER", "CENTER"),
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Shaman.RestorationLoadDefaultBarTextSettings = RestorationLoadDefaultBarTextSettings

---Loads default settings for Restoration
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function RestorationLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOfAscendance = {
			enabled=true,
			mode="gcd",
			gcdsMax=2,
			timeMax=3.0
		},
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				inAscendance="FFFA8128",
				inAscendance1GCD="FFFF0000",
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
				color = "FFFFFFFF",
			},
			barText = {}
		},
		audio = {
			innervate={
				name = L["Innervate"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = RestorationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Shaman
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.shaman.elemental = ElementalLoadDefaultSettings(includeBarText, classic)
	settings.shaman.enhancement = EnhancementLoadDefaultSettings(includeBarText, classic)
	settings.shaman.restoration = RestorationLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Shaman.LoadDefaultSettings = LoadDefaultSettings

--[[

Elemental Option Menus

]]


local function ElementalConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.elemental
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["ShamanElementalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.elemental = ElementalLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanElementalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ElementalLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["ShamanElementalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.elemental = ElementalLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["ShamanElementalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ElementalLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Elemental_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["ShamanElementalFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ElementalLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Elemental_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ElementalConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.elemental
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Elemental_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Elemental_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceMaelstrom"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 1, yCoord, false, true)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], "notEmpty", true, L["ShamanElementalEarthShockElementalBlast"], L["ShamanElementalEarthShockElementalBlastAbbreviation"], false, nil, true, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"])

	yCoord = yCoord - 30
	controls.colors.earthShock = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerEarthShock"], spec.colors.bar.earthShock, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.earthShock
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "earthShock")
	end)

	yCoord = yCoord - 30
	controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance		
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Checkbox_EOA", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfAscendance
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalCheckboxAscendanceEnd"])
	f.tooltip = L["ShamanElementalCheckboxAscendanceEndTooltip"]
	f:SetChecked(spec.endOfAscendance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfAscendance.enabled = self:GetChecked()
	end)

	controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance1GCD
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], true, false)
	
	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 7, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_EOFA_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
		spec.endOfAscendance.mode = "gcd"
	end)

	title = L["ShamanAscendanceGcds"]
	controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfAscendance.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_EOFA_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
		spec.endOfAscendance.mode = "time"
	end)

	title = L["ShamanAscendanceTime"]
	controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfAscendance.timeMax = value
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], ELEMENTAL_MAX_MAELSTROM)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], 1, ELEMENTAL_MAX_MAELSTROM)
end

local function ElementalConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.elemental
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Shadow_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 7, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30

	controls.checkBoxes.earthShockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Threshold_Option_earthShock", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.earthShockThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalThresholdEarthShock"])
	f.tooltip = L["ShamanElementalThresholdEarthShockTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.earthShock.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.earthShock.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.elementalBlast.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.earthquakeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_Threshold_Option_earthquake", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.earthquakeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanElementalThresholdEarthquake"])
	f.tooltip = L["ShamanElementalThresholdEarthquakeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.earthquake.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.earthquake.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.earthquakeTargeted.enabled = self:GetChecked()
	end)

	local custom = {
		--[[{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["ShamanElementalThresholdColorPickerEchoesOfGreatSundering"],
			enabledCheckboxLocalization = L["ShamanElementalThresholdColorPickerEchoesOfGreatSunderingEnabled"],
			enabledCheckboxTooltipLocalization = L["ShamanElementalThresholdColorPickerEchoesOfGreatSunderingEnabledTooltip"]
		}]]
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], true, true, false, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 7, 1, yCoord, true)
end

local function ElementalConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.elemental
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Shaman_Elemental_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanElementalTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCasting"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["ShamanElementalCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["ShamanElementalCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 30
	spec.colors.text.manaBar = spec.colors.text.manaBar or { color = "FF0000FF" }
	controls.colors.text.manaBar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.manaBar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "manaBar")
	end)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 7, 1, yCoord)
end

local function ElementalConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 1
	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.elemental
	local yCoord = 5

	controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "esReady", spec, classId, specId, yCoord, L["ShamanElementalAudioCheckboxEarthShock"], L["ShamanElementalAudioCheckboxEarthShockTooltip"])
end

local function ElementalConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.elemental
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Shaman_Elemental_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Elemental_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 1, yCoord, cache)
end

local function ElementalConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(7, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls
	local yCoord = 0
	local f = nil
	interfaceSettingsFrame.elementalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Elemental", UIParent)
	interfaceSettingsFrame.elementalDisplayPanel.name = L["ShamanElementalFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.elementalDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["elemental"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.elementalDisplayPanel, L["ShamanElementalFull"])
	
	parent = interfaceSettingsFrame.elementalDisplayPanel

	controls.buttons = controls.buttons or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanElementalFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.elementalShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Elemental_elementalShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.elementalShamanEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanElementalFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.shaman.elemental)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.shaman.elemental = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.elementalShamanEnabled, TRB.Data.settings.core.enabled.shaman.elemental, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Shaman_Elemental_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Shaman_Elemental_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 1, true, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab3", L["TabFontText"], 3, parent, 85, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_" .. namePrefix .. "_LayoutPanel" .. i, parent)
		tabsheets[i]:Hide()
		tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.elemental = controls

	ElementalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	ElementalConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	ElementalConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	ElementalConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	ElementalConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	ElementalConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Enhancement Option Menus

]]


local function EnhancementConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["ShamanEnhancementFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.enhancement = EnhancementLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanEnhancementFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = EnhancementLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["ShamanEnhancementFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.enhancement = EnhancementLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["ShamanEnhancementFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = EnhancementLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Enhancement_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["ShamanEnhancementFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = EnhancementLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Enhancement_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function EnhancementConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.enhancement
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Enhancement_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Enhancement_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], L["ResourceMaelstromWeapon"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 2, yCoord, true, L["ResourceMaelstromWeapon"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceMaelstromWeapon"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_Checkbox_EOA", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfAscendance
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanManaCheckboxAscendanceEnd"])
	f.tooltip = L["ShamanManaCheckboxAscendanceEndTooltip"]
	f:SetChecked(spec.endOfAscendance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfAscendance.enabled = self:GetChecked()
	end)

	controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance1GCD
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], false, false)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanEnhancementMaelstromWeaponColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceMaelstromWeapon"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.overflowBase = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanEnhancementMaelstromWeaponColorPickerOverflowBase"], spec.colors.comboPoints.overflowBase.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.overflowBase
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "overflowBase")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaelstromWeaponCheckboxUseHighestForAll"])
	f.tooltip = L["MaelstromWeaponCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.compressedViewComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_maelstromWeaponCompressedView", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.compressedViewComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanEnhancementCheckboxMaelstromWeaponCompressedView"])
	f.tooltip = L["ShamanEnhancementCheckboxMaelstromWeaponCompressedViewTooltip"]
	f:SetChecked(spec.colors.comboPoints.compressedView)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.compressedView = self:GetChecked()
		-- Rebuild secondary bar with correct node count
		local barGroups = TRB.Frames.barGroups
		if barGroups and barGroups.secondary then
			local maxStacks = TRB.Data.character.maxResource2 or 10
			local displayNodes = spec.colors.comboPoints.compressedView and math.ceil(maxStacks / 2) or maxStacks
			barGroups.secondary:RebuildNodes(displayNodes, spec)
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 2, yCoord)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_EOFA_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
		spec.endOfAscendance.mode = "gcd"
	end)

	title = L["ShamanAscendanceGcds"]
	controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfAscendance.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_EOFA_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
		spec.endOfAscendance.mode = "time"
	end)

	title = L["ShamanAscendanceTime"]
	controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfAscendance.timeMax = value
	end)
end

local function EnhancementConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.enhancement
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Enhancement_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Enhancement_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 7, 2, yCoord)
end

local function EnhancementConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 2
	local spec = TRB.Data.settings.shaman.enhancement

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.enhancement
	local yCoord = 5

	controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 2, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
end

local function EnhancementConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.enhancement
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Shaman_Enhancement_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Enhancement_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 2, yCoord, cache)
end

local function EnhancementConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(7, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.enhancement or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.enhancementDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Enhancement", UIParent)
	interfaceSettingsFrame.enhancementDisplayPanel.name = L["ShamanEnhancementFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.enhancementDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["enhancement"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.enhancementDisplayPanel, L["ShamanEnhancementFull"])

	parent = interfaceSettingsFrame.enhancementDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanEnhancementFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.enhancementShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Enhancement_enhancementShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.enhancementShamanEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanEnhancementFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.shaman.enhancement)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.shaman.enhancement = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.enhancementShamanEnabled, TRB.Data.settings.core.enabled.shaman.enhancement, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.enhancementShamanEnabled, TRB.Data.settings.core.enabled.shaman.enhancement, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Shaman_Enhancement_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Shaman_Enhancement_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.enhancement = controls

	EnhancementConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--EnhancementConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	EnhancementConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--EnhancementConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	EnhancementConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	EnhancementConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--	Restoration Option Menus

local function RestorationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.restoration
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["ShamanRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.restoration = RestorationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["ShamanRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["ShamanRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.shaman.restoration = RestorationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["ShamanRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Shaman_Restoration_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["ShamanRestorationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RestorationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Shaman_Restoration_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function RestorationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Restoration_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 7, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 3, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.inAscendance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendance"], spec.colors.bar.inAscendance, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance		
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfAscendance = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Enabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfAscendance
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanManaCheckboxAscendanceEnd"])
	f.tooltip = L["ShamanManaCheckboxAscendanceEndTooltip"]
	f:SetChecked(spec.endOfAscendance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfAscendance.enabled = self:GetChecked()
	end)
	
	controls.colors.inAscendance1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanManaColorPickerAscendanceEnd"], spec.colors.bar.inAscendance1GCD, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inAscendance1GCD
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inAscendance1GCD")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"], false, true)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 3, yCoord)

	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanHeaderEndOfAscendanceConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfAscendanceModeGCDs = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Mode_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(false)
		spec.endOfAscendance.mode = "gcd"
	end)

	title = L["ShamanAscendanceGcds"]
	controls.endOfAscendanceGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfAscendance.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfAscendance.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfAscendanceModeTime = CreateFrame("CheckButton", "TwintopsResourceBar_Shaman_Restoration_EndOfAscendance_Mode_Time", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfAscendanceModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShamanCheckboxAscendanceTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	
	if spec.endOfAscendance.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfAscendanceModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfAscendanceModeTime:SetChecked(true)
		spec.endOfAscendance.mode = "time"
	end)

	title = L["ShamanAscendanceTime"]
	controls.endOfAscendanceTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfAscendance.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfAscendanceTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfAscendance.timeMax = value
	end)
end

local function RestorationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Holy_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 7, 3, false, true, false, false, false, false)
	end)
end

local function RestorationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 7, 3, yCoord)
end

local function RestorationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 3
	local spec = TRB.Data.settings.shaman.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Shaman_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function RestorationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.restoration
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Shaman_Restoration_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Shaman_Restoration_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 7, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 7, 3, yCoord, cache)
end

local function RestorationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(7, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.restoration or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Restoration", UIParent)
	interfaceSettingsFrame.restorationDisplayPanel.name = L["ShamanRestorationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.restorationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["restoration"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.restorationDisplayPanel, L["ShamanRestorationFull"])
	
	parent = interfaceSettingsFrame.restorationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanRestorationFull"], oUi.xCoord, yCoord-5)
	
	controls.checkBoxes.restorationShamanEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Shaman_Restoration_restorationShamanEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.restorationShamanEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["ShamanRestorationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.shaman.restoration)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.shaman.restoration = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationShamanEnabled, TRB.Data.settings.core.enabled.shaman.restoration, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.restorationShamanEnabled, TRB.Data.settings.core.enabled.shaman.restoration, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Shaman_Restoration_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Shaman_Restoration_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls

	RestorationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--RestorationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	RestorationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--RestorationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	RestorationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	RestorationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end	

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	ElementalConstructOptionsPanel(specCache.elemental)
	EnhancementConstructOptionsPanel(specCache.enhancement)
	RestorationConstructOptionsPanel(specCache.restoration)
end
TRB.Options.Shaman.ConstructOptionsPanel = ConstructOptionsPanel