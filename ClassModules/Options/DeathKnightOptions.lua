local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.DeathKnight = {}
TRB.Options.DeathKnight.Blood = {}
TRB.Options.DeathKnight.Frost = {}
TRB.Options.DeathKnight.Unholy = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_blood = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_frost = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_unholy = {}

local BLOOD_MAX_RUNIC_POWER = 125
local FROST_MAX_RUNIC_POWER = 110
local UNHOLY_MAX_RUNIC_POWER = 100

---Loads extra default bar text settings
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DeathKnightLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune1Time}[$rune1Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune1"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune1"],
				yPos = 0,
				relativeToFrame = "ComboPoint_1",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune2Time}[$rune2Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune2"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune2"],
				yPos = 0,
				relativeToFrame = "ComboPoint_2",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune3Time}[$rune3Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune3"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune3"],
				yPos = 0,
				relativeToFrame = "ComboPoint_3",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune4Time}[$rune4Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune4"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune4"],
				yPos = 0,
				relativeToFrame = "ComboPoint_4",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune5Time}[$rune5Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune5"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune5"],
				yPos = 0,
				relativeToFrame = "ComboPoint_5",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$rune6Time}[$rune6Time]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Rune6"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Rune6"],
				yPos = 0,
				relativeToFrame = "ComboPoint_6",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
		}
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end

-- Blood
---Loads default bar text settings
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function BloodLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local extraTextSettings = DeathKnightLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.BloodLoadDefaultBarTextSettings = BloodLoadDefaultBarTextSettings

---Loads default settings for Blood
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function BloodLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				deathCoil = {
					enabled = true
				},
				deathStrike = {
					enabled = true
				},
				raiseAlly = {
					enabled = false
				}
			}
		},
		maxResource = {
			value = BLOOD_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, conditions = {}, smooth = true },
			secondary = { neverShow = false, conditions = {}, smooth = false },
			health = { neverShow = false, conditions = {}, smooth = true },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = BLOOD_MAX_RUNIC_POWER
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FF009ABD"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF600000"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFC41E3A"
				},
				cooldown = {
					color = "FFCCCCCC"
				},
				overcap = {
					color = "FFFF4500",
					enabled = false
				},
				sortRunes = true
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
				special = {
					color = "FFFF00FF",
					enabled = true
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
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = BloodLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Frost
---Loads default bar text settings
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FrostLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.FrostLoadDefaultBarTextSettings = FrostLoadDefaultBarTextSettings

---Loads default settings for Frost
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function FrostLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				deathCoil = {
					enabled = false
				},
				deathStrike = {
					enabled = false
				},
				breathOfSindragosa = {
					enabled = true
				},
				frostStrike = {
					enabled = true
				},
				glacialAdvance = {
					enabled = false
				}
			}
		},
		maxResource = {
			value = FROST_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, conditions = {}, smooth = true },
			secondary = { neverShow = false, conditions = {}, smooth = false },
			health = { neverShow = false, conditions = {}, smooth = true },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = FROST_MAX_RUNIC_POWER
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FF009ABD"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF00426A"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF368BC1"
				},
				cooldown = {
					color = "FFCCCCCC"
				},
				overcap = {
					color = "FFFF4500",
					enabled = false
				},
				sortRunes = true
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
				special = {
					color = "FFFF00FF",
					enabled = true
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
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = FrostLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function UnholyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}
	
	local extraTextSettings = DeathKnightLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.DeathKnight.UnholyLoadDefaultBarTextSettings = UnholyLoadDefaultBarTextSettings

---Loads default settings for Unholy
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function UnholyLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {
				deathCoil = {
					enabled = true
				},
				deathStrike = {
					enabled = true
				},
				epidemic = {
					enabled = true
				},
				raiseAlly = {
					enabled = false
				}
			}
		},
		maxResource = {
			value = UNHOLY_MAX_RUNIC_POWER,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, conditions = {}, smooth = true },
			secondary = { neverShow = false, conditions = {}, smooth = false },
			health = { neverShow = false, conditions = {}, smooth = true },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = UNHOLY_MAX_RUNIC_POWER
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors={
			text = {
				current = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
				},
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FF009ABD"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF00D1FF"
				},
				casting = {
					color = "FFFFFFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF12721A"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFA6FF49"
				},
				cooldown = {
					color = "FFCCCCCC"
				},
				overcap = {
					color = "FFFF4500",
					enabled = false
				},
				sortRunes = true
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
				special = {
					color = "FFFF00FF",
					enabled = true
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
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = UnholyLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Death Knight
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.deathknight.blood = BloodLoadDefaultSettings(includeBarText, classic)
	settings.deathknight.frost = FrostLoadDefaultSettings(includeBarText, classic)
	settings.deathknight.unholy = UnholyLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.DeathKnight.LoadDefaultSettings = LoadDefaultSettings


--[[

Blood Option Menus

]]

local function BloodConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_blood
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.blood = BloodLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.blood = BloodLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BloodLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Blood_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DeathKnightBloodFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = BloodLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Blood_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function BloodConstructRunicPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], BLOOD_MAX_RUNIC_POWER)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], 1, BLOOD_MAX_RUNIC_POWER)
end

local function BloodConstructRunesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.runeOvercapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_comboPointsOvercapEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.runeOvercapEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxOvercapEnabled"])
	f.tooltip = L["DeathKnightRunesCheckboxOvercapEnabledTooltip"]
	f:SetChecked(spec.colors.comboPoints.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.overcap.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerOvercap"], spec.colors.comboPoints.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "overcap")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)
end

local function BloodConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 6, 1, yCoord)
end

local function BloodConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 1, yCoord, true, L["ResourceRunes"])
end

local function BloodConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], "notEmpty", false, nil, nil, true, L["ResourceRunes"], true)
end

local function BloodConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Blood_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Blood_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 1, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raiseAllyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_Threshold_Option_raiseAlly", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raiseAllyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxRaiseAlly"])
	f.tooltip = L["DeathKnightThresholdCheckboxRaiseAllyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raiseAlly.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raiseAlly.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 1, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 1, yCoord)
end

local function BloodConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Blood_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Blood_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerCurrentRunicPower"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Blood_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DeathKnightCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 1, yCoord)
end

local function BloodConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 1
	local spec = TRB.Data.settings.deathknight.blood

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Blood_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Blood_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function BloodConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.blood
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_blood
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Blood_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Blood_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 1, yCoord, cache)
end

local function BloodConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.deathknight_blood or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.bloodDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Blood")
	TRB.Options.OptionsFrame:RegisterSpecPanel("deathknight", "deathknight_blood", L["DeathKnightBloodFull"], interfaceSettingsFrame.bloodDisplayPanel)
	
	parent = interfaceSettingsFrame.bloodDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DeathKnightBloodFull"],
		TRB.Data.settings.core.enabled.deathknight, "blood",
		"TwintopResourceBar_DeathKnight_Blood_bloodDeathKnightEnabled", "bloodDeathKnightEnabled",
		"exportButton_DeathKnight_Blood_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightBloodFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 1, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_blood = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "runicPowerBar", label = L["TabRunicPower"], width = oUi.tabWidth.small, constructor = BloodConstructRunicPowerBarPanel },
		{ key = "runesBar", label = L["TabRunes"], width = oUi.tabWidth.small, constructor = BloodConstructRunesBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = BloodConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = BloodConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = BloodConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = BloodConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = BloodConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) BloodConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = BloodConstructResetDefaultsPanel },
	}, yCoord)
end


-- Frost Option Menus
local function FrostConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_frost
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.frost = FrostLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DeathKnightFrostFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.frost = FrostLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DeathKnightFrostFull"]),
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
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Frost_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DeathKnightFrostFull"]),
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Frost_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FrostConstructRunicPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], FROST_MAX_RUNIC_POWER)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], 1, FROST_MAX_RUNIC_POWER)
end

local function FrostConstructRunesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.runeOvercapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_comboPointsOvercapEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.runeOvercapEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxOvercapEnabled"])
	f.tooltip = L["DeathKnightRunesCheckboxOvercapEnabledTooltip"]
	f:SetChecked(spec.colors.comboPoints.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.overcap.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerOvercap"], spec.colors.comboPoints.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "overcap")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)
end

local function FrostConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 6, 2, yCoord)
end

local function FrostConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 2, yCoord, true, L["ResourceRunes"])
end

local function FrostConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], "notEmpty", false, nil, nil, true, L["ResourceRunes"], true)
end

local function FrostConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Frost_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Frost_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 2, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.breathOfSindragosaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_breathOfSindragosa", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.breathOfSindragosaThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxBreathOfSindragosa"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxBreathOfSindragosaTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.breathOfSindragosa.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.breathOfSindragosa.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.frostStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_frostStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.frostStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxFrostStrike"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxFrostStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.frostStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.frostStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.glacialAdvanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_Threshold_Option_glacialAdvance", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.glacialAdvanceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightFrostThresholdCheckboxGlacialAdvance"])
	f.tooltip = L["DeathKnightFrostThresholdCheckboxGlacialAdvanceTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.glacialAdvance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.glacialAdvance.enabled = self:GetChecked()
	end)


	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 2, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 2, yCoord)
end

local function FrostConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Frost_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Frost_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerCurrentRunicPower"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Frost_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DeathKnightCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 2, yCoord)
end

local function FrostConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 2
	local spec = TRB.Data.settings.deathknight.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Frost_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Frost_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function FrostConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_frost
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Frost_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Frost_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 2, yCoord, cache)
end

local function FrostConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.deathknight_frost or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.frostDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Frost")
	TRB.Options.OptionsFrame:RegisterSpecPanel("deathknight", "deathknight_frost", L["DeathKnightFrostFull"], interfaceSettingsFrame.frostDisplayPanel)
	
	parent = interfaceSettingsFrame.frostDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DeathKnightFrostFull"],
		TRB.Data.settings.core.enabled.deathknight, "frost",
		"TwintopResourceBar_DeathKnight_Frost_frostDeathKnightEnabled", "frostDeathKnightEnabled",
		"exportButton_DeathKnight_Frost_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightFrostFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 2, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_frost = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "runicPowerBar", label = L["TabRunicPower"], width = oUi.tabWidth.small, constructor = FrostConstructRunicPowerBarPanel },
		{ key = "runesBar", label = L["TabRunes"], width = oUi.tabWidth.small, constructor = FrostConstructRunesBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FrostConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = FrostConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = FrostConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = FrostConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = FrostConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) FrostConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = FrostConstructResetDefaultsPanel },
	}, yCoord)
end

-- Unholy Option Menus
local function UnholyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_unholy
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.unholy = UnholyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.deathknight.unholy = UnholyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = UnholyLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_DeathKnight_Unholy_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["DeathKnightUnholyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = UnholyLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_DeathKnight_Unholy_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function UnholyConstructRunicPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 6, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], UNHOLY_MAX_RUNIC_POWER)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], 1, UNHOLY_MAX_RUNIC_POWER)
end

local function UnholyConstructRunesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], L["ResourceRunes"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceRunes"], spec.colors.comboPoints.base.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerRunesBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.cooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerCooldown"], spec.colors.comboPoints.cooldown.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.cooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "cooldown")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.runeOvercapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_comboPointsOvercapEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.runeOvercapEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxOvercapEnabled"])
	f.tooltip = L["DeathKnightRunesCheckboxOvercapEnabledTooltip"]
	f:SetChecked(spec.colors.comboPoints.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.overcap.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightRunesColorPickerOvercap"], spec.colors.comboPoints.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "overcap")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sortRunesComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_comboPointsSortRunes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sortRunesComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightRunesCheckboxSortRunes"])
	f.tooltip = L["DeathKnightRunesCheckboxSortRunesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sortRunes)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sortRunes = self:GetChecked()
	end)
end

local function UnholyConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 6, 3, yCoord)
end

local function UnholyConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 6, 3, yCoord, true, L["ResourceRunes"])
end

local function UnholyConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], "notEmpty", false, nil, nil, true, L["ResourceRunes"], true)
end

local function UnholyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Unholy_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Unholy_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 6, 3, false, true, false, false, false, false)
	end)

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30

	controls.checkBoxes.deathCoilThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_deathCoil", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathCoilThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathCoil"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathCoilTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathCoil.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathCoil.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.deathStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_deathStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxDeathStrike"])
	f.tooltip = L["DeathKnightThresholdCheckboxDeathStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.epidemicThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_epidemic", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.epidemicThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightUnholyThresholdCheckboxEpidemic"])
	f.tooltip = L["DeathKnightUnholyThresholdCheckboxEpidemicTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.epidemic.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.epidemic.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.raiseAllyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_Threshold_Option_raiseAlly", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.raiseAllyThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["DeathKnightThresholdCheckboxRaiseAlly"])
	f.tooltip = L["DeathKnightThresholdCheckboxRaiseAllyTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.raiseAlly.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.raiseAlly.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 6, 3, yCoord, L["ResourceRunicPower"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 6, 3, yCoord)
end

local function UnholyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_DeathKnight_Unholy_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Unholy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 6, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 6, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DeathKnightRunicPowerTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 6, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerCurrentRunicPower"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DeathKnightColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DeathKnight_Unholy_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["DeathKnightCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 6, 3, yCoord)
end

local function UnholyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 6
	local specId = 3
	local spec = TRB.Data.settings.deathknight.unholy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_DeathKnight_Unholy_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Unholy_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function UnholyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.deathknight.unholy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.deathknight_unholy
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_DeathKnight_Unholy_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_DeathKnight_Unholy_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 6, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 6, 3, yCoord, cache)
end

local function UnholyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(6, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.deathknight_unholy or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.unholyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DeathKnight_Unholy")
	TRB.Options.OptionsFrame:RegisterSpecPanel("deathknight", "deathknight_unholy", L["DeathKnightUnholyFull"], interfaceSettingsFrame.unholyDisplayPanel)
	
	parent = interfaceSettingsFrame.unholyDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["DeathKnightUnholyFull"],
		TRB.Data.settings.core.enabled.deathknight, "unholy",
		"TwintopResourceBar_DeathKnight_Unholy_unholyDeathKnightEnabled", "unholyDeathKnightEnabled",
		"exportButton_DeathKnight_Unholy_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["DeathKnightUnholyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 6, 3, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.deathknight_unholy = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "runicPowerBar", label = L["TabRunicPower"], width = oUi.tabWidth.small, constructor = UnholyConstructRunicPowerBarPanel },
		{ key = "runesBar", label = L["TabRunes"], width = oUi.tabWidth.small, constructor = UnholyConstructRunesBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = UnholyConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = UnholyConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = UnholyConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = UnholyConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = UnholyConstructFontAndTextPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) UnholyConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = UnholyConstructResetDefaultsPanel },
	}, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("deathknight", L["DeathKnight"])

	BloodConstructOptionsPanel(specCache.deathknight_blood)
	FrostConstructOptionsPanel(specCache.deathknight_frost)
	UnholyConstructOptionsPanel(specCache.deathknight_unholy)

	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.DeathKnight.ConstructOptionsPanel = ConstructOptionsPanel
