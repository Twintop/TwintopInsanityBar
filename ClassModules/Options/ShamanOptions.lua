local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Shaman = {}
TRB.Options.Shaman.Elemental = {}
TRB.Options.Shaman.Enhancement = {}
TRB.Options.Shaman.Restoration = {}

TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_elemental = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_enhancement = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_restoration = {}

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

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			},
			customThresholds = {},
		},
		maxResource = {
			value = ELEMENTAL_MAX_MAELSTROM,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			mana = { neverShow = true, alwaysShow = false, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		endOf = {
			ascendance = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
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
				border = {
					color = "FF00008D"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0055FF",
					color2 = "FF0055FF",
					gradientDirection = "disabled"
				},
				flashAlpha = 0.70,
				flashPeriod = 0.5,
				flashEnabled = true,
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			threshold = {
				under = {
					color = "FFFFFFFF",
				},
				over = {
					color = "FF00FF00",
				},
				special = {
					color = "FFFF00FF",
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
			shared = {
				nodeOrder = {
					"ascendanceEnd",
					"earthShock",
					"earthquake",
					"ascendance"
				},
				gradientOrder = {
					"borderOvercap"
				},
				indicatorColors = {
					earthShock = {
						color = "FF00096A",
						color2 = "FF00096A",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							maelstromBar = { bar = true, border = false, background = false }
						}
					},
					earthquake = {
						color = "FF5C4033",
						color2 = "FF5C4033",
						gradientDirection = "disabled",
						enabled = false,
						targets = {
							maelstromBar = { bar = true, border = false, background = false }
						}
					},
					ascendance = {
						color = "FFFA8128",
						color2 = "FFFA8128",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							maelstromBar = { bar = true, border = false, background = false }
						}
					},
					ascendanceEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							maelstromBar = { bar = true, border = false, background = false }
						}
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							maelstromBar = { bar = false, border = true, background = false }
						}
					}
				}
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		endOf = {
			ascendance = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
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
					color = "FF0071DF"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF55E2FF",
					color2 = "FF55E2FF",
					gradientDirection = "disabled"
				},
				fiveStack = {
					color = "FF00B400",
					color2 = "FF00B400",
					gradientDirection = "disabled"
				},
				overflowBase = {
					color = "FF0077DD",
					color2 = "FF0077DD",
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
				sameColor = false,
				compressedView = true
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
			shared = {
				nodeOrder = {
					"ascendanceEnd",
					"ascendance"
				},
				gradientOrder = {},
				indicatorColors = {
					ascendance = {
						color = "FFFA8128",
						color2 = "FFFA8128",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					},
					ascendanceEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					}
				}
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
			maelstromWeaponThreshold1={
				name = L["ShamanAudioMaelstromWeaponThreshold1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 5
				}
			},
			maelstromWeaponThreshold2={
				name = L["ShamanAudioMaelstromWeaponThreshold2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 10
				}
			},
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			primary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOf = {
			ascendance = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
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
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = {
					"ascendanceEnd",
					"ascendance"
				},
				gradientOrder = {},
				indicatorColors = {
					ascendance = {
						color = "FFFA8128",
						color2 = "FFFA8128",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					},
					ascendanceEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false }
						}
					}
				}
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_elemental
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

local function ElementalConstructMaelstromBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], 1, ELEMENTAL_MAX_MAELSTROM)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateFlashOptions(parent, controls, spec, 7, 1, yCoord, L["ShamanElementalEarthShockElementalBlast"], L["ShamanElementalEarthShockElementalBlastAbbreviation"])
end

local function ElementalConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceMaelstrom"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 7, 1, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))
end

local function ElementalConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 1, yCoord)
end

local function ElementalConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 1
	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "ascendanceEnd", label = L["ShamanElementalCheckboxAscendanceEnd"], tooltip = L["ShamanElementalIndicatorAscendanceEndTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceEndColor"] },
			{ key = "ascendance", label = L["ShamanElementalCheckboxAscendance"], tooltip = L["ShamanElementalIndicatorAscendanceTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceColor"] },
			{ key = "earthquake", label = L["ShamanElementalCheckboxEarthquakeBarColor"], tooltip = L["ShamanElementalIndicatorEarthquakeTooltip"], colorLabel = L["ShamanElementalIndicatorEarthquakeColor"] },
			{ key = "earthShock", label = L["ShamanElementalCheckboxEarthShock"], tooltip = L["ShamanElementalIndicatorEarthShockTooltip"], colorLabel = L["ShamanElementalIndicatorEarthShockColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["ShamanElementalIndicatorBorderOvercap"], tooltip = L["ShamanElementalIndicatorOvercapTooltip"], colorLabel = L["ShamanElementalIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "maelstromBar", label = L["BarNameMaelstromBar"] },
			{ key = "manaBar", label = L["BarNameManaBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Shaman_Elemental",
		endOfConfigs = {
			{
				endOfKey = "ascendance",
				sectionHeader = L["ShamanHeaderEndOfAscendanceConfiguration"],
				gcdRadioLabel = L["ShamanCheckboxAscendanceGcds"],
				gcdSliderLabel = L["ShamanAscendanceGcds"],
				timeRadioLabel = L["ShamanCheckboxAscendanceTime"],
				timeSliderLabel = L["ShamanAscendanceTime"],
			},
		},
		overcapConfig = {
			primaryResourceString = L["ResourceMaelstrom"],
			primaryResourceMax = ELEMENTAL_MAX_MAELSTROM,
		},
	})

	yCoord = yCoord - 40
end

local function ElementalConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 1, yCoord, false, nil, true)
end

local function ElementalConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 7, 1, yCoord, L["ResourceMaelstrom"], "notEmpty", false, nil, true, true)
end

local function ElementalConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdListPanel(parent, controls, spec, 7, 1, yCoord, {
		barTargetLabels = {
			primary = L["ResourceMaelstrom"],
		},
		labels = {
			earthShock = L["ShamanElementalThresholdCheckboxEarthShock"],
			elementalBlast = L["ShamanElementalThresholdElementalBlast"],
			earthquake = L["ShamanElementalThresholdEarthquake"],
			earthquakeTargeted = L["ShamanElementalThresholdEarthquakeTargeted"],
		},
		tooltips = {
			earthShock = L["ShamanElementalThresholdCheckboxEarthShockTooltip"],
			elementalBlast = L["ShamanElementalThresholdElementalBlastTooltip"],
			earthquake = L["ShamanElementalThresholdEarthquakeTooltip"],
			earthquakeTargeted = L["ShamanElementalThresholdEarthquakeTargetedTooltip"],
		},
	})
end

local function ElementalConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	controls.colors.threshold = {}

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

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 7, 1, yCoord, true)
end

local function ElementalConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.elemental

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Shaman_Elemental_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Shaman_Elemental_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanElementalTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ShamanElementalColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	controls.colors.text.manaBar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
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
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	controls.buttons.exportButton_Shaman_Elemental_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.shaman_elemental
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Shaman_Elemental_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	interfaceSettingsFrame.elementalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Elemental")
	TRB.Options.OptionsFrame:RegisterSpecPanel("shaman", "shaman_elemental", L["ShamanElementalFull"], interfaceSettingsFrame.elementalDisplayPanel)
	
	parent = interfaceSettingsFrame.elementalDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["ShamanElementalFull"],
		TRB.Data.settings.core.enabled.shaman, "elemental",
		"TwintopResourceBar_Shaman_Elemental_elementalShamanEnabled", "elementalShamanEnabled",
		"exportButton_Shaman_Elemental_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanElementalFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 1, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "maelstromBar", L["TabMaelstrom"], oUi.tabWidth.small, ElementalConstructMaelstromBarPanel },
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, ElementalConstructManaBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ElementalConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, ElementalConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ElementalConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ElementalConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, ElementalConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, ElementalConstructThresholdListPanel, true },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ElementalConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, ElementalConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) ElementalConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ElementalConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_elemental = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Enhancement Option Menus

]]


local function EnhancementConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_enhancement
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

local function EnhancementConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"])
end

local function EnhancementConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 2
	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "ascendanceEnd", label = L["ShamanManaCheckboxAscendanceEnd"], tooltip = L["ShamanElementalIndicatorAscendanceEndTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceEndColor"] },
			{ key = "ascendance", label = L["ShamanManaCheckboxAscendance"], tooltip = L["ShamanElementalIndicatorAscendanceTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "maelstromWeaponBar", label = L["BarNameMaelstromWeaponBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Shaman_Enhancement",
		endOfConfigs = {
			{
				endOfKey = "ascendance",
				sectionHeader = L["ShamanHeaderEndOfAscendanceConfiguration"],
				gcdRadioLabel = L["ShamanCheckboxAscendanceGcds"],
				gcdSliderLabel = L["ShamanAscendanceGcds"],
				timeRadioLabel = L["ShamanCheckboxAscendanceTime"],
				timeSliderLabel = L["ShamanAscendanceTime"],
			},
		},
	})

	yCoord = yCoord - 40
end

local function EnhancementConstructMaelstromWeaponBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], L["ResourceMaelstromWeapon"])

	yCoord = yCoord - 60
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ShamanEnhancementMaelstromWeaponColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ResourceMaelstromWeapon"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	controls.colors.comboPoints.fiveStack = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ShamanEnhancementMaelstromWeaponColorPickerFiveStack"], spec.colors.comboPoints.fiveStack, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.fiveStack
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "fiveStack")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.fiveStack, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.overflowBase = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["ShamanEnhancementMaelstromWeaponColorPickerOverflowBase"], spec.colors.comboPoints.overflowBase, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.overflowBase
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "overflowBase")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.overflowBase, self)
	end)

	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["MaelstromWeaponColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["MaelstromWeaponColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["MaelstromWeaponColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
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
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(7, 2) then
			-- Rebuild secondary bar with correct node count
			local barGroups = TRB.Frames.barGroups
			if barGroups and barGroups.secondary then
				local maxStacks = TRB.Data.character.maxResource2 or 10
				local displayNodes = spec.colors.comboPoints.compressedView and math.ceil(maxStacks / 2) or maxStacks
				barGroups.secondary:RebuildNodes(displayNodes, spec)
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)
end

local function EnhancementConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 2, yCoord)
end

local function EnhancementConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 2, yCoord, true, L["ResourceMaelstromWeapon"])
end

local function EnhancementConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 7, 2, yCoord, L["ResourceMana"], "notFull", true, L["ResourceMaelstromWeapon"], true)
end

local function EnhancementConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Enhancement_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Shaman_Enhancement_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
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
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Shaman_Enhancement_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 7, 2, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "maelstromWeaponThreshold1", spec, classId, specId, yCoord, L["ShamanAudioCheckboxMaelstromWeaponThreshold1"], L["ShamanAudioCheckboxMaelstromWeaponThreshold1Tooltip"])

	controls.maelstromWeaponThreshold1Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["ShamanMaelstromWeaponThresholdSliderTitle"], 0, 10, spec.audio["maelstromWeaponThreshold1"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.maelstromWeaponThreshold1Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["maelstromWeaponThreshold1"].configuration.thresholdValue = value
	end)

	yCoord2 = yCoord - 20
	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "maelstromWeaponThreshold2", spec, classId, specId, yCoord, L["ShamanAudioCheckboxMaelstromWeaponThreshold2"], L["ShamanAudioCheckboxMaelstromWeaponThreshold2Tooltip"])

	controls.maelstromWeaponThreshold2Slider = TRB.Functions.OptionsUi:BuildSlider(parent, L["ShamanMaelstromWeaponThresholdSliderTitle"], 0, 10, spec.audio["maelstromWeaponThreshold2"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.maelstromWeaponThreshold2Slider:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["maelstromWeaponThreshold2"].configuration.thresholdValue = value
	end)
end

local function EnhancementConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.enhancement
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_enhancement
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Shaman_Enhancement_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.shaman_enhancement or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.enhancementDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Enhancement")
	TRB.Options.OptionsFrame:RegisterSpecPanel("shaman", "shaman_enhancement", L["ShamanEnhancementFull"], interfaceSettingsFrame.enhancementDisplayPanel)

	parent = interfaceSettingsFrame.enhancementDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["ShamanEnhancementFull"],
		TRB.Data.settings.core.enabled.shaman, "enhancement",
		"TwintopResourceBar_Shaman_Enhancement_enhancementShamanEnabled", "enhancementShamanEnabled",
		"exportButton_Shaman_Enhancement_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanEnhancementFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 2, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, EnhancementConstructManaBarPanel },
		{ "maelstromWeaponBar", L["TabMaelstromWeapon"], oUi.tabWidth.small, EnhancementConstructMaelstromWeaponBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, EnhancementConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, EnhancementConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, EnhancementConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, EnhancementConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, EnhancementConstructFontAndTextPanel },
		{ "audioTracking", L["TabAudioTracking"], oUi.tabWidth.large, EnhancementConstructAudioAndTrackingPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) EnhancementConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, EnhancementConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_enhancement = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end

--	Restoration Option Menus

local function RestorationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_restoration
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

local function RestorationConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 7, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"])
end

local function RestorationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 7
	local specId = 3
	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "ascendanceEnd", label = L["ShamanManaCheckboxAscendanceEnd"], tooltip = L["ShamanElementalIndicatorAscendanceEndTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceEndColor"] },
			{ key = "ascendance", label = L["ShamanManaCheckboxAscendance"], tooltip = L["ShamanElementalIndicatorAscendanceTooltip"], colorLabel = L["ShamanElementalIndicatorAscendanceColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Shaman_Restoration",
		endOfConfigs = {
			{
				endOfKey = "ascendance",
				sectionHeader = L["ShamanHeaderEndOfAscendanceConfiguration"],
				gcdRadioLabel = L["ShamanCheckboxAscendanceGcds"],
				gcdSliderLabel = L["ShamanAscendanceGcds"],
				timeRadioLabel = L["ShamanCheckboxAscendanceTime"],
				timeSliderLabel = L["ShamanAscendanceTime"],
			},
		},
	})

	yCoord = yCoord - 40
end

local function RestorationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 7, 3, yCoord)
end

local function RestorationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 7, 3, yCoord, false)
end

local function RestorationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(parent, controls, spec, 7, 3, yCoord, L["ResourceMana"], "notFull", false, nil, true)
end

local function RestorationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.shaman.restoration

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Holy_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Shaman_Restoration_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Shaman_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 7, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 7, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 7, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealerColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Shaman_Restoration_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.shaman_restoration
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Shaman_Restoration_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.shaman_restoration or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Shaman_Restoration")
	TRB.Options.OptionsFrame:RegisterSpecPanel("shaman", "shaman_restoration", L["ShamanRestorationFull"], interfaceSettingsFrame.restorationDisplayPanel)
	
	parent = interfaceSettingsFrame.restorationDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["ShamanRestorationFull"],
		TRB.Data.settings.core.enabled.shaman, "restoration",
		"TwintopResourceBar_Shaman_Restoration_restorationShamanEnabled", "restorationShamanEnabled",
		"exportButton_Shaman_Restoration_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["ShamanRestorationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 7, 3, true, true, true, true, true, false)
		end)

	local tabDefinitions = {
		{ "manaBar", L["TabMana"], oUi.tabWidth.small, RestorationConstructManaBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, RestorationConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, RestorationConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, RestorationConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, RestorationConstructBarVisibilityPanel },
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, RestorationConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) RestorationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, RestorationConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.shaman_restoration = controls

	TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end	

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("shaman", L["Shaman"])
	ElementalConstructOptionsPanel(specCache.shaman_elemental)
	EnhancementConstructOptionsPanel(specCache.shaman_enhancement)
	RestorationConstructOptionsPanel(specCache.shaman_restoration)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Shaman.ConstructOptionsPanel = ConstructOptionsPanel
