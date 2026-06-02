local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Paladin = {}
TRB.Options.Paladin.Holy = {}
TRB.Options.Paladin.Protection = {}
TRB.Options.Paladin.Retribution = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_holy = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_protection = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_retribution = {}

-- Holy
---Loads default bar text settings for Holy
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Paladin.HolyLoadDefaultBarTextSettings = HolyLoadDefaultBarTextSettings

---Loads default settings for Holy
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function HolyLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FFAF9942"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
				casting = TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(true),
				second = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				third = {
					color = "FFFFC800",
					color2 = "FFFFC800",
					gradientDirection = "disabled"
				},
				penultimate = {
					color = "FFFF9900",
					color2 = "FFFF9900",
					gradientDirection = "disabled"
				},
				final = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				sameColor = false
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = { "infusionOfLight", "divinePurpose" },
				gradientOrder = {},
				indicatorColors = {
					infusionOfLight = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							holyPowerBar = { bar = false, border = false, background = false },
						},
					},
					divinePurpose = {
						color = "FF44FF44",
						color2 = "FF44FF44",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = false, background = false },
							holyPowerBar = { bar = false, border = true, background = true },
						},
					},
				},
			},
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = { color = "FFFFFFFF" },
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
			holyPowerThreshold1={
				name = L["PaladinAudioHolyPowerThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3
				}
			},
			holyPowerThreshold2={
				name = L["PaladinAudioHolyPowerThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 4
				}
			},
			holyPowerThreshold3={
				name = L["PaladinAudioHolyPowerThreshold3"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
			infusionOfLight={
				name = L["PaladinHolyInfusionOfLight"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			divinePurpose={
				name = L["PaladinAudioDivinePurpose"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = HolyLoadDefaultBarTextSettings(classic)
	end
	settings.textures.comboPointsCastingBar = settings.textures.castingBar
	settings.textures.comboPointsCastingBarName = settings.textures.castingBarName

	return settings
end

-- Protection
---Loads default bar text settings for Protection
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ProtectionLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Paladin.ProtectionLoadDefaultBarTextSettings = ProtectionLoadDefaultBarTextSettings

---Loads default settings for Protection
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ProtectionLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FFAF9942"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
				second = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				third = {
					color = "FFFFC800",
					color2 = "FFFFC800",
					gradientDirection = "disabled"
				},
				penultimate = {
					color = "FFFF9900",
					color2 = "FFFF9900",
					gradientDirection = "disabled"
				},
				final = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				sameColor = false
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = { "infusionOfLight", "divinePurpose" },
				gradientOrder = {},
				indicatorColors = {
					infusionOfLight = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							holyPowerBar = { bar = false, border = false, background = false },
						},
					},
					divinePurpose = {
						color = "FF44FF44",
						color2 = "FF44FF44",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = false, background = false },
							holyPowerBar = { bar = false, border = true, background = true },
						},
					},
				},
			},
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = { color = "FFFFFFFF" },
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
			holyPowerThreshold1={
				name = L["PaladinAudioHolyPowerThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3
				}
			},
			holyPowerThreshold2={
				name = L["PaladinAudioHolyPowerThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 4
				}
			},
			holyPowerThreshold3={
				name = L["PaladinAudioHolyPowerThreshold3"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
			divinePurpose={
				name = L["PaladinAudioDivinePurpose"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = ProtectionLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Retribution
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function RetributionLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Paladin.RetributionLoadDefaultBarTextSettings = RetributionLoadDefaultBarTextSettings

---Loads default settings for Retribution
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function RetributionLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			health = 1,
			secondary = 2,
			resource = 0,
			mana = 1
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
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
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FFAF9942"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
				second = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled"
				},
				third = {
					color = "FFFFC800",
					color2 = "FFFFC800",
					gradientDirection = "disabled"
				},
				penultimate = {
					color = "FFFF9900",
					color2 = "FFFF9900",
					gradientDirection = "disabled"
				},
				final = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				sameColor = false
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = { "divinePurpose" },
				gradientOrder = {},
				indicatorColors = {
					divinePurpose = {
						color = "FF44FF44",
						color2 = "FF44FF44",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = false, background = false },
							holyPowerBar = { bar = false, border = true, background = true },
						},
					},
				},
			},
		},
		displayText={
			default = {
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=14,
				color = { color = "FFFFFFFF" },
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = {
					enabled = false,
					color = "FF000000",
					xOffset = 1,
					yOffset = -1,
				},
			},
			barText = {}
		},
		audio = {
			holyPowerThreshold1={
				name = L["PaladinAudioHolyPowerThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 3
				}
			},
			holyPowerThreshold2={
				name = L["PaladinAudioHolyPowerThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 4
				}
			},
			holyPowerThreshold3={
				name = L["PaladinAudioHolyPowerThreshold3"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
			divinePurpose={
				name = L["PaladinAudioDivinePurpose"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = RetributionLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Paladin
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.paladin.holy = HolyLoadDefaultSettings(includeBarText, classic)
	settings.paladin.protection = ProtectionLoadDefaultSettings(includeBarText, classic)
	settings.paladin.retribution = RetributionLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Paladin.LoadDefaultSettings = LoadDefaultSettings


--[[

Holy Option Menus

]]

local function HolyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_holy
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Paladin_Holy_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PaladinHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.holy = HolyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Holy_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PaladinHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.holy = HolyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Holy_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PaladinHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HolyLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Holy_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PaladinHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = HolyLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Holy_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Holy_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Holy_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Holy_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function HolyConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 2, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceMana"])

end

local function HolyConstructHolyPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceMana"], L["ResourceHolyPower"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PaladinHolyPowerColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerBase"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.second = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerSecond"], spec.colors.comboPoints.second, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.second
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "second")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.second, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.third = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerThird"], spec.colors.comboPoints.third, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.third
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "third")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.third, self)
	end)
	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Paladin_Holy_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PaladinHolyPowerCheckboxUseHighestForAll"])
	f.tooltip = L["PaladinHolyPowerCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceHolyPower"])
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryCastingOverlayOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceHolyPower"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinColorPickerHolyPowerBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinHolyPowerColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function HolyConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 2, 1, yCoord)
end

local function HolyConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 2, 1, yCoord, true, L["ResourceHolyPower"], nil, nil, true)
end

local function HolyConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 2, 1, yCoord, L["ResourceMana"], "notFull", true, L["ResourceHolyPower"], true)
end

local function HolyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5
	local f = nil

end

local function HolyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 2, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 2, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 2, 1, yCoord)
end

local function HolyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 1
	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold1", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold1"], L["PaladinAudioCheckboxHolyPowerThreshold1Tooltip"])

	controls.paladin_holyPowerThreshold1Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold2", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold2"], L["PaladinAudioCheckboxHolyPowerThreshold2Tooltip"])

	controls.paladin_holyPowerThreshold2Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold2"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold3", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold3"], L["PaladinAudioCheckboxHolyPowerThreshold3Tooltip"])

	controls.paladin_holyPowerThreshold3Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold3"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold3Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold3"].configuration.thresholdValue = value
	end)

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "infusionOfLight", spec, classId, specId, yCoord, L["PaladinHolyAudioCheckboxInfusionOfLight"], L["PaladinHolyAudioCheckboxInfusionOfLightTooltip"])

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "divinePurpose", spec, classId, specId, yCoord, L["PaladinAudioCheckboxDivinePurpose"], L["PaladinAudioCheckboxDivinePurposeTooltip"])
end

local function HolyConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 1
	local spec = TRB.Data.settings.paladin.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "infusionOfLight", label = L["PaladinHolyInfusionOfLight"], tooltip = L["PaladinHolyIndicatorInfusionOfLightTooltip"], colorLabel = L["PaladinHolyIndicatorInfusionOfLightColor"] },
			{ key = "divinePurpose", label = L["PaladinIndicatorDivinePurpose"], tooltip = L["PaladinIndicatorDivinePurposeTooltip"], colorLabel = L["PaladinIndicatorDivinePurposeColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "holyPowerBar", label = L["ResourceHolyPower"] },
		},
		ddNamePrefix = "TwintopResourceBar_Paladin_Holy",
	})

	yCoord = yCoord - 40
end

local function HolyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.holy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_holy
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 2, 1, yCoord, cache)
end

local function HolyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(2, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.paladin_holy or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.holyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Paladin_Holy")
	TRB.Options.OptionsFrame:RegisterSpecPanel("paladin", "paladin_holy", L["PaladinHolyFull"], interfaceSettingsFrame.holyDisplayPanel)
	
	parent = interfaceSettingsFrame.holyDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PaladinHolyFull"],
		TRB.Data.settings.core.enabled.paladin, "holy",
		"TwintopResourceBar_Paladin_Holy_holyPaladinEnabled", "holyPaladinEnabled",
		"paladin", "holy")

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, HolyConstructManaBarPanel },
		{ "holyPowerBar", L["TabHolyPower"], oUi.tabWidth.small, HolyConstructHolyPowerBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, HolyConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, HolyConstructIndicatorColorsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("paladin", "holy", controls),
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, HolyConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, HolyConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, HolyConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, HolyConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) HolyConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, HolyConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_holy = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


-- Protection Option Menus
local function ProtectionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_protection
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Paladin_Protection_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PaladinProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.protection = ProtectionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Protection_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PaladinProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.protection = ProtectionLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Protection_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PaladinProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ProtectionLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Protection_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PaladinProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ProtectionLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Protection_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Protection_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Protection_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Protection_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ProtectionConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 2, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 2, 2, yCoord, L["ResourceMana"])
end

local function ProtectionConstructHolyPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 2, 2, yCoord, L["ResourceMana"], L["ResourceHolyPower"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PaladinHolyPowerColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerBase"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.second = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerSecond"], spec.colors.comboPoints.second, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.second
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "second")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.second, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.third = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerThird"], spec.colors.comboPoints.third, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.third
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "third")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.third, self)
	end)
	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Paladin_Protection_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PaladinHolyPowerCheckboxUseHighestForAll"])
	f.tooltip = L["PaladinHolyPowerCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 2, 2, yCoord, L["ResourceHolyPower"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinColorPickerHolyPowerBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinHolyPowerColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function ProtectionConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 2, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 2, 2, yCoord)
end

local function ProtectionConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 2, 2, yCoord, true, L["ResourceHolyPower"])
end

local function ProtectionConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 2, 2, yCoord, L["ResourceMana"], "notFull", true, L["ResourceHolyPower"], true)
end

local function ProtectionConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5
	local f = nil

end

local function ProtectionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 2, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PaladinProtectionManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 2, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinProtectionColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinProtectionColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 2, 2, yCoord)
end

local function ProtectionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 2
	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold1", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold1"], L["PaladinAudioCheckboxHolyPowerThreshold1Tooltip"])

	controls.paladin_holyPowerThreshold1Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold2", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold2"], L["PaladinAudioCheckboxHolyPowerThreshold2Tooltip"])

	controls.paladin_holyPowerThreshold2Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold2"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold3", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold3"], L["PaladinAudioCheckboxHolyPowerThreshold3Tooltip"])

	controls.paladin_holyPowerThreshold3Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold3"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold3Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold3"].configuration.thresholdValue = value
	end)

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "divinePurpose", spec, classId, specId, yCoord, L["PaladinAudioCheckboxDivinePurpose"], L["PaladinAudioCheckboxDivinePurposeTooltip"])
end

local function ProtectionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 2, 2, yCoord, cache)
end

local function ProtectionConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 2, 2, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "infusionOfLight", label = L["PaladinProtectionCheckboxInfusionOfLight"], tooltip = L["PaladinProtectionIndicatorInfusionOfLightTooltip"], colorLabel = L["PaladinProtectionIndicatorInfusionOfLightColor"] },
			{ key = "divinePurpose", label = L["PaladinIndicatorDivinePurpose"], tooltip = L["PaladinIndicatorDivinePurposeTooltip"], colorLabel = L["PaladinIndicatorDivinePurposeColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "holyPowerBar", label = L["ResourceHolyPower"] },
		},
		ddNamePrefix = "TwintopResourceBar_Paladin_Protection",
	}))

	yCoord = yCoord - 40
end

local function ProtectionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(2, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.paladin_protection or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.protectionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Paladin_Protection")
	TRB.Options.OptionsFrame:RegisterSpecPanel("paladin", "paladin_protection", L["PaladinProtectionFull"], interfaceSettingsFrame.protectionDisplayPanel)
	
	parent = interfaceSettingsFrame.protectionDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PaladinProtectionFull"],
		TRB.Data.settings.core.enabled.paladin, "protection",
		"TwintopResourceBar_Paladin_Protection_protectionPaladinEnabled", "protectionPaladinEnabled",
		"paladin", "protection")

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, ProtectionConstructManaBarPanel },
		{ "holyPowerBar", L["TabHolyPower"], oUi.tabWidth.small, ProtectionConstructHolyPowerBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ProtectionConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, ProtectionConstructIndicatorColorsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("paladin", "protection", controls),
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ProtectionConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ProtectionConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ProtectionConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, ProtectionConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) ProtectionConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ProtectionConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_protection = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

-- Retribution Option Menus
local function RetributionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_retribution
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Paladin_Retribution_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PaladinRetributionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.retribution = RetributionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Retribution_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PaladinRetributionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.paladin.retribution = RetributionLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Retribution_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PaladinRetributionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RetributionLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Paladin_Retribution_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PaladinRetributionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = RetributionLoadDefaultBarTextSettings(true)
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Retribution_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Retribution_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Retribution_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Paladin_Retribution_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function RetributionConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 2, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 2, 3, yCoord, L["ResourceMana"])
end

local function RetributionConstructHolyPowerBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 2, 3, yCoord, L["ResourceMana"], L["ResourceHolyPower"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PaladinHolyPowerColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerBase"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.second = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerSecond"], spec.colors.comboPoints.second, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.second
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "second")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.second, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.third = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerThird"], spec.colors.comboPoints.third, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.third
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "third")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.third, self)
	end)
	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PaladinHolyPowerColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Paladin_Retribution_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PaladinHolyPowerCheckboxUseHighestForAll"])
	f.tooltip = L["PaladinHolyPowerCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 2, 3, yCoord, L["ResourceHolyPower"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinColorPickerHolyPowerBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinHolyPowerColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function RetributionConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 2, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 2, 3, yCoord)
end

local function RetributionConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 2, 3, yCoord, true, L["ResourceHolyPower"])
end

local function RetributionConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 2, 3, yCoord, L["ResourceMana"], "notFull", true, L["ResourceHolyPower"], true)
end

local function RetributionConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5
	local f = nil

end

local function RetributionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 2, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PaladinRetributionManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 2, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinRetributionColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PaladinRetributionColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 2, 3, yCoord)
end

local function RetributionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 2
	local specId = 3
	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold1", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold1"], L["PaladinAudioCheckboxHolyPowerThreshold1Tooltip"])

	controls.paladin_holyPowerThreshold1Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold2", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold2"], L["PaladinAudioCheckboxHolyPowerThreshold2Tooltip"])

	controls.paladin_holyPowerThreshold2Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold2"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "holyPowerThreshold3", spec, classId, specId, yCoord, L["PaladinAudioCheckboxHolyPowerThreshold3"], L["PaladinAudioCheckboxHolyPowerThreshold3Tooltip"])

	controls.paladin_holyPowerThreshold3Slider = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, L["PaladinHolyPowerThresholdSliderTitle"], 0, 5, spec.audio["holyPowerThreshold3"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.paladin_holyPowerThreshold3Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["holyPowerThreshold3"].configuration.thresholdValue = value
	end)

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "divinePurpose", spec, classId, specId, yCoord, L["PaladinAudioCheckboxDivinePurpose"], L["PaladinAudioCheckboxDivinePurposeTooltip"])
end

local function RetributionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 2, 3, yCoord, cache)
end

local function RetributionConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.paladin.retribution

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.paladin_retribution
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 2, 3, yCoord, {
		indicatorDefs = {
			{ key = "divinePurpose", label = L["PaladinIndicatorDivinePurpose"], tooltip = L["PaladinIndicatorDivinePurposeTooltip"], colorLabel = L["PaladinIndicatorDivinePurposeColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "holyPowerBar", label = L["ResourceHolyPower"] },
		},
		ddNamePrefix = "TwintopResourceBar_Paladin_Retribution",
	})

	yCoord = yCoord - 40
end

local function RetributionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(2, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.paladin_retribution or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.retributionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Paladin_Retribution")
	TRB.Options.OptionsFrame:RegisterSpecPanel("paladin", "paladin_retribution", L["PaladinRetributionFull"], interfaceSettingsFrame.retributionDisplayPanel)
	
	parent = interfaceSettingsFrame.retributionDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PaladinRetributionFull"],
		TRB.Data.settings.core.enabled.paladin, "retribution",
		"TwintopResourceBar_Paladin_Retribution_retributionPaladinEnabled", "retributionPaladinEnabled",
		"paladin", "retribution")

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, RetributionConstructManaBarPanel },
		{ "holyPowerBar", L["TabHolyPower"], oUi.tabWidth.small, RetributionConstructHolyPowerBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, RetributionConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, RetributionConstructIndicatorColorsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("paladin", "retribution", controls),
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, RetributionConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, RetributionConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, RetributionConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, RetributionConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) RetributionConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, RetributionConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.paladin_retribution = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("paladin", L["Paladin"])

	HolyConstructOptionsPanel(specCache.paladin_holy)
	ProtectionConstructOptionsPanel(specCache.paladin_protection)
	RetributionConstructOptionsPanel(specCache.paladin_retribution)

	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Paladin.ConstructOptionsPanel = ConstructOptionsPanel
