local _, TRB = ...
if TRB.Data.character.classId ~= 4 then --Only do this if we're on a Rogue!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Rogue = {}
TRB.Options.Rogue.Assassination = {}
TRB.Options.Rogue.Outlaw = {}
TRB.Options.Rogue.Subtlety = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = {}

local ASSASSINATION_MAX_ENERGY = 300
local OUTLAW_MAX_ENERGY = 250
local SUBTLETY_MAX_ENERGY = 200

---Loads default bar text settings for Assassination
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function AssassinationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings = AssassinationLoadDefaultBarTextSettings

---Loads default settings for Assassination
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function AssassinationLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
			thresholdDictionary = {
				-- Rogue
				ambush = {
					enabled = true,
				},
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = true,
				},
				distract = {
					enabled = false,
				},
				feint = {
					enabled = true,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sliceAndDice = {
					enabled = true,
				},
				-- Assassination
				crimsonTempest = {
					enabled = true,
				},
				envenom = {
					enabled = true,
				},
				fanOfKnives = {
					enabled = true,
				},
				garrote = {
					enabled = true,
				},
				kingsbane = {
					enabled = true,
				},
				mutilate = {
					enabled = true,
				},
				poisonedKnife = {
					enabled = false,
				},
				rupture = {
					enabled = true,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
			}
		},
		maxResource = {
			value = ASSASSINATION_MAX_ENERGY,
			enabled = false
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
		colors = {
			text = {
				current = {
					color = "FFFFFF00"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFD59900"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFFFD300",
				borderStealth="FF000000",
				background="66000000",
				base="FFFFFF00"
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				sameColor=false,
				consistentUnfilledColor = false,
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
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
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
			blindside={
				name = L["RogueAssassinationAudioBlindsideProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = AssassinationLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Outlaw
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function OutlawLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings = OutlawLoadDefaultBarTextSettings

---Loads default settings for Outlaw
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function OutlawLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
			thresholdDictionary = {
			-- Rogue
				ambush = {
					enabled = true,
				},
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = true,
				},
				distract = {
					enabled = false,
				},
				feint = {
					enabled = true,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sinisterStrike = {
					enabled = true,
				},
				sliceAndDice = {
					enabled = true,
				},
				-- Outlaw
				betweenTheEyes = {
					enabled = true,
				},
				bladeFlurry = {
					enabled = true,
				},
				dispatch = {
					enabled = true,
				},
				killingSpree = {
					enabled = true,
				},
				pistolShot = {
					enabled = true,
				},
				rollTheBones = {
					enabled = true,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
				--Trickster
				coupDeGrace = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = OUTLAW_MAX_ENERGY,
			enabled = false
		},
		displayBar = {
			primary = "combat",
			secondary = "combat",
			health = "combat",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		colors = {
			text = {
				current = {
					color = "FFFFFF00"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFD59900"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFFFD300",
				borderStealth="FF000000",
				borderRtbBad="FFFF8888",
				borderRtbGood="FF00FF00",
				background="66000000",
				base="FFFFFF00"
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				sameColor=false,
				consistentUnfilledColor = false
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
				restlessBlades = {
					color = "FFFFFF00",
					enabled = true
				},
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				},
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
			opportunity={
				name = L["RogueOutlawAudioOpportunityProc"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = OutlawLoadDefaultBarTextSettings(classic)
	end

	return settings
end


---Loads default bar text settings for Subtlety
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function SubtletyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings = SubtletyLoadDefaultBarTextSettings

---Loads default settings for Subtlety
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function SubtletyLoadDefaultSettings(includeBarText, classic)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			properties = {
				width = 2,
				overlapBorder=true
			},
			icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
			thresholdDictionary = {
				-- Rogue
				-- Technically a Rogue ability but missing from Assassination and Outlaw
				cheapShot = {
					enabled = false,
				},
				crimsonVial = {
					enabled = true,
				},
				distract = {
					enabled = false,
				},
				eviscerate = {
					enabled = true,
				},
				feint = {
					enabled = true,
				},
				gouge = {
					enabled = false,
				},
				kidneyShot = {
					enabled = false,
				},
				sap = {
					enabled = false,
				},
				shiv = {
					enabled = false,
				},
				sliceAndDice = {
					enabled = true,
				},
				-- Subtlety
				backstab = {
					enabled = true,
				},
				blackPowder = {
					enabled = true,
				},
				gloomblade = {
					enabled = true,
				},
				goremawsBite = {
					enabled = true,
				},
				secretTechnique = {
					enabled = true,
				},
				shadowstrike = {
					enabled = true,
				},
				shurikenStorm = {
					enabled = true,
				},
				shurikenToss = {
					enabled = true,
				},
				-- PvP					
				deathFromAbove = {
					enabled = false,
				},
				dismantle = {
					enabled = false,
				},
				--Trickster
				coupDeGrace = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = SUBTLETY_MAX_ENERGY,
			enabled = false
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
		colors = {
			text = {
				current = {
					color = "FFFFFF00"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFD59900"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = false
				}
			},
			bar = {
				border="FFFFD300",
				borderStealth="FF000000",
				borderShadowcraft = "FF431863",
				background="66000000",
				base="FFFFFF00"
			},
			comboPoints = {
				border="FFFFD300",
				background="66000000",
				base="FFFFFF00",
				penultimate="FFFF9900",
				final="FFFF0000",
				echoingReprimand="FF68CCEF",
				shadowTechniques="FF431863",
				sameColor=false,
				consistentUnfilledColor = false
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
				echoingReprimand = {
					color = "FF68CCEF",
					enabled = true
				},
				outOfRange = {
					color = "FF440000",
					enabled = true,
					show = true
				},
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
		settings.displayText.barText = SubtletyLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Rogue
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.rogue.assassination = AssassinationLoadDefaultSettings(includeBarText, classic)
	settings.rogue.outlaw = OutlawLoadDefaultSettings(includeBarText, classic)
	settings.rogue.subtlety = SubtletyLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Rogue.LoadDefaultSettings = LoadDefaultSettings

--[[

Assassination Option Menus

]]

local function AssassinationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.assassination
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.assassination = AssassinationLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.assassination = AssassinationLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueAssassinationFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AssassinationLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function AssassinationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 1, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], "notFull", false, nil, nil, true, L["ResourceComboPoints"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], true, false)

	yCoord = yCoord - 30
	controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerStealth"], spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderStealth
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
	end)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["ComboPointsCheckboxAlwaysDefaultBackground"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], 1, ASSASSINATION_MAX_ENERGY)
end

local function AssassinationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Rogue_Assassination_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 4, 1, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	local yCoord2 = yCoord

	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ambushThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdAmbush"])
	f.tooltip = L["RogueAssassinationThresholdAmbushTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ambush.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ambush.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCheapShot"])
	f.tooltip = L["RogueAssassinationThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.crimsonTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonTempest", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonTempestThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCrimsonTempest"])
	f.tooltip = L["RogueAssassinationThresholdCrimsonTempestTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.crimsonTempest.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.crimsonTempest.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.fanOfKnivesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_fanOfKnives", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.fanOfKnivesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdFanOfKnives"])
	f.tooltip = L["RogueAssassinationThresholdFanOfKnivesTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.fanOfKnives.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.fanOfKnives.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.garroteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_garrote", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.garroteThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdGarrote"])
	f.tooltip = L["RogueAssassinationThresholdGarroteTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.garrote.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.garrote.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdGouge"])
	f.tooltip = L["RogueAssassinationThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.kingsbaneThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kingsbane", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kingsbaneThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdKingsbane"])
	f.tooltip = L["RogueAssassinationThresholdKingsbaneTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.kingsbane.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.kingsbane.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.mutilateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_mutilate", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mutilateThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdMutilate"])
	f.tooltip = L["RogueAssassinationThresholdMutilateTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.mutilate.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.mutilate.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.poisonedKnifeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_poisonedKnife", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.poisonedKnifeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdPoisonedKnife"])
	f.tooltip = L["RogueAssassinationThresholdPoisonedKnifeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.poisonedKnife.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.poisonedKnife.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdShiv"])
	f.tooltip = L["RogueAssassinationThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shiv.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDeathFromAbove"])
	f.tooltip = L["RogueAssassinationThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDismantle"])
	f.tooltip = L["RogueAssassinationThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.dismantle.enabled = self:GetChecked()
	end)

	
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20
	controls.checkBoxes.envenomThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_envenom", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.envenomThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdEnvenom"])
	f.tooltip = L["RogueAssassinationThresholdEnvenomTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.envenom.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.envenom.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdKidneyShot"])
	f.tooltip = L["RogueAssassinationThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSliceAndDice"])
	f.tooltip = L["RogueAssassinationThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ruptureThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdRupture"])
	f.tooltip = L["RogueAssassinationThresholdRuptureTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rupture.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rupture.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdCrimsonVial"])
	f.tooltip = L["RogueAssassinationThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDistract"])
	f.tooltip = L["RogueAssassinationThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.distract.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdFeint"])
	f.tooltip = L["RogueAssassinationThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.feint.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdSap"])
	f.tooltip = L["RogueAssassinationThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sap.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueAssassinationColorPickerThresholdSpecial"],
			enabledCheckboxLocalization = L["RogueAssassinationColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueAssassinationColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueAssassinationColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = math.min(yCoord, yCoord2)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 1, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 1, yCoord)
end

local function AssassinationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 4, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 1, yCoord)
end

local function AssassinationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 1
	local spec = TRB.Data.settings.rogue.assassination

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function AssassinationConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.assassination
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.assassination
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Assassination_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 1, yCoord, cache)
end

local function AssassinationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.assassination or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.assassinationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Assassination", UIParent)
	interfaceSettingsFrame.assassinationDisplayPanel.name = L["RogueAssassinationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.assassinationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["assassination"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.assassinationDisplayPanel, L["RogueAssassinationFull"])
	
	parent = interfaceSettingsFrame.assassinationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueAssassinationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.assassinationRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_assassinationRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.assassinationRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueAssassinationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.assassination)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.assassination = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Assassination_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueAssassinationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls

	AssassinationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	AssassinationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	AssassinationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	AssassinationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	AssassinationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	AssassinationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Outlaw Option Menus

]]

local function OutlawConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.outlaw = OutlawLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.outlaw = OutlawLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueOutlawFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = OutlawLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function OutlawConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 2, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], "notFull", false, nil, nil, true, L["ResourceComboPoints"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], true, false)

	yCoord = yCoord - 30
	controls.colors.borderRtbGood = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesHold"], spec.colors.bar.borderRtbGood, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbGood
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbGood")
	end)

	yCoord = yCoord - 30
	controls.colors.borderRtbBad = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueOutlawColorPickerRollTheBonesUse"], spec.colors.bar.borderRtbBad, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderRtbBad
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderRtbBad")
	end)

	yCoord = yCoord - 30
	controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerStealth"], spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderStealth
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
	end)


	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["RogueOutlawCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], 1, OUTLAW_MAX_ENERGY)
end

local function OutlawConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Rogue_Outlaw_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 4, 2, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	
	local yCoord2 = yCoord

	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ambushThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdAmbush"])
	f.tooltip = L["RogueOutlawThresholdAmbushTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.ambush.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.ambush.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdCheapShot"])
	f.tooltip = L["RogueOutlawThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdGouge"])
	f.tooltip = L["RogueOutlawThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.pistolShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_pistolShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.pistolShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdPistolShot"])
	f.tooltip = L["RogueOutlawThresholdPistolShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.pistolShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.pistolShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdShiv"])
	f.tooltip = L["RogueOutlawThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shiv.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.sinisterStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sinisterStrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sinisterStrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSinisterStrike"])
	f.tooltip = L["RogueOutlawThresholdSinisterStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sinisterStrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sinisterStrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDeathFromAbove"])
	f.tooltip = L["RogueOutlawThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueAssassinationThresholdDismantle"])
	f.tooltip = L["RogueAssassinationThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.dismantle.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25

	
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.betweenTheEyesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_betweenTheEyes", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.betweenTheEyesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdBetweenTheEyes"])
	f.tooltip = L["RogueOutlawThresholdBetweenTheEyesTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.betweenTheEyes.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.betweenTheEyes.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.dispatchThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_dispatch", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dispatchThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDispatch"])
	f.tooltip = L["RogueOutlawThresholdDispatchTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.dispatch.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.dispatch.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.coupDeGrace.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdKidneyShot"])
	f.tooltip = L["RogueOutlawThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.killingSpreeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_killingSpree", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.killingSpreeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdKillingSpree"])
	f.tooltip = L["RogueOutlawThresholdKillingSpreeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.killingSpree.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.killingSpree.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSliceAndDice"])
	f.tooltip = L["RogueOutlawThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.bladeFlurryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_bladeFlurry", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.bladeFlurryThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdBladeFlurry"])
	f.tooltip = L["RogueOutlawThresholdBladeFlurryTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.bladeFlurry.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.bladeFlurry.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdCrimsonVial"])
	f.tooltip = L["RogueOutlawThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdDistract"])
	f.tooltip = L["RogueOutlawThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.distract.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdFeint"])
	f.tooltip = L["RogueOutlawThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.feint.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.rollTheBonesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_rollTheBones", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.rollTheBonesThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdRollTheBones"])
	f.tooltip = L["RogueOutlawThresholdRollTheBonesTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.rollTheBones.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.rollTheBones.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueOutlawThresholdSap"])
	f.tooltip = L["RogueOutlawThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sap.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueOutlawColorPickerThresholdSpecial"],
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "restlessBlades",
			hasEnabledCheckbox = true,
			colorLocalization = L["RogueOutlawColorPickerThresholdRestlessBlades"],
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdRestlessBladesEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdRestlessBladesEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueOutlawColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = math.min(yCoord, yCoord2)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 2, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 2, yCoord)
end

local function OutlawConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 4, 2, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 2, yCoord)
end

local function OutlawConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 2
	local spec = TRB.Data.settings.rogue.outlaw

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function OutlawConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.outlaw
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.outlaw
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Outlaw_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 2, yCoord, cache)
end

local function OutlawConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.outlaw or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.outlawDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Outlaw", UIParent)
	interfaceSettingsFrame.outlawDisplayPanel.name = L["RogueOutlawFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.outlawDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["outlaw"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.outlawDisplayPanel, L["RogueOutlawFull"])
	
	parent = interfaceSettingsFrame.outlawDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueOutlawFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.outlawRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_outlawRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.outlawRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueOutlawFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.outlaw)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.outlaw = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Outlaw_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueOutlawFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls

	OutlawConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	OutlawConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	OutlawConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	OutlawConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	OutlawConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	OutlawConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

--[[

Subtlety Option Menus

]]

local function SubtletyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.subtlety = SubtletyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.rogue.subtlety = SubtletyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["RogueSubtletyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = SubtletyLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextClassic")
	end)

	yCoord = yCoord - 40
end

local function SubtletyConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 4, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], L["ResourceComboPoints"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 4, 3, yCoord, true, L["ResourceComboPoints"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], "notFull", false, nil, nil, true, L["ResourceComboPoints"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], true, false)

	--[[yCoord = yCoord - 30
	controls.colors.borderShadowcraft = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueSubtletyColorPickerShadowcraft"], spec.colors.bar.borderShadowcraft, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderShadowcraft
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderShadowcraft")
	end)]]

	yCoord = yCoord - 30
	controls.colors.borderStealth = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerStealth"], spec.colors.bar.borderStealth, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderStealth
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderStealth")
	end)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ComboPointColorsHeader"], oUi.xCoord, yCoord)
	
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceComboPoints"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.echoingReprimand = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueColorPickerEchoingReprimand"], spec.colors.comboPoints.echoingReprimand, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.echoingReprimand
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "echoingReprimand")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	controls.colors.comboPoints.shadowTechniques = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["RogueSubtletyColorPickerShadowTechniques"], spec.colors.comboPoints.shadowTechniques, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.shadowTechniques
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "shadowTechniques")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointCheckboxUseHighestForAll"])
	f.tooltip = L["ComboPointCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ComboPointColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 20
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ComboPointsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["RogueSubtletyCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], 1, SUBTLETY_MAX_ENERGY)
end

local function SubtletyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Rogue_Subtlety_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 4, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	
	local yCoord2 = yCoord

	controls.labels.builders = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryBuildersLabel"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.backstabThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_backstab", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.backstabThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdBackstab"])
	f.tooltip = L["RogueSubtletyThresholdBackstabTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.backstab.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.backstab.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.gloomblade.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.cheapShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdCheapShot"])
	f.tooltip = L["RogueSubtletyThresholdCheapShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.cheapShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.cheapShot.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.goremawsBiteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_goremawsbite", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.goremawsBiteThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdGoremawsBite"])
	f.tooltip = L["RogueSubtletyThresholdGoremawsBiteTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.goremawsBite.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.goremawsBite.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.gougeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_gouge", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.gougeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdGouge"])
	f.tooltip = L["RogueSubtletyThresholdGougeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.gouge.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.gouge.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shadowstrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shadowstrike", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowstrikeThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShadowStrike"])
	f.tooltip = L["RogueSubtletyThresholdShadowStrikeTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shadowstrike.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shadowstrike.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shivThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShiv"])
	f.tooltip = L["RogueSubtletyThresholdShivTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shiv.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shiv.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shurikenStormThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenStorm", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shurikenStormThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShurikenStorm"])
	f.tooltip = L["RogueSubtletyThresholdShurikenStormTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shurikenStorm.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shurikenStorm.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.shurikenTossThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shurikenToss", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shurikenTossThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdShurikenToss"])
	f.tooltip = L["RogueSubtletyThresholdShurikenTossTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shurikenToss.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shurikenToss.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.labels.pvpThreshold = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryPvpAbilities"], 5, yCoord, 110, 20)
	yCoord = yCoord - 20

	controls.checkBoxes.deathFromAboveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_deathFromAbove", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.deathFromAboveThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDeathFromAbove"])
	f.tooltip = L["RogueSubtletyThresholdDeathFromAboveTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.deathFromAbove.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.deathFromAbove.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dismantleThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_dismantle", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dismantleThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDismantle"])
	f.tooltip = L["RogueSubtletyThresholdDismantleTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.dismantle.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.dismantle.enabled = self:GetChecked()
	end)
	
	controls.labels.finishers = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryFinishersLabel"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.blackPowderThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_blackPowder", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.blackPowderThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdBlackPowder"])
	f.tooltip = L["RogueSubtletyThresholdBlackPowderTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.blackPowder.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.blackPowder.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.eviscerateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_eviscerate", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.eviscerateThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdEviscerate"])
	f.tooltip = L["RogueSubtletyThresholdEviscerateTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.eviscerate.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.eviscerate.enabled = self:GetChecked()
		spec.thresholds.thresholdDictionary.coupDeGrace.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.kidneyShotThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdKidneyShot"])
	f.tooltip = L["RogueSubtletyThresholdKidneyShotTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.kidneyShot.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.kidneyShot.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sliceAndDiceThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSliceAndDice"])
	f.tooltip = L["RogueSubtletyThresholdSliceAndDiceTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sliceAndDice.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sliceAndDice.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.secretTechniqueThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_secretTechnique", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.secretTechniqueThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSecretTechnique"])
	f.tooltip = L["RogueSubtletyThresholdSecretTechniqueTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.secretTechnique.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.secretTechnique.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.labels.utility = TRB.Functions.OptionsUi:BuildLabel(parent, L["ThresholdCategoryGeneralUtility"], oUi.xCoord2, yCoord2, 110, 20)
	yCoord2 = yCoord2 - 20

	controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.crimsonVialThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdCrimsonVial"])
	f.tooltip = L["RogueSubtletyThresholdCrimsonVialTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.crimsonVial.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.crimsonVial.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.distractThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdDistract"])
	f.tooltip = L["RogueSubtletyThresholdDistractTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.distract.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.distract.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.feintThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdFeint"])
	f.tooltip = L["RogueSubtletyThresholdFeintTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.feint.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.feint.enabled = self:GetChecked()
	end)

	yCoord2 = yCoord2 - 25
	controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sapThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord2)
	getglobal(f:GetName() .. 'Text'):SetText(L["RogueSubtletyThresholdSap"])
	f.tooltip = L["RogueSubtletyThresholdSapTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.sap.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.sap.enabled = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
		{
			name = "special",
			colorLocalization = L["RogueSubtletyColorPickerThresholdSpecial"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueSubtletyColorPickerThresholdSpecialEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueSubtletyColorPickerThresholdSpecialEnabledTooltip"]
		},
		{
			name = "echoingReprimand",
			colorLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimand"],
			hasEnabledCheckbox = true,
			enabledCheckboxLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimandEnabled"],
			enabledCheckboxTooltipLocalization = L["RogueSubtletyColorPickerThresholdEchoingReprimandEnabledTooltip"]
		}
	}

	yCoord = math.min(yCoord, yCoord2)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 4, 3, yCoord, L["ResourceEnergy"], true, true, true, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 4, 3, yCoord)
end

local function SubtletyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 4, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 4, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EnergyTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 4, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerCurrentEnergy"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerHaveEnoughEnergyToUseAbilityThreshold"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["CheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 4, 3, yCoord)
end

local function SubtletyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 4
	local specId = 3
	local spec = TRB.Data.settings.rogue.subtlety

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
end

local function SubtletyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.rogue.subtlety
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.subtlety
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Rogue_Subtlety_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Rogue_Subtlety_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 4, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 4, 3, yCoord, cache)
end

local function SubtletyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(4, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.subtlety or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.subtletyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Subtlety", UIParent)
	interfaceSettingsFrame.subtletyDisplayPanel.name = L["RogueSubtletyFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.subtletyDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["subtlety"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.subtletyDisplayPanel, L["RogueSubtletyFull"])

	parent = interfaceSettingsFrame.subtletyDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["RogueSubtletyFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.subtletyRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_subtletyRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.subtletyRogueEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["RogueSubtletyFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.rogue.subtlety)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.rogue.subtlety = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Rogue_Subtlety_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Rogue_Subtlety_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["RogueSubtletyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 4, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls

	SubtletyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	SubtletyConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	SubtletyConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	SubtletyConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	SubtletyConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	SubtletyConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	AssassinationConstructOptionsPanel(specCache.assassination)
	OutlawConstructOptionsPanel(specCache.outlaw)
	SubtletyConstructOptionsPanel(specCache.subtlety)
end
TRB.Options.Rogue.ConstructOptionsPanel = ConstructOptionsPanel