local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Warrior = {}
TRB.Options.Warrior.Arms = {}
TRB.Options.Warrior.Fury = {}
TRB.Options.Warrior.Protection = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.arms = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.fury = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.protection = {}

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
	return textSettings
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
			}
		},
		maxResource = {
			value = ARMS_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
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
				borderOvercap = {
					color = "FF800000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000"
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


---Loads default bar text settings for Fury
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function FuryLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
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
			}
		},
		maxResource = {
			value = FURY_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = FURY_MAX_RAGE
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
				borderOvercap = {
					color = "FF800000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000"
				},
				enrage = {
					color = "FFFFCC55",
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$ignorePainTime}[$ignorePainTime]",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = "Ignore Pain",
			position = {
				relativeToName = L["PositionCenter"],
				relativeTo = "CENTER",
				xPos = 0,
				relativeToFrameName = L["IgnorePain"],
				yPos = 0,
				relativeToFrame = "IgnorePain",
			},
			fontJustifyHorizontal = "LEFT",
			useDefaultFontSize = false,
			color = { color = "FFFFFFFF" },
			enabled = true,
		},
		{
			useDefaultFontColor = false,
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$shieldBlockTime}[$shieldBlockTime -] $shieldBlockCharges/$shieldBlockMaxCharges",
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontSize = 14,
			name = "Shield Block",
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
	return textSettings
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
	return textSettings
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
			}
		},
		maxResource = {
			value = PROTECTION_MAX_RAGE,
			enabled = false
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			defensives = "always",
			dragonriding = true
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
				borderOvercap = {
					color = "FF800000",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FFFF0000"
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
			suddenDeath={
				name = L["WarriorAudioSuddenDeathProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(false),
	}

	-- Add defensives bar textures
	settings.textures.defensivesBackground="Interface\\Tooltips\\UI-Tooltip-Background"
	settings.textures.defensivesBackgroundName="Blizzard Tooltip"
	settings.textures.defensivesBorder="Interface\\Buttons\\WHITE8X8"
	settings.textures.defensivesBorderName="1 Pixel"
	settings.textures.defensivesBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
	settings.textures.defensivesBarName=L["LSMStatusBarSmoother"]

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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.arms
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Arms_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ArmsConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.arms
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Arms_BarDisplay = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarDisplay"], yCoord-5)
	controls.buttons.exportButton_Warrior_Arms_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 1, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 1, 1, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], "notEmpty", false, nil, nil, false, nil, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 1, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], ARMS_MAX_RAGE)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], 1, ARMS_MAX_RAGE)
end

local function ArmsConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.arms
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warrior_Arms_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Warrior_Arms_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 1, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30

	controls.checkBoxes.cleaveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_cleave", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cleaveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdWhirlwindCleave"])
	f.tooltip = L["WarriorArmsThresholdWhirlwindCleaveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cleave.enabled or spec.thresholds.thresholdDictionary.whirlwind.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cleave.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.whirlwind.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.execute = TRB.Functions.OptionsUi:BuildLabel(parent, L["WarriorArmsThresholdExecute"], 5, yCoord, 350, 20, GameFontWhite)

	yCoord = yCoord - 25
	controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMinimumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdExecuteMinimum"])
	f.tooltip = L["WarriorArmsThresholdExecuteMinimumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMinimum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMinimum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMaximumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdExecuteMaximum"])
	f.tooltip = L["WarriorArmsThresholdExecuteMaximumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMaximum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMaximum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.hamstringThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_hamstring", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.hamstringThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdHamstring"])
	f.tooltip = L["WarriorArmsThresholdHamstringTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.hamstring.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.hamstring.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.ignorePainThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_ignorePain", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ignorePainThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdIgnorePain"])
	f.tooltip = L["WarriorArmsThresholdIgnorePainTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ignorePain.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ignorePain.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.impendingVictoryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdImpendingVictory"])
	f.tooltip = L["WarriorArmsThresholdImpendingVictoryTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.impendingVictory.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.impendingVictory.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.mortalStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_mortalStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mortalStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdMortalStrike"])
	f.tooltip = L["WarriorArmsThresholdMortalStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.mortalStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.mortalStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.rendThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_rend", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rendThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdRend"])
	f.tooltip = L["WarriorArmsThresholdRendTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rend.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rend.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shieldBlockThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdShieldBlock"])
	f.tooltip = L["WarriorArmsThresholdShieldBlockTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shieldBlock.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shieldBlock.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slamThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdSlam"])
	f.tooltip = L["WarriorArmsThresholdSlamTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.slam.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.slam.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.thunderClapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Arms_Threshold_Option_thunderClap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thunderClapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorArmsThresholdThunderClap"])
	f.tooltip = L["WarriorArmsThresholdThunderClapTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.thunderClap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.thunderClap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 1, yCoord, L["ResourceRage"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 1, yCoord)
end

local function ArmsConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.arms
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Arms_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Arms_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 1, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 1, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 1, yCoord)
end

local function ArmsConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 1
	local spec = TRB.Data.settings.warrior.arms

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.arms
	local yCoord = 5

	controls.buttons.exportButton_Warrior_Arms_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Warrior_Arms_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "suddenDeath", spec, classId, specId, yCoord, L["WarriorAudioCheckboxSuddenDeath"], L["WarriorAudioCheckboxSuddenDeathTooltip"])
end

local function ArmsConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.arms
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.arms
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warrior_Arms_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Arms_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 1, 1, yCoord, cache)
end

local function ArmsConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.arms or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.armsDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Arms")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "arms", L["WarriorArmsFull"], interfaceSettingsFrame.armsDisplayPanel)
	
	parent = interfaceSettingsFrame.armsDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["WarriorArmsFull"],
		TRB.Data.settings.core.enabled.warrior, "arms",
		"TwintopResourceBar_Warrior_Arms_armsWarriorEnabled", "armsWarriorEnabled",
		"exportButton_Warrior_Arms_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorArmsFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 1, true, true, true, true, true, false)
		end)

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
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
			This spec doesn't use Audio & Tracking. Don't let this tab be made/rendered.
		]]
		if i == 4 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.arms = controls

	ArmsConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	ArmsConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	ArmsConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--ArmsConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	ArmsConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	ArmsConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Fury Option Menus

]]

local function FuryConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.fury
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Fury_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function FuryConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.fury
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Fury_BarDisplay = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarDisplay"], yCoord-5)
	controls.buttons.exportButton_Warrior_Fury_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 1, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 1, 2, yCoord, false)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], "notEmpty", false, nil, nil, false, nil, true)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"])

	--[[yCoord = yCoord - 30
	controls.colors.enrage = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorFuryColorPickerEnrage"], spec.colors.bar.enrage.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.enrage
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "enrage")
	end)]]

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 1, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], FURY_MAX_RAGE)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], 1, FURY_MAX_RAGE)
end

local function FuryConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.fury
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warrior_Fury_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Warrior_Fury_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 1, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.execute = TRB.Functions.OptionsUi:BuildLabel(parent, L["WarriorFuryThresholdExecute"], 5, yCoord, 350, 20, GameFontWhite)

	yCoord = yCoord - 25
	controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMinimumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdExecuteMinimum"])
	f.tooltip = L["WarriorFuryThresholdExecuteMinimumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMinimum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMinimum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMaximumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdExecuteMaximum"])
	f.tooltip = L["WarriorFuryThresholdExecuteMaximumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMaximum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMaximum.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.hamstringThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_hamstring", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.hamstringThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdHamstring"])
	f.tooltip = L["WarriorFuryThresholdHamstringTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.hamstring.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.hamstring.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.impendingVictoryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdImpendingVictory"])
	f.tooltip = L["WarriorFuryThresholdImpendingVictoryTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.impendingVictory.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.impendingVictory.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.rampageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_rampage", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rampageThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdRampage"])
	f.tooltip = L["WarriorFuryThresholdRampageTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rampage.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rampage.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shieldBlockThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdShieldBlock"])
	f.tooltip = L["WarriorFuryThresholdShieldBlockTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shieldBlock.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shieldBlock.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slamThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdSlam"])
	f.tooltip = L["WarriorFuryThresholdSlamTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.slam.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.slam.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.thunderClapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Fury_Threshold_Option_thunderClap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.thunderClapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorFuryThresholdThunderClap"])
	f.tooltip = L["WarriorFuryThresholdThunderClapTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.thunderClap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.thunderClap.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 2, yCoord, L["ResourceRage"], true, true, true, true, nil)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 2, yCoord)
end

local function FuryConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.fury
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Fury_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Fury_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 1, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 1, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 2, yCoord)
end

local function FuryConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 2
	local spec = TRB.Data.settings.warrior.fury

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.fury
	local yCoord = 5

	controls.buttons.exportButton_Warrior_Fury_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Warrior_Fury_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function FuryConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.fury
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.fury
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warrior_Fury_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Fury_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 1, 2, yCoord, cache)
end

local function FuryConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.fury or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.furyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Fury")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "fury", L["WarriorFuryFull"], interfaceSettingsFrame.furyDisplayPanel)
	
	parent = interfaceSettingsFrame.furyDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["WarriorFuryFull"],
		TRB.Data.settings.core.enabled.warrior, "fury",
		"TwintopResourceBar_Warrior_Fury_furyWarriorEnabled", "furyWarriorEnabled",
		"exportButton_Warrior_Fury_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorFuryFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 2, true, true, true, true, true, false)
		end)

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
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
			This spec doesn't use Audio & Tracking. Don't let this tab be made/rendered.
		]]
		if i == 4 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.fury = controls

	FuryConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	FuryConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	FuryConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--FuryConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	FuryConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	FuryConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Protection Option Menus

]]

local function ProtectionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.protection
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warrior_Protection_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ProtectionConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.protection
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Protection_BarDisplay = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarDisplay"], yCoord-5)
	controls.buttons.exportButton_Warrior_Protection_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 1, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives"), L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 1, 3, yCoord, false, nil, false, { TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives") })

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], "notEmpty", false, nil, nil, false, nil, true)

	-- Defensives bar visibility using custom bar system
	yCoord = yCoord - 70
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarVisibilityOptions(parent, controls, spec, 1, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives"))

	yCoord = yCoord - 20
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], true, false)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 1, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives"))

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], PROTECTION_MAX_RAGE)
	
	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], 1, PROTECTION_MAX_RAGE)
end

local function ProtectionConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.protection
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warrior_Protection_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Warrior_Protection_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 1, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.execute = TRB.Functions.OptionsUi:BuildLabel(parent, L["WarriorProtectionThresholdExecute"], 5, yCoord, 350, 20, GameFontWhite)
	
	yCoord = yCoord - 25
	controls.checkBoxes.executeMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_executeMinimum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMinimumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdExecuteMinimum"])
	f.tooltip = L["WarriorProtectionThresholdExecuteMinimumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMinimum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMinimum.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.executeMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_executeMaximum", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.executeMaximumThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdExecuteMaximum"])
	f.tooltip = L["WarriorProtectionThresholdExecuteMaximumTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.executeMaximum.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.executeMaximum.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.hamstringThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_hamstring", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.hamstringThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdHamstring"])
	f.tooltip = L["WarriorProtectionThresholdHamstringTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.hamstring.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.hamstring.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.ignorePainThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_ignorePain", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ignorePainThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdIgnorePain"])
	f.tooltip = L["WarriorProtectionThresholdIgnorePainTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ignorePain.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ignorePain.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.impendingVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_impendingVictory", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.impendingVictoryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdImpendingVictory"])
	f.tooltip = L["WarriorProtectionThresholdImpendingVictoryTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.impendingVictory.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.impendingVictory.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.rendThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_rend", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rendThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdRend"])
	f.tooltip = L["WarriorProtectionThresholdRendTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rend.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rend.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.revengeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_revenge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.revengeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdRevenge"])
	f.tooltip = L["WarriorProtectionThresholdRevengeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.revenge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.revenge.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.shieldBlockThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_shieldBlock", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shieldBlockThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdShieldBlock"])
	f.tooltip = L["WarriorProtectionThresholdShieldBlockTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shieldBlock.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shieldBlock.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.slamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_slam", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.slamThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdSlam"])
	f.tooltip = L["WarriorProtectionThresholdSlamTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.slam.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.slam.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.checkBoxes.whirlwindThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Warrior_Protection_Threshold_Option_whirlwind", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.whirlwindThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarriorProtectionThresholdWhirlwind"])
	f.tooltip = L["WarriorProtectionThresholdWhirlwindTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.whirlwind.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.whirlwind.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 1, 3, yCoord, L["ResourceRage"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 1, 3, yCoord)
end

local function ProtectionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.protection
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warrior_Protection_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Protection_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 1, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarriorProtectionTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 1, 3, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorProtectionTextColorPickerCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarriorColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 1, 3, yCoord)
end

local function ProtectionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 1
	local specId = 3
	local spec = TRB.Data.settings.warrior.protection

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.protection
	local yCoord = 5

	controls.buttons.exportButton_Warrior_Protection_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
	controls.buttons.exportButton_Warrior_Protection_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function ProtectionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warrior.protection
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.protection
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warrior_Protection_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
	controls.buttons.exportButton_Warrior_Protection_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 1, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 1, 3, yCoord, cache)
end

local function ProtectionConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(1, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.protection or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}

	interfaceSettingsFrame.protectionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warrior_Protection")
	TRB.Options.OptionsFrame:RegisterSpecPanel("warrior", "protection", L["WarriorProtectionFull"], interfaceSettingsFrame.protectionDisplayPanel)
	
	parent = interfaceSettingsFrame.protectionDisplayPanel

	controls.buttons = controls.buttons or {}

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["WarriorProtectionFull"],
		TRB.Data.settings.core.enabled.warrior, "protection",
		"TwintopResourceBar_Warrior_Protection_protectionWarriorEnabled", "protectionWarriorEnabled",
		"exportButton_Warrior_Protection_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarriorProtectionFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 1, 3, true, true, true, true, true, false)
		end)

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab2", L["TabThresholds"], 2, parent, 100, tabs[1])
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
			This spec doesn't use Audio & Tracking. Don't let this tab be made/rendered.
		]]
		if i == 4 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.protection = controls

	ProtectionConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	ProtectionConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	ProtectionConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	--ProtectionConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	ProtectionConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	ProtectionConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("warrior", L["Warrior"])
	ArmsConstructOptionsPanel(specCache.arms)
	FuryConstructOptionsPanel(specCache.fury)
	ProtectionConstructOptionsPanel(specCache.protection)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Warrior.ConstructOptionsPanel = ConstructOptionsPanel