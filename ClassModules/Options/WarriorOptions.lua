local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Warrior = {}
TRB.Options.Warrior.Arms = {}
TRB.Options.Warrior.Fury = {}
TRB.Options.Warrior.Protection = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_arms = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_fury = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_protection = {}

local ARMS_MAX_RAGE = 130
local FURY_MAX_RAGE = 130
local PROTECTION_MAX_RAGE = 130

--[[
	Arms Defaults
]]

---Loads default bar text settings for Arms
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ArmsLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Warrior.ArmsLoadDefaultBarTextSettings = ArmsLoadDefaultBarTextSettings

---Loads default settings for Arms
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ArmsLoadDefaultSettings(includeBarText, classic)
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
				executeMinimum = {
					enabled = false,
				},
				executeMaximum = {
					enabled = true,
				},
				hamstring = {
					enabled = false,
				},
				shieldBlock = {
					enabled = false,
				},
				slam = {
					enabled = false,
				},
				whirlwind = {
					enabled = true,
				},
				impendingVictory = {
					enabled = true,
				},
				thunderClap = {
					enabled = false,
				},
				mortalStrike = {
					enabled = true,
				},
				rend = {
					enabled = false,
				},
				cleave = {
					enabled = true,
				},
				ignorePain = {
					enabled = false,
				}
			},
			customThresholds = {}
		},
		maxResource = {
			value = ARMS_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = ARMS_MAX_RAGE
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFFF0000"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFEA3C53"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FF800000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFC21807"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000",
					color2 = "FFFF0000",
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
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				}
			}
			,
			shared = {
				nodeOrder = {},
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					borderOvercap = {
						color = "FF800000",
						enabled = true,
						isGradient = true,
						targets = { rageBar = { bar = false, border = true, background = false } },
					},
				},
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
			suddenDeath={
				name = L["WarriorAudioSuddenDeathProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(),
	}

	if includeBarText then
		settings.displayText.barText = ArmsLoadDefaultBarTextSettings(classic)
	end

	return settings
end

--[[
	Fury Defaults
]]


---Loads only the Whirlwind charge bar text entries (no global resource text)
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FuryLoadWhirlwindBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["WarriorFuryBarTextNameWWCharge1"],
			guid = TRB.Functions.String:Guid(),
			text = "{$wwCharges=1}[$wwCharges - $wwTime]",
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Whirlwind_Charge_1",
				relativeToFrameName = L["WhirlwindCharge1"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["WarriorFuryBarTextNameWWCharge2"],
			guid = TRB.Functions.String:Guid(),
			text = "{$wwCharges=2}[$wwCharges - $wwTime]",
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Whirlwind_Charge_2",
				relativeToFrameName = L["WhirlwindCharge2"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["WarriorFuryBarTextNameWWCharge3"],
			guid = TRB.Functions.String:Guid(),
			text = "{$wwCharges=3}[$wwCharges - $wwTime]",
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Whirlwind_Charge_3",
				relativeToFrameName = L["WhirlwindCharge3"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["WarriorFuryBarTextNameWWCharge4"],
			guid = TRB.Functions.String:Guid(),
			text = "{$wwCharges=4}[$wwCharges - $wwTime]",
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Whirlwind_Charge_4",
				relativeToFrameName = L["WhirlwindCharge4"],
			},
		},
	}

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Warrior.FuryLoadWhirlwindBarTextSettings = FuryLoadWhirlwindBarTextSettings

---Loads default bar text settings for Fury
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FuryLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = FuryLoadWhirlwindBarTextSettings()

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Warrior.FuryLoadDefaultBarTextSettings = FuryLoadDefaultBarTextSettings

---Loads default settings for Fury
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function FuryLoadDefaultSettings(includeBarText, classic)
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
				executeMinimum = {
					enabled = true,
				},
				executeMaximum = {
					enabled = true,
				},
				hamstring = {
					enabled = false,
				},
				shieldBlock = {
					enabled = false,
				},
				slam = {
					enabled = false,
				},
				impendingVictory = {
					enabled = true,
				},
				thunderClap = {
					enabled = false,
				},
				rampage = {
					enabled = true,
				},
			},
			customThresholds = {}
		},
		maxResource = {
			value = FURY_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = FURY_MAX_RAGE
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Table:Merge(TRB.Functions.Settings:DefaultComboPointsDimensions(classic), { sameColor = false }),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFFF0000"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFEA3C53"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FF800000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFC21807"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				enrage = {
					color = "FFFFCC55",
					color2 = "FFFFCC55",
					gradientDirection = "disabled",
					enabled = true
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			bars = {
				whirlwind = TRB.Functions.Settings:DefaultWhirlwindBarColors(),
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
			}
			,
			shared = {
				nodeOrder = { "zeroStackBackground" },
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					zeroStackBackground = {
						color = "FF333333",
						enabled = true,
						targets = { whirlwindBar = { bar = false, border = false, background = true } },
					},
					borderOvercap = {
						color = "FF800000",
						enabled = true,
						isGradient = true,
						targets = { rageBar = { bar = false, border = true, background = false } },
					},
				},
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
			suddenDeath={
				name = L["WarriorAudioSuddenDeathProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = FuryLoadDefaultBarTextSettings(classic)
	end

	return settings
end

--[[
	Protection Defaults
]]

---Loads extra default bar text settings for Protection
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ProtectionLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$ignorePainTime}[$ignorePainTime]",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = L["IgnorePainTime"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["IgnorePainTime"],
				yPos = 0,
				relativeToFrame = "IgnorePain",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			color = { color = "FFFFFFFF" },
			enabled = true,
		},
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
			fontJustifyHorizontalName = L["PositionCenter"],
			text = "$ignorePainAbsorb%",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = L["IgnorePainAbsorb"],
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["IgnorePainAbsorb"],
				yPos = 0,
				relativeToFrame = "IgnorePainAbsorb",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = true,
			color = { color = "FFFFFFFF" },
			enabled = true,
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$shieldBlockTime}[$shieldBlockTime -] $shieldBlockCharges/$shieldBlockMaxCharges",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = L["ShieldBlock"],
			position = {
				relativeToName = L["ShieldBlock"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName =  L["ShieldBlock"],
				yPos = 0,
				relativeToFrame = "ShieldBlock",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			color = { color = "FFFFFFFF" },
			enabled = true,
		},
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

---Loads default bar text settings for Protection
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ProtectionLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local extraTextSettings = ProtectionLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Warrior.ProtectionLoadDefaultBarTextSettings = ProtectionLoadDefaultBarTextSettings

---Loads default settings for Protection
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ProtectionLoadDefaultSettings(includeBarText, classic)
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
				executeMinimum = {
					enabled = false,
				},
				executeMaximum = {
					enabled = true,
				},
				hamstring = {
					enabled = false,
				},
				ignorePain = {
					enabled = true,
				},
				impendingVictory = {
					enabled = true,
				},
				rend = {
					enabled = false,
				},
				revenge = {
					enabled = true,
				},
				shieldBlock = {
					enabled = true,
				},
				slam = {
					enabled = false,
				},
				whirlwind = {
					enabled = false,
				}
			},
			customThresholds = {}
		},
		maxResource = {
			value = PROTECTION_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			defensives = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = PROTECTION_MAX_RAGE
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			defensives = TRB.Functions.Settings:DefaultDefensivesBarDimensions(classic),
		},
		colors = {
			text = {
				current = {
					color = "FFFF0000"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFEA3C53"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				},
				overcap = {
					color = "FF800000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FFC21807"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				casting = {
					color = "FFFFFFFF",
					color2 = "FFFFFFFF",
					gradientDirection = "disabled",
					enabled = true
				},
			},
			bars = {
				defensives = TRB.Functions.Settings:DefaultDefensivesBarColors(),
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
			,
			shared = {
				nodeOrder = {},
				gradientOrder = { "borderOvercap" },
				indicatorColors = {
					borderOvercap = {
						color = "FF800000",
						enabled = true,
						isGradient = true,
						targets = { rageBar = { bar = false, border = true, background = false } },
					},
				},
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
			suddenDeath={
				name = L["WarriorAudioSuddenDeathProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, nil, {
			TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives"),
		}),
	}

	if includeBarText then
		settings.displayText.barText = ProtectionLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Warrior
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.warrior.arms = ArmsLoadDefaultSettings(includeBarText, classic)
	settings.warrior.fury = FuryLoadDefaultSettings(includeBarText, classic)
	settings.warrior.protection = ProtectionLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Warrior.LoadDefaultSettings = LoadDefaultSettings


--[[

Arms Option Menus

]]

local function ArmsConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_arms
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarriorArmsFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.arms = ArmsLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["WarriorArmsFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ArmsLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarriorArmsFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.arms = ArmsLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarriorArmsFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ArmsLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Arms_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarriorArmsFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ArmsLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ArmsConstructRageBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5
	local f = nil
	local classId = 1
	local specId = 1

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, classId, specId, yCoord, L["ResourceRage"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, classId, specId, yCoord, L["ResourceRage"], 1, ARMS_MAX_RAGE)
end

local function ArmsConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 1
	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {},
		gradientDefs = {
			{ key = "borderOvercap", label = L["WarriorIndicatorBorderOvercap"], tooltip = L["WarriorIndicatorOvercapTooltip"], colorLabel = L["WarriorIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "rageBar", label = L["BarNameRageBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Warrior_Arms",
		overcapConfig = {
			primaryResourceString = L["ResourceRage"],
			primaryResourceMax = ARMS_MAX_RAGE,
		},
	})

	yCoord = yCoord - 40
end

local function ArmsConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 1, 1, yCoord)
end

local function ArmsConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 1, 1, yCoord, false)
end

local function ArmsConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], "notEmpty", false, nil, true)
end

local function ArmsConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 1, 1, yCoord, {
		barTargetLabels = {
			primary = L["ResourceRage"],
		},
		labels = {
			executeMinimum = L["WarriorArmsThresholdExecuteMinimum"],
			executeMaximum = L["WarriorArmsThresholdExecuteMaximum"],
			cleave = L["WarriorArmsThresholdCleave"],
			whirlwind = L["WarriorArmsThresholdWhirlwind"],
			hamstring = L["WarriorArmsThresholdHamstring"],
			ignorePain = L["WarriorArmsThresholdIgnorePain"],
			impendingVictory = L["WarriorArmsThresholdImpendingVictory"],
			mortalStrike = L["WarriorArmsThresholdMortalStrike"],
			rend = L["WarriorArmsThresholdRend"],
			shieldBlock = L["WarriorArmsThresholdShieldBlock"],
			slam = L["WarriorArmsThresholdSlam"],
			thunderClap = L["WarriorArmsThresholdThunderClap"],
		},
		tooltips = {
			cleave = L["WarriorArmsThresholdCleaveTooltip"],
			whirlwind = L["WarriorArmsThresholdWhirlwindTooltip"],
			executeMinimum = L["WarriorArmsThresholdExecuteMinimumTooltip"],
			executeMaximum = L["WarriorArmsThresholdExecuteMaximumTooltip"],
			hamstring = L["WarriorArmsThresholdHamstringTooltip"],
			ignorePain = L["WarriorArmsThresholdIgnorePainTooltip"],
			impendingVictory = L["WarriorArmsThresholdImpendingVictoryTooltip"],
			mortalStrike = L["WarriorArmsThresholdMortalStrikeTooltip"],
			rend = L["WarriorArmsThresholdRendTooltip"],
			shieldBlock = L["WarriorArmsThresholdShieldBlockTooltip"],
			slam = L["WarriorArmsThresholdSlamTooltip"],
			thunderClap = L["WarriorArmsThresholdThunderClapTooltip"],
		},
	})
end

local function ArmsConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 1, yCoord)
end

local function ArmsConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 1, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 1, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 1, yCoord)
end

local function ArmsConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 1
	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi.Text:CreateAudioOption(parent, controls, "suddenDeath", spec, classId, specId, yCoord, L["WarriorAudioCheckboxSuddenDeath"], L["WarriorAudioCheckboxSuddenDeathTooltip"])
end

local function ArmsConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_arms
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 1, 1, yCoord, cache)
end

local function ArmsConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warrior_arms or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.armsDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Arms")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "warrior_arms", L["WarriorArmsFull"], interfaceSettingsFrame.armsDisplayPanel)
	
	parent = interfaceSettingsFrame.armsDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["WarriorArmsFull"],
		TRB.Data.settings.core.enabled.warrior, "arms",
		"TwintopResourceBar_Warrior_Arms_armsWarriorEnabled", "armsWarriorEnabled",
		"warrior", "arms")

	local tabDefinitions = {
		{ "rageBar", L["TabRage"], oUi.tabWidth.small, ArmsConstructRageBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ArmsConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, ArmsConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ArmsConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ArmsConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, ArmsConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, ArmsConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("warrior", "arms", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ArmsConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) ArmsConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ArmsConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_arms = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Fury Option Menus

]]

local function FuryConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_fury
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarriorFuryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.fury = FuryLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["WarriorFuryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FuryLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarriorFuryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.fury = FuryLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarriorFuryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FuryLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Fury_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarriorFuryFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = FuryLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FuryConstructRageBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5
	local f = nil
	local classId = 1
	local specId = 2

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 1, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], 1, FURY_MAX_RAGE)
end

local function FuryConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 2
	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {
			{ key = "zeroStackBackground", label = L["WarriorFuryCheckboxZeroStackBackground"], tooltip = L["WarriorFuryIndicatorZeroStackBackgroundTooltip"], colorLabel = L["WarriorFuryIndicatorZeroStackBackgroundColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap", label = L["WarriorIndicatorBorderOvercap"], tooltip = L["WarriorIndicatorOvercapTooltip"], colorLabel = L["WarriorIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "rageBar", label = L["BarNameRageBar"] },
			{ key = "whirlwindBar", label = L["BarNameWhirlwindBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Warrior_Fury",
		overcapConfig = {
			primaryResourceString = L["ResourceRage"],
			primaryResourceMax = FURY_MAX_RAGE,
		},
	})

	yCoord = yCoord - 40
end

local function FuryConstructWhirlwindBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], L["ResourceWarriorWhirlwind"])

	yCoord = yCoord - 60
	local whirlwindBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("whirlwind")
	if whirlwindBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 1, 2, yCoord, whirlwindBarDef)
	end
end

local function FuryConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 1, 2, yCoord)
end

local function FuryConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 1, 2, yCoord, true, L["ResourceWarriorWhirlwind"])
end

local function FuryConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], "notEmpty", true, L["ResourceWarriorWhirlwind"], true)
end

local function FuryConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 1, 2, yCoord, {
		barTargetLabels = {
			primary = L["ResourceRage"],
		},
		labels = {
			executeMinimum = L["WarriorFuryThresholdExecuteMinimum"],
			executeMaximum = L["WarriorFuryThresholdExecuteMaximum"],
			execute = L["WarriorFuryThresholdExecute"],
			hamstring = L["WarriorFuryThresholdHamstring"],
			impendingVictory = L["WarriorFuryThresholdImpendingVictory"],
			rampage = L["WarriorFuryThresholdRampage"],
			shieldBlock = L["WarriorFuryThresholdShieldBlock"],
			slam = L["WarriorFuryThresholdSlam"],
			thunderClap = L["WarriorFuryThresholdThunderClap"],
		},
		tooltips = {
			executeMinimum = L["WarriorFuryThresholdExecuteMinimumTooltip"],
			executeMaximum = L["WarriorFuryThresholdExecuteMaximumTooltip"],
			hamstring = L["WarriorFuryThresholdHamstringTooltip"],
			impendingVictory = L["WarriorFuryThresholdImpendingVictoryTooltip"],
			rampage = L["WarriorFuryThresholdRampageTooltip"],
			shieldBlock = L["WarriorFuryThresholdShieldBlockTooltip"],
			slam = L["WarriorFuryThresholdSlamTooltip"],
			thunderClap = L["WarriorFuryThresholdThunderClapTooltip"],
		},
	})
end

local function FuryConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5


	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], true, true, true, true, nil)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 2, yCoord)
end

local function FuryConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 1, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 1, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 2, yCoord)
end

local function FuryConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 2
	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function FuryConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_fury
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 1, 2, yCoord, cache)
end

local function FuryConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warrior_fury or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.furyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Fury")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "warrior_fury", L["WarriorFuryFull"], interfaceSettingsFrame.furyDisplayPanel)
	
	parent = interfaceSettingsFrame.furyDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["WarriorFuryFull"],
		TRB.Data.settings.core.enabled.warrior, "fury",
		"TwintopResourceBar_Warrior_Fury_furyWarriorEnabled", "furyWarriorEnabled",
		"warrior", "fury")

	local tabDefinitions = {
		{ "rageBar", L["TabRage"], oUi.tabWidth.small, FuryConstructRageBarPanel },
		{ "whirlwindBar", L["TabWhirlwind"], oUi.tabWidth.small, FuryConstructWhirlwindBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, FuryConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, FuryConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, FuryConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, FuryConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, FuryConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, FuryConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("warrior", "fury", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, FuryConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) FuryConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, FuryConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_fury = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


--[[

Protection Option Menus

]]

local function ProtectionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_protection
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warrior_Protection_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarriorProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.protection = ProtectionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Protection_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["WarriorProtectionFull"]),
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
	StaticPopupDialogs["TwintopResourceBar_Warrior_Protection_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["WarriorProtectionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warrior.protection = ProtectionLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warrior_Protection_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["WarriorProtectionFull"]),
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
	StaticPopupDialogs["TwintopResourceBar_Warrior_Protection_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["WarriorProtectionFull"]),
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
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ProtectionConstructRageBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5
	local f = nil
	local classId = 1
	local specId = 3

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], 1, PROTECTION_MAX_RAGE)
end

local function ProtectionConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 3
	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, {
		indicatorDefs = {},
		gradientDefs = {
			{ key = "borderOvercap", label = L["WarriorIndicatorBorderOvercap"], tooltip = L["WarriorIndicatorOvercapTooltip"], colorLabel = L["WarriorIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "rageBar", label = L["BarNameRageBar"] },
			{ key = "defensivesIgnorePainTimeBar", label = L["BarNameDefensivesIgnorePainTimeBar"] },
			{ key = "defensivesIgnorePainAbsorbBar", label = L["BarNameDefensivesIgnorePainAbsorbBar"] },
			{ key = "defensivesShieldBlockBar", label = L["BarNameDefensivesShieldBlockBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Warrior_Protection",
		overcapConfig = {
			primaryResourceString = L["ResourceRage"],
			primaryResourceMax = PROTECTION_MAX_RAGE,
		},
	})

	yCoord = yCoord - 40
end

local function ProtectionConstructDefensivesBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	local defensivesBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives")
	if defensivesBarDef then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord, defensivesBarDef, L["ResourceRage"])
	end

	yCoord = yCoord - 90
	if defensivesBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 1, 3, yCoord, defensivesBarDef)
	end
end

local function ProtectionConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 1, 3, yCoord)
end

local function ProtectionConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 1, 3, yCoord, false, nil, false, { TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives") })
end

local function ProtectionConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	local customBars = {}
	local defensivesBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives")
	if defensivesBarDef then
		table.insert(customBars, defensivesBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], "notEmpty", false, nil, true, nil, customBars)
end

local function ProtectionConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	controls.colors.threshold = {}

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 1, 3, yCoord, {
		barTargetLabels = {
			primary = L["ResourceRage"],
		},
		labels = {
			executeMinimum = L["WarriorProtectionThresholdExecuteMinimum"],
			executeMaximum = L["WarriorProtectionThresholdExecuteMaximum"],
			hamstring = L["WarriorProtectionThresholdHamstring"],
			ignorePain = L["WarriorProtectionThresholdIgnorePain"],
			impendingVictory = L["WarriorProtectionThresholdImpendingVictory"],
			rend = L["WarriorProtectionThresholdRend"],
			revenge = L["WarriorProtectionThresholdRevenge"],
			shieldBlock = L["WarriorProtectionThresholdShieldBlock"],
			slam = L["WarriorProtectionThresholdSlam"],
			whirlwind = L["WarriorProtectionThresholdWhirlwind"],
		},
		tooltips = {
			executeMinimum = L["WarriorProtectionThresholdExecuteMinimumTooltip"],
			executeMaximum = L["WarriorProtectionThresholdExecuteMaximumTooltip"],
			hamstring = L["WarriorProtectionThresholdHamstringTooltip"],
			ignorePain = L["WarriorProtectionThresholdIgnorePainTooltip"],
			impendingVictory = L["WarriorProtectionThresholdImpendingVictoryTooltip"],
			rend = L["WarriorProtectionThresholdRendTooltip"],
			revenge = L["WarriorProtectionThresholdRevengeTooltip"],
			shieldBlock = L["WarriorProtectionThresholdShieldBlockTooltip"],
			slam = L["WarriorProtectionThresholdSlamTooltip"],
			whirlwind = L["WarriorProtectionThresholdWhirlwindTooltip"],
		},
	})
end

local function ProtectionConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5


	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 3, yCoord)
end

local function ProtectionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5
	local f = nil

	local title = ""


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["WarriorProtectionTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorProtectionTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorProtectionCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["WarriorCheckboxThresholdOvercapTooltip"]
	f:SetChecked(spec.colors.text.overcap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overcap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 3, yCoord)
end

local function ProtectionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 3
	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5


	controls.textSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function ProtectionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.warrior_protection
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 1, 3, yCoord, cache)
end

local function ProtectionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warrior_protection or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.protectionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Protection")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "warrior_protection", L["WarriorProtectionFull"], interfaceSettingsFrame.protectionDisplayPanel)
	
	parent = interfaceSettingsFrame.protectionDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["WarriorProtectionFull"],
		TRB.Data.settings.core.enabled.warrior, "protection",
		"TwintopResourceBar_Warrior_Protection_protectionWarriorEnabled", "protectionWarriorEnabled",
		"warrior", "protection")

	local tabDefinitions = {
		{ "rageBar", L["TabRage"], oUi.tabWidth.small, ProtectionConstructRageBarPanel },
		{ "defensivesBar", L["TabDefensives"], oUi.tabWidth.small, ProtectionConstructDefensivesBarPanel },
		{ "healthBar", L["TabHealth"], oUi.tabWidth.small, ProtectionConstructHealthBarPanel },
		{ "indicatorColors", L["TabIndicatorColors"], oUi.tabWidth.large, ProtectionConstructIndicatorColorsPanel },
		{ "barTextures", L["TabTextures"], oUi.tabWidth.small, ProtectionConstructBarTexturesPanel },
		{ "barVisibility", L["TabVisibility"], oUi.tabWidth.small, ProtectionConstructBarVisibilityPanel },
		{ "thresholdSettings", L["TabThresholdSettings"], oUi.tabWidth.xlarge, ProtectionConstructThresholdSettingsPanel },
		{ "thresholds", L["TabThresholds"], oUi.tabWidth.large, ProtectionConstructThresholdListPanel, true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("warrior", "protection", controls),
		{ "fontText", L["TabFontText"], oUi.tabWidth.medium, ProtectionConstructFontAndTextPanel },
		{ "barText", L["TabBarText"], oUi.tabWidth.small, function(scrollChild) ProtectionConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ "resetDefaults", L["TabResetDefaults"], oUi.tabWidth.medium, ProtectionConstructResetDefaultsPanel },
	}

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.warrior_protection = controls

	TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, tabDefinitions, yCoord)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("warrior", L["Warrior"])
	ArmsConstructOptionsPanel(specCache.warrior_arms)
	FuryConstructOptionsPanel(specCache.warrior_fury)
	ProtectionConstructOptionsPanel(specCache.warrior_protection)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Warrior.ConstructOptionsPanel = ConstructOptionsPanel
