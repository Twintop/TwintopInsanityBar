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

	-- Centered in both layouts: the mana text sits on the right of this bar either way.
	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("arcaneSurgeTime", "arcaneSurge", classic, "CENTER", "CENTER"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
		thresholds = {
			properties = {
				width = 2,
				overlapBorder = true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {},
			customThresholds = {}
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
					color = "FF00AAFF"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF1A1AFA",
					color2 = "FF1A1AFA",
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
				sameColor=true
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
			},
			shared = {
				nodeOrder = { "arcaneSurgeEnd", "arcaneSurge" },
				gradientOrder = {},
				indicatorColors = {
					arcaneSurge = {
						color = "FF9B4DFF",
						color2 = "FF9B4DFF",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
						},
					},
					arcaneSurgeEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
						},
					},
				},
			},
		},
		endOf = {
			arcaneSurge = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
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
				fontOutline = "OUTLINE",
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
	local fireBlastChargeTextSettings = TRB.Functions.Settings:LoadDefaultFireBlastChargeBarTextSettings()
	for _, entry in ipairs(fireBlastChargeTextSettings) do table.insert(textSettings, entry) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
		thresholds = {
			properties = {
				width = 2,
				overlapBorder = true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {},
			customThresholds = {}
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
			},
			bars = {
				fireBlastCharges = TRB.Functions.Settings:DefaultFireBlastChargesBarColors(),
			},
			shared = {
				nodeOrder = {},
				gradientOrder = {},
				indicatorColors = {},
			},
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
				fontOutline = "OUTLINE",
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
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
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
		{
			useDefaultFontColor = true,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = true,
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "$shatterStacks",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = L["ResourceMageShatter"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["ShatterContainer"],
				yPos = 0,
				relativeToFrame = "Container::shatter",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = true,
			color = { color = "FFFFFFFF" },
			enabled = true,
		},
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
		thresholds = {
			properties = {
				width = 2,
				overlapBorder = true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			thresholdDictionary = {},
			customThresholds = {}
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			shatter = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			shatter = TRB.Functions.Settings:DefaultShatterBarDimensions(classic),
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
			bars = {
				shatter = TRB.Functions.Settings:DefaultShatterBarColors(),
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
			shared = {
				nodeOrder = { "brainFreeze", "fingersOfFrost2", "fingersOfFrost" },
				gradientOrder = {},
				indicatorColors = {
					brainFreeze = {
						color = "FFBFA0FF",
						color2 = "FFBFA0FF",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
						},
					},
					fingersOfFrost = {
						color = "FF00C8FF",
						color2 = "FF00C8FF",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
						},
					},
					fingersOfFrost2 = {
						color = "FF296373",
						color2 = "FF296373",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
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
				color = {
					color = "FFFFFFFF"
				},
				fontOutline = "OUTLINE",
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
			fingersOfFrostCharge1={
				name = L["MageFrostAudioFingersOfFrostCharge1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					playOnDrop = false
				}
			},
			fingersOfFrostCharge2={
				name = L["MageFrostAudioFingersOfFrostCharge2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			brainFreeze={
				name = L["MageFrostAudioBrainFreeze"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	-- Add Shatter bar textures
	local shatterTextures = TRB.Functions.Settings:DefaultCustomBarTextures()
	settings.textures.shatterBar = shatterTextures.bar
	settings.textures.shatterBarName = shatterTextures.barName
	settings.textures.shatterBorder = shatterTextures.border
	settings.textures.shatterBorderName = shatterTextures.borderName
	settings.textures.shatterBackground = shatterTextures.background
	settings.textures.shatterBackgroundName = shatterTextures.backgroundName

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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.arcaneDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.arcaneDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Arcane_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 8, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"])
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], L["ResourceArcaneCharges"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MageArcaneChargesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceArcaneCharges"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerArcaneChargesBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["MageArcaneChargesColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageArcaneChargesColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["MageArcaneChargesColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
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

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Mage_Arcane_ComboPoints", "endCapComboPoints", L["EndCap"], 8, 1)
end

local function ArcaneConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 8, 1, yCoord)
end

local function ArcaneConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 8, 1, yCoord, true, L["ResourceArcaneCharges"])
end

local function ArcaneConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], "notFull", true, L["ResourceArcaneCharges"], true)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 8, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 8, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 1, yCoord)
end

local function ArcaneConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 8, 1, yCoord, cache)
end

local function ArcaneConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 8, 1, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "arcaneSurgeEnd", label = L["MageArcaneIndicatorArcaneSurgeEnd"], tooltip = L["MageArcaneIndicatorArcaneSurgeEndTooltip"], colorLabel = L["MageArcaneIndicatorArcaneSurgeEndColor"] },
			{ key = "arcaneSurge", label = L["MageArcaneIndicatorArcaneSurge"], tooltip = L["MageArcaneIndicatorArcaneSurgeTooltip"], colorLabel = L["MageArcaneIndicatorArcaneSurgeColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "arcaneChargesBar", label = L["ResourceArcaneCharges"] },
		},
		endOfConfigs = {
			{
				endOfKey = "arcaneSurge",
				sectionHeader = L["MageArcaneHeaderEndOfArcaneSurgeConfiguration"],
				gcdRadioLabel = L["MageArcaneCheckboxArcaneSurgeGcds"],
				gcdSliderLabel = L["MageArcaneArcaneSurgeGcds"],
				timeRadioLabel = L["MageArcaneCheckboxArcaneSurgeTime"],
				timeSliderLabel = L["MageArcaneArcaneSurgeTime"],
			},
		},
		ddNamePrefix = "TwintopResourceBar_Mage_Arcane",
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_arcane = controls
end

local function ArcaneConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.arcane
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_arcane
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 8, 1, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 8, 1, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MageArcaneFull"],
		TRB.Data.settings.core.enabled.mage, "arcane",
		"TwintopResourceBar_Mage_Arcane_arcaneMageEnabled", "arcaneMageEnabled",
		"mage", "arcane")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_arcane = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = ArcaneConstructManaBarPanel, visibilityKey = "primary" },
		{ key = "arcaneChargesBar", label = L["TabArcaneCharges"], width = oUi.tabWidth.small, constructor = ArcaneConstructArcaneChargesPanel, visibilityKey = "secondary" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = ArcaneConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = ArcaneConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("mage", "arcane", controls),
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = ArcaneConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = ArcaneConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = ArcaneConstructBarVisibilityPanel },
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("mage", "arcane", controls),
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = ArcaneConstructFontAndTextPanel },
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.fireDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.fireDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Fire_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FireConstructFireBlastChargesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"], L["MageFireBlastCharges"])

	yCoord = yCoord - 60
	local fireBlastChargesDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("fireBlastCharges")
	if fireBlastChargesDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 8, 2, yCoord, fireBlastChargesDef, function(callbackParent, callbackYCoord)
			return TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarPartialFillColorOptions(callbackParent, controls, spec, 8, 2, callbackYCoord, fireBlastChargesDef, L["MageFireFireBlast"])
		end)
	end
end

local function FireConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 8, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"])
end

local function FireConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 8, 2, yCoord)
end

local function FireConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 8, 2, yCoord, true, L["MageFireBlastCharges"])
end

local function FireConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"], "notFull", true, L["MageFireBlastCharges"], true)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 8, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 8, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 2, yCoord)
end

local function FireConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 8, 2, yCoord, cache)
end

--local function FireConstructIndicatorColorsPanel(parent)
--end

local function FireConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.fire
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_fire
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 8, 2, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 8, 2, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MageFireFull"],
		TRB.Data.settings.core.enabled.mage, "fire",
		"TwintopResourceBar_Mage_Fire_fireMageEnabled", "fireMageEnabled",
		"mage", "fire")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_fire = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = FireConstructManaBarPanel, visibilityKey = "primary" },
		{ key = "fireBlastCharges", label = L["TabFireBlastCharges"], width = oUi.tabWidth.medium, constructor = FireConstructFireBlastChargesBarPanel, visibilityKey = "secondary" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FireConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = FireConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("mage", "fire", controls),
		--{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = FireConstructIndicatorColorsPanel },
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.frostDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.frostDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_Reset")
	end)

	yCoord = yCoord - 40
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Mage_Frost_ResetBarTextCompact")
	end)

	yCoord = yCoord - 40
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 8, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"])
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], L["ResourceIcicles"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MageFrostIciclesColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["MageFrostColorPickerIciclesBase"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["MageFrostColorPickerIciclesPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["MageFrostColorPickerIciclesFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Mage_Frost_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MageFrostCheckboxSameColorIcicles"])
	f.tooltip = L["MageFrostCheckboxSameColorIciclesTooltip"]
	f:SetChecked(spec.colors.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageFrostColorPickerIciclesBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageFrostColorPickerIciclesBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Mage_Frost_ComboPoints", "endCapComboPoints", L["EndCap"], 8, 3)
end

local function FrostConstructShatterBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	local shatterBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("shatter")
	local shatterColors = shatterBarDef and shatterBarDef:GetColors(spec)
	if shatterBarDef and shatterColors then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 8, 3, yCoord, shatterBarDef, L["ResourceMana"])

		yCoord = yCoord - 90
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 8, 3, yCoord, shatterBarDef,
			function(callbackParent, callbackYCoord)
				local f = nil

				if shatterColors.threshold == nil then
					return callbackYCoord
				end

				-- Threshold stack, applied to every multiple of it (5, 10, 15, 20)
				controls.checkBoxes.shatterThreshold = CreateFrame("CheckButton", "TwintopResourceBar_Mage_Frost_shatterThresholdEnabled", callbackParent, "ChatConfigCheckButtonTemplate")
				f = controls.checkBoxes.shatterThreshold
				f:SetPoint("TOPLEFT", oUi.xCoord, callbackYCoord)
				getglobal(f:GetName() .. 'Text'):SetText(L["MageFrostCheckboxShatterThresholdMultiples"])
				f.tooltip = L["MageFrostCheckboxShatterThresholdMultiplesTooltip"]
				f:SetChecked(shatterColors.threshold.enabled)
				f:SetScript("OnClick", function(self, ...)
					shatterColors.threshold.enabled = self:GetChecked()
					if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(8, 3) and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.cache.colors.bar = {}
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				end)

				controls.colors.bars = controls.colors.bars or {}
				controls.colors.bars.shatter = controls.colors.bars.shatter or {}
				controls.colors.bars.shatter.threshold = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(callbackParent, L["MageFrostColorPickerShatterThreshold"], shatterColors.threshold, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, callbackYCoord)
				f = controls.colors.bars.shatter.threshold
				f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, shatterColors, controls.colors.bars.shatter, "threshold", nil, nil, 8, 3)
				end)
				f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, shatterColors.threshold, self, 8, 3)
				end)

				return callbackYCoord - 30
			end)
	end
end

local function FrostConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 8, 3, yCoord)
end

local function FrostConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	local shatterBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("shatter")
	local customBars = {}
	if shatterBarDef then
		table.insert(customBars, shatterBarDef)
	end
	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 8, 3, yCoord, true, L["ResourceIcicles"], false, customBars)
end

local function FrostConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	local shatterBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("shatter")
	local customBars = {}
	if shatterBarDef then
		table.insert(customBars, shatterBarDef)
	end
	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], "notFull", true, L["ResourceIcicles"], true, nil, customBars)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 8, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["MageManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 8, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["MageColorPickerCastingMana"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 8, 3, yCoord)
end

local function FrostConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 8, 3, yCoord, cache)
end

local function FrostConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 8, 3, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "brainFreeze", label = L["MageFrostIndicatorBrainFreeze"], tooltip = L["MageFrostIndicatorBrainFreezeTooltip"], colorLabel = L["MageFrostIndicatorBrainFreezeColor"] },
			{ key = "fingersOfFrost", label = L["MageFrostIndicatorFingersOfFrost"], tooltip = L["MageFrostIndicatorFingersOfFrostTooltip"], colorLabel = L["MageFrostIndicatorFingersOfFrostColor"] },
			{ key = "fingersOfFrost2", label = L["MageFrostIndicatorFingersOfFrost2"], tooltip = L["MageFrostIndicatorFingersOfFrost2Tooltip"], colorLabel = L["MageFrostIndicatorFingersOfFrost2Color"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "iciclesBar", label = L["TabIcicles"] },
			{ key = "shatterBar", label = L["TabShatter"] },
		},
		ddNamePrefix = "TwintopResourceBar_Mage_Frost",
	}))

	yCoord = yCoord - 40

	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost = controls
end

local function FrostConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.mage.frost
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.mage_frost
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 8, 3, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 8, 3, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["MageFrostFull"],
		TRB.Data.settings.core.enabled.mage, "frost",
		"TwintopResourceBar_Mage_Frost_frostMageEnabled", "frostMageEnabled",
		"mage", "frost")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.mage_frost = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = FrostConstructManaBarPanel, visibilityKey = "primary" },
		{ key = "iciclesBar", label = L["TabIcicles"], width = oUi.tabWidth.small, constructor = FrostConstructIciclesBarPanel, visibilityKey = "secondary" },
		{ key = "shatterBar", label = L["TabShatter"], width = oUi.tabWidth.small, constructor = FrostConstructShatterBarPanel, visibilityKey = "shatter" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = FrostConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = FrostConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("mage", "frost", controls),
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = FrostConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = FrostConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = FrostConstructBarVisibilityPanel },
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("mage", "frost", controls),
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = FrostConstructFontAndTextPanel },
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
