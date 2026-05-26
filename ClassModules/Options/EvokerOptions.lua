local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Evoker = {}
TRB.Options.Evoker.Devastation = {}
TRB.Options.Evoker.Preservation = {}
TRB.Options.Evoker.Augmentation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_devastation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_preservation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_augmentation = {}

---Loads extra default bar text settings for Evoker
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function EvokerLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=0}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence1"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence1"],
				yPos = 0,
				relativeToFrame = "ComboPoint_1",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=1}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence2"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence2"],
				yPos = 0,
				relativeToFrame = "ComboPoint_2",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=2}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence3"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence3"],
				yPos = 0,
				relativeToFrame = "ComboPoint_3",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=3}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence4"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence4"],
				yPos = 0,
				relativeToFrame = "ComboPoint_4",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=4}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence5"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence5"],
				yPos = 0,
				relativeToFrame = "ComboPoint_5",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
		{
			enabled = true,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=5}[$essenceRegenTime]",
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			name = L["Essence6"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["Essence6"],
				yPos = 0,
				relativeToFrame = "ComboPoint_6",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		}
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

-- Devastation
---Loads default bar text settings for Devastation
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DevastationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("dragonrageTime", "dragonrage", classic, "CENTER", "CENTER"))

	local extraTextSettings = EvokerLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Evoker.DevastationLoadDefaultBarTextSettings = DevastationLoadDefaultBarTextSettings

---Loads default settings for Devastation
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function DevastationLoadDefaultSettings(includeBarText, classic)
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
		endOf = {
			dragonrage = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
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
				border = { color = "FF000099" },
				background = { color = "66000000" },
				base = {
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				dragonrage = {
					color = "FFFF6B00",
					color2 = "FFFF6B00",
					gradientDirection = "disabled",
					enabled = true
				},
				dragonrageEnd = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				essenceBurst = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled",
					enabled = true,
					targets = {
						manaBar = { border = true },
						essences = { border = false },
					}
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = { color = "FF246759" },
				background = { color = "66000000" },
				base = {
					color = "FF33937F",
					color2 = "FF33937F",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
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
				sameColor=false
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
			},
			shared = {
				nodeOrder = { "dragonrageEnd", "dragonrage", "essenceBurst" },
				gradientOrder = {},
				indicatorColors = {
					dragonrageEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
							essences = { bar = false, border = false, background = false },
						},
					},
					dragonrage = {
						color = "FFFF6B00",
						color2 = "FFFF6B00",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
							essences = { bar = false, border = false, background = false },
						},
					},
					essenceBurst = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							essences = { bar = false, border = false, background = false },
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
			secondaryThreshold={
				name = L["EssenceThresholdAudio"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 2
				}
			},
			essenceBurst={
				name = L["EvokerEssenceBurst"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = DevastationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Preservation
---Loads default bar text settings for Preservation
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function PreservationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local extraTextSettings = EvokerLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Evoker.PreservationLoadDefaultBarTextSettings = PreservationLoadDefaultBarTextSettings

---Loads default settings for Preservation
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function PreservationLoadDefaultSettings(includeBarText, classic)
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
				border = { color = "FF000099" },
				background = { color = "66000000" },
				base = {
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				innervate = {
					color = "FF00FF00",
					color2 = "FF00FF00",
					gradientDirection = "disabled",
					enabled = true
				},
				essenceBurst = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled",
					enabled = true,
					targets = {
						manaBar = { border = true },
						essences = { border = false },
					}
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = { color = "FF246759" },
				background = { color = "66000000" },
				base = {
					color = "FF33937F",
					color2 = "FF33937F",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
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
				sameColor=false
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			shared = {
				nodeOrder = { "innervate", "essenceBurst" },
				gradientOrder = {},
				indicatorColors = {
					innervate = {
						color = "FF00FF00",
						color2 = "FF00FF00",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = true, border = false, background = false },
							essences = { bar = false, border = false, background = false },
						},
					},
					essenceBurst = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							essences = { bar = false, border = false, background = false },
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
			innervate={
				name = L["Innervate"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			secondaryThreshold={
				name = L["EssenceThresholdAudio"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 2
				}
			},
			essenceBurst={
				name = L["EvokerEssenceBurst"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = PreservationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

-- Augmentation
---Loads default bar text settings for Augmentation
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function AugmentationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	if classic then
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$ebonMightTime}[$ebonMightTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "EbonMightBar",
				relativeToFrameName = L["EbonMightBar"]
			}
		})
	else
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$ebonMightTime}[$ebonMightTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "EbonMightBar",
				relativeToFrameName = L["EbonMightBar"]
			}
		})
	end

	local extraTextSettings = EvokerLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Evoker.AugmentationLoadDefaultBarTextSettings = AugmentationLoadDefaultBarTextSettings

---Loads default settings for Augmentation
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function AugmentationLoadDefaultSettings(includeBarText, classic)
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
			ebonMight = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			ebonMight = TRB.Functions.Settings:DefaultEbonMightBarDimensions(classic),
		},
		endOf = {
			ebonMight = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
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
				border = { color = "FF000099" },
				background = { color = "66000000" },
				base = {
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				ebonMight = {
					color = "FFFF9900",
					color2 = "FFFF9900",
					gradientDirection = "disabled",
					enabled = false
				},
				ebonMightEnd = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled",
					enabled = false
				},
				ebonMightDropDuringCast = {
					color = "FF550000",
					color2 = "FF550000",
					gradientDirection = "disabled",
					enabled = false
				},
				essenceBurst = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled",
					enabled = true,
					targets = {
						manaBar = { border = true },
						essences = { border = false },
						ebonMight = { border = false },
					}
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			comboPoints = {
				border = { color = "FF246759" },
				background = { color = "66000000" },
				base = {
					color = "FF33937F",
					color2 = "FF33937F",
					gradientDirection = "disabled"
				},
				regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
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
				sameColor=false
			},
			bars = {
				ebonMight = TRB.Functions.Settings:DefaultEbonMightBarColors(),
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
			},
			shared = {
				nodeOrder = { "ebonMightDropDuringCast", "ebonMightEnd", "ebonMight", "essenceBurst" },
				gradientOrder = {},
				indicatorColors = {
					ebonMightDropDuringCast = {
						color = "FF550000",
						color2 = "FF550000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = false, background = false },
							essences = { bar = false, border = false, background = false },
							ebonMight = { bar = true, border = false, background = false },
						},
					},
					ebonMightEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = false, background = false },
							essences = { bar = false, border = false, background = false },
							ebonMight = { bar = true, border = false, background = false },
						},
					},
					ebonMight = {
						color = "FFFF9900",
						color2 = "FFFF9900",
						gradientDirection = "disabled",
						enabled = false,
						targets = {
							manaBar = { bar = true, border = false, background = false },
							essences = { bar = false, border = false, background = false },
							ebonMight = { bar = false, border = false, background = false },
						},
					},
					essenceBurst = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							essences = { bar = false, border = false, background = false },
							ebonMight = { bar = false, border = false, background = false },
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
			ebonMightEnding={
				name = L["EvokerAugmentationAudioEbonMightEnding"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			secondaryThreshold={
				name = L["EssenceThresholdAudio"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 2
				}
			},
			essenceBurst={
				name = L["EvokerEssenceBurst"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = AugmentationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Evoker
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.evoker.devastation = DevastationLoadDefaultSettings(includeBarText, classic)
	settings.evoker.preservation = PreservationLoadDefaultSettings(includeBarText, classic)
	settings.evoker.augmentation = AugmentationLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Evoker.LoadDefaultSettings = LoadDefaultSettings

--[[

Devastation Option Menus

]]


local function DevastationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_devastation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.devastation = DevastationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.devastation = DevastationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevastationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Devastation_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["EvokerDevastationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DevastationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function DevastationConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"])
end

local function DevastationConstructEssenceBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceEssence"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function DevastationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 13, 1, yCoord)
end

local function DevastationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 13, 1, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "dragonrageEnd",  label = L["EvokerDevastationColorPickerDragonrageEnd"],  tooltip = L["EvokerDevastationIndicatorDragonrageEndTooltip"],  colorLabel = L["EvokerDevastationIndicatorDragonrageEndColor"] },
			{ key = "dragonrage",     label = L["EvokerDevastationColorPickerDragonrage"],      tooltip = L["EvokerDevastationIndicatorDragonrageTooltip"],     colorLabel = L["EvokerDevastationIndicatorDragonrageColor"] },
			{ key = "essenceBurst",   label = L["EvokerEssenceBurst"],                          tooltip = L["EvokerDevastationIndicatorEssenceBurstTooltip"],   colorLabel = L["EvokerDevastationIndicatorEssenceBurstColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "essences", label = L["BarNameEssences"] },
		},
		ddNamePrefix = "TwintopResourceBar_Evoker_Devastation",
		endOfConfigs = {
			{
				endOfKey = "dragonrage",
				sectionHeader = L["EvokerDevastationEndOfDragonrageConfigurationHeader"],
				gcdRadioLabel = L["EvokerDevastationCheckboxDragonrageGcds"],
				gcdSliderLabel = L["EvokerDevastationDragonrageGcds"],
				timeRadioLabel = L["EvokerDevastationCheckboxDragonrageTime"],
				timeSliderLabel = L["EvokerDevastationDragonrageTime"],
			},
		},
	}))

	yCoord = yCoord - 40
end

local function DevastationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 13, 1, yCoord, true, L["ResourceEssence"])
end

local function DevastationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], "notFull", true, L["ResourceEssence"], true)
end

local function DevastationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 1, yCoord)
end

local function DevastationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 1
	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	
	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurst"], L["EvokerAudioCheckboxEssenceBurstTooltip"])
	
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["secondaryThreshold"].configuration.thresholdValue = value
	end)
end

local function DevastationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_devastation
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 13, 1, yCoord, cache)
end

local function DevastationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.evoker_devastation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.devastationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Devastation")
	TRB.Options.OptionsFrame:RegisterSpecPanel("evoker", "evoker_devastation", L["EvokerDevastationFull"], interfaceSettingsFrame.devastationDisplayPanel)

	parent = interfaceSettingsFrame.devastationDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["EvokerDevastationFull"],
		TRB.Data.settings.core.enabled.evoker, "devastation",
		"TwintopResourceBar_Evoker_Devastation_devastationEvokerEnabled", "devastationEvokerEnabled",
		"evoker", "devastation")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_devastation = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = DevastationConstructManaBarPanel },
		{ key = "essenceBar", label = L["TabEssence"], width = oUi.tabWidth.small, constructor = DevastationConstructEssenceBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = DevastationConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = DevastationConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = DevastationConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = DevastationConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = DevastationConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = DevastationConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) DevastationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = DevastationConstructResetDefaultsPanel },
	}, yCoord)
end


--[[

Preservation Option Menus

]]

local function PreservationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_preservation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.preservation = PreservationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.preservation = PreservationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = PreservationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Preservation_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["EvokerPreservationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = PreservationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function PreservationConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"])
end

local function PreservationConstructEssenceBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceEssence"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function PreservationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 13, 2, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "innervate",    label = L["EvokerPreservationCheckboxInnervate"],  tooltip = L["EvokerPreservationIndicatorInnervateTooltip"],    colorLabel = L["EvokerPreservationIndicatorInnervateColor"] },
			{ key = "essenceBurst", label = L["EvokerEssenceBurst"],                   tooltip = L["EvokerPreservationIndicatorEssenceBurstTooltip"], colorLabel = L["EvokerPreservationIndicatorEssenceBurstColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "essences", label = L["BarNameEssences"] },
		},
		ddNamePrefix = "TwintopResourceBar_Evoker_Preservation",
	}))

	yCoord = yCoord - 40
end

local function PreservationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 13, 2, yCoord, true, L["ResourceEssence"])
end

local function PreservationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], "notFull", true, L["ResourceEssence"], true)
end

local function PreservationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5
	local f = nil

end

local function PreservationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 13, 2, yCoord)

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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 2
	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5
	local f = nil


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurst"], L["EvokerAudioCheckboxEssenceBurstTooltip"])

	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["secondaryThreshold"].configuration.thresholdValue = value
	end)
end

local function PreservationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_preservation
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 13, 2, yCoord, cache)
end

local function PreservationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.evoker_preservation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.preservationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Preservation")
	TRB.Options.OptionsFrame:RegisterSpecPanel("evoker", "evoker_preservation", L["EvokerPreservationFull"], interfaceSettingsFrame.preservationDisplayPanel)

	parent = interfaceSettingsFrame.preservationDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["EvokerPreservationFull"],
		TRB.Data.settings.core.enabled.evoker, "preservation",
		"TwintopResourceBar_Evoker_Preservation_preservationEvokerEnabled", "preservationEvokerEnabled",
		"evoker", "preservation")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_preservation = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = PreservationConstructManaBarPanel },
		{ key = "essenceBar", label = L["TabEssence"], width = oUi.tabWidth.small, constructor = PreservationConstructEssenceBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = PreservationConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = PreservationConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = PreservationConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = PreservationConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = PreservationConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = PreservationConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) PreservationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = PreservationConstructResetDefaultsPanel },
	}, yCoord)
end




--[[

Augmentation Option Menus

]]


local function AugmentationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_augmentation
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.augmentation = AugmentationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.evoker.augmentation = AugmentationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AugmentationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Evoker_Augmentation_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["EvokerAugmentationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AugmentationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function AugmentationConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"])
end

local function AugmentationConstructEssenceBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.base, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.penultimate, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.final, self)
	end)

	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceEssence"])

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)
end

local function AugmentationConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 13, 3, yCoord)
end

local function AugmentationConstructEbonMightBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	local ebonMightBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("ebonMight")
	if ebonMightBarDef then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord, ebonMightBarDef, L["ResourceMana"])
	end

	yCoord = yCoord - 90
	if ebonMightBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 13, 3, yCoord, ebonMightBarDef)
	end
end

local function AugmentationConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 13, 3, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "ebonMightDropDuringCast", label = L["EvokerAugmentationCheckboxEbonMightDropDuringCast"], tooltip = L["EvokerAugmentationIndicatorEbonMightDropDuringCastTooltip"], colorLabel = L["EvokerAugmentationIndicatorEbonMightDropDuringCastColor"] },
			{ key = "ebonMightEnd",            label = L["EvokerAugmentationCheckboxEndOfEbonMight"],          tooltip = L["EvokerAugmentationIndicatorEbonMightEndTooltip"],            colorLabel = L["EvokerAugmentationIndicatorEbonMightEndColor"] },
			{ key = "ebonMight",               label = L["EvokerAugmentationCheckboxEbonMight"],               tooltip = L["EvokerAugmentationIndicatorEbonMightTooltip"],               colorLabel = L["EvokerAugmentationIndicatorEbonMightColor"] },
			{ key = "essenceBurst",            label = L["EvokerEssenceBurst"],                                tooltip = L["EvokerAugmentationIndicatorEssenceBurstTooltip"],            colorLabel = L["EvokerAugmentationIndicatorEssenceBurstColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "essences", label = L["BarNameEssences"] },
			{ key = "ebonMight", label = L["BarNameEbonMight"] },
		},
		ddNamePrefix = "TwintopResourceBar_Evoker_Augmentation",
		endOfConfigs = {
			{
				endOfKey = "ebonMight",
				sectionHeader = L["EvokerAugmentationHeaderEndOfEbonMightConfiguration"],
				gcdRadioLabel = L["EvokerAugmentationEndOfEbonMightGcdMode"],
				gcdSliderLabel = L["EvokerAugmentationEndOfEbonMightGcdSlider"],
				timeRadioLabel = L["EvokerAugmentationEndOfEbonMightTimeMode"],
				timeSliderLabel = L["EvokerAugmentationEndOfEbonMightTimeSlider"],
			},
		},
	}))

	yCoord = yCoord - 40
end

local function AugmentationConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	local ebonMightBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("ebonMight")
	local customBars = {}
	if ebonMightBarDef then
		table.insert(customBars, ebonMightBarDef)
	end
	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 13, 3, yCoord, true, L["ResourceEssence"], false, customBars)
end

local function AugmentationConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	local ebonMightBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("ebonMight")
	local customBars = {}
	if ebonMightBarDef then
		table.insert(customBars, ebonMightBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], "notFull", true, L["ResourceEssence"], true, nil, customBars)
end

local function AugmentationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 13, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 3, yCoord)
end

local function AugmentationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 3
	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "essenceBurst", spec, classId, specId, yCoord, L["EvokerAudioCheckboxEssenceBurst"], L["EvokerAudioCheckboxEssenceBurstTooltip"])

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "ebonMightEnding", spec, classId, specId, yCoord, L["EvokerAugmentationAudioCheckboxEbonMightEnding"], L["EvokerAugmentationAudioCheckboxEbonMightEndingTooltip"])

	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi.Primitives:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.audio["secondaryThreshold"].configuration.thresholdValue = value
	end)
end

local function AugmentationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.evoker_augmentation
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 13, 3, yCoord, cache)
end

local function AugmentationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.evoker_augmentation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.augmentationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Augmentation")
	TRB.Options.OptionsFrame:RegisterSpecPanel("evoker", "evoker_augmentation", L["EvokerAugmentationFull"], interfaceSettingsFrame.augmentationDisplayPanel)

	parent = interfaceSettingsFrame.augmentationDisplayPanel

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["EvokerAugmentationFull"],
		TRB.Data.settings.core.enabled.evoker, "augmentation",
		"TwintopResourceBar_Evoker_Augmentation_augmentationEvokerEnabled", "augmentationEvokerEnabled",
		"evoker", "augmentation")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.evoker_augmentation = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = AugmentationConstructManaBarPanel },
		{ key = "essenceBar", label = L["TabEssence"], width = oUi.tabWidth.small, constructor = AugmentationConstructEssenceBarPanel },
		{ key = "ebonMightBar", label = L["TabEbonMight"], width = oUi.tabWidth.medium, constructor = AugmentationConstructEbonMightBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = AugmentationConstructHealthBarPanel },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = AugmentationConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = AugmentationConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = AugmentationConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = AugmentationConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = AugmentationConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) AugmentationConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = AugmentationConstructResetDefaultsPanel },
	}, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("evoker", L["Evoker"])

	DevastationConstructOptionsPanel(specCache.evoker_devastation)
	PreservationConstructOptionsPanel(specCache.evoker_preservation)
	AugmentationConstructOptionsPanel(specCache.evoker_augmentation)

	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Evoker.ConstructOptionsPanel = ConstructOptionsPanel
