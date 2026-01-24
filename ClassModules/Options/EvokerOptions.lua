local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on a Evoker!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Evoker = {}
TRB.Options.Evoker.Devastation = {}
TRB.Options.Evoker.Preservation = {}
TRB.Options.Evoker.Augmentation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = {}

---Loads extra default bar text settings for Evoker
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function EvokerLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=0}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=1}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=2}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=3}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=4}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		},
		{
			enabled = true,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = L["PositionLeft"],
			text = "{$essence=5}[$essenceRegenTime]",
			fontSize = 14,
			color = "FFFFFFFF",
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
			fontFaceName = "Friz Quadrata TT",
			useDefaultFontColor = false,
		}
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end

-- Devastation
---Loads default bar text settings for Devastation
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DevastationLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local extraTextSettings = EvokerLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
				penultimate="FFFF9900",
				final="FFFF0000",
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
			}
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
			secondaryThreshold={
				name = L["EssenceThresholdAudio"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					thresholdValue = 2
				}
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
	return textSettings
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
			primary = "always",
			secondary = "always",
			health = "always",
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				innervate="FF00FF00",
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false
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
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="{$ebonMightTime}[#ebonMight $ebonMightTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		})
	else
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="{$ebonMightTime}[#ebonMight $ebonMightTime]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=14,
			color = "FFFFFFFF",
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		})
	end

	local extraTextSettings = EvokerLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
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
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				inEbonMight = {
					color = "FFFF9900",
					enabled = true
				},
				inEbonMight1GCD = {
					color = "FFFF0000",
					enabled = true
				},
				ebonMightDropDuringCast = {
					color = "FF550000",
					enabled = true
				}
			},
			comboPoints = {
				border="FF246759",
				background="66000000",
				base="FF33937F",
				penultimate="FFFF9900",
				final="FFFF0000",
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
			}
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
		},
		endOfEbonMight = {
			enabled = true,
			mode = "gcd",
			gcdsMax = 2,
			timeMax = 3.0
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.devastation
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Devastation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function DevastationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Devastation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 1, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceEssence"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 1, yCoord, L["ResourceMana"], false, false)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)		

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 13, 1, yCoord)

	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls
end

local function DevastationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Devastation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)
	
	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 1, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 1, yCoord)
end

local function DevastationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 1
	local spec = TRB.Data.settings.evoker.devastation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5

	controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	local controls = interfaceSettingsFrame.controls.devastation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Devastation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Devastation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 1, yCoord, cache)
end

local function DevastationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.devastation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.devastationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Devastation", UIParent)
	interfaceSettingsFrame.devastationDisplayPanel.name = L["EvokerDevastationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.devastationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["devastation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.devastationDisplayPanel, L["EvokerDevastationFull"])

	parent = interfaceSettingsFrame.devastationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerDevastationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.devastationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Devastation_devastationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.devastationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerDevastationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.devastation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.devastation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.devastationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.devastation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Devastation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Devastation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerDevastationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 1, true, true, true, true, true, false)
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
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking options. Don't let these tabs be made/rendered.
		]]
		if i == 2 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.devastation = controls

	DevastationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--DevastationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DevastationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	DevastationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DevastationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DevastationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end


--[[

Preservation Option Menus

]]

local function PreservationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.preservation
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Preservation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function PreservationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Preservation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 2, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceEssence"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"])
	
	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 2, yCoord, L["ResourceMana"], false, true)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Evoker_Preservation_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 13, 2, false, true, false, false, false, false)
	end)
end

local function PreservationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Preservation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 2, yCoord)

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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 2, yCoord)
end

local function PreservationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 2
	local spec = TRB.Data.settings.evoker.preservation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	local controls = interfaceSettingsFrame.controls.preservation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Preservation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Preservation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 2, yCoord, cache)
end

local function PreservationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.preservation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.preservationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Preservation", UIParent)
	interfaceSettingsFrame.preservationDisplayPanel.name = L["EvokerPreservationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.preservationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["preservation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.preservationDisplayPanel, L["EvokerPreservationFull"])

	parent = interfaceSettingsFrame.preservationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerPreservationFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.preservationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Preservation_preservationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.preservationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerPreservationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.preservation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.preservation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.preservationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.preservation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Preservation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Preservation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerPreservationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 2, true, true, true, true, true, false)
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
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines or Audio & Tracking options. Don't let these tabs be made/rendered.
		]]
		if i == 2 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.preservation = controls

	PreservationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--PreservationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	PreservationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	PreservationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	PreservationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	PreservationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end




--[[

Augmentation Option Menus

]]


local function AugmentationConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Evoker_Augmentation_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function AugmentationConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Augmentation_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 13, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], L["ResourceEssence"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 13, 3, yCoord, true, L["ResourceEssence"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["ResourceEssence"], true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"])
	
	yCoord = yCoord - 30
	controls.checkBoxes.inEbonMight = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Checkbox_inEbonMight", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.inEbonMight
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationCheckboxEbonMight"])
	f.tooltip = L["EvokerAugmentationCheckboxEbonMightTooltip"]
	f:SetChecked(spec.colors.bar.inEbonMight.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.inEbonMight.enabled = self:GetChecked()
	end)

	controls.colors.inEbonMight = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerAugmentationColorPickerEbonMight"], spec.colors.bar.inEbonMight.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inEbonMight
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "inEbonMight")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfEbonMight = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Checkbox_endOfEbonMight", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfEbonMight
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationCheckboxEndOfEbonMight"])
	f.tooltip = L["EvokerAugmentationCheckboxEndOfEbonMightTooltip"]
	f:SetChecked(spec.colors.bar.inEbonMight1GCD.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.inEbonMight1GCD.enabled = self:GetChecked()
	end)

	controls.colors.inEbonMight1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerAugmentationColorPickerEbonMightEnd"], spec.colors.bar.inEbonMight1GCD.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.inEbonMight1GCD
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "inEbonMight1GCD")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.ebonMightDropDuringCast = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_Checkbox_ebonMightDropDuringCast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.ebonMightDropDuringCast
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationCheckboxEbonMightDropDuringCast"])
	f.tooltip = L["EvokerAugmentationCheckboxEbonMightDropDuringCastTooltip"]
	f:SetChecked(spec.colors.bar.ebonMightDropDuringCast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.ebonMightDropDuringCast.enabled = self:GetChecked()
	end)

	controls.colors.ebonMightDropDuringCast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerAugmentationColorPickerEbonMightDropDuringCast"], spec.colors.bar.ebonMightDropDuringCast.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.ebonMightDropDuringCast
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "ebonMightDropDuringCast")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 13, 3, yCoord, L["ResourceMana"], false, false)

	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerEssenceColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceEssence"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerColorPickerEssenceBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30		
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["EvokerEssenceColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerEssenceCheckboxUseHighestForAll"])
	f.tooltip = L["EvokerEssenceCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 13, 3, yCoord)


	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerAugmentationHeaderEndOfEbonMightConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfEbonMightModeGCDs = CreateFrame("CheckButton", "TRB_EOEM_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfEbonMightModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationEndOfEbonMightGcdMode"])
	if spec.endOfEbonMight.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfEbonMightModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfEbonMightModeTime:SetChecked(false)
		spec.endOfEbonMight.mode = "gcd"
	end)

	controls.endOfEbonMightGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, L["EvokerAugmentationEndOfEbonMightGcdSlider"], 0.5, 10, spec.endOfEbonMight.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfEbonMightGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfEbonMight.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes.endOfEbonMightModeTime = CreateFrame("CheckButton", "TRB_EOEM_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfEbonMightModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["EvokerAugmentationEndOfEbonMightTimeMode"])
	if spec.endOfEbonMight.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfEbonMightModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfEbonMightModeTime:SetChecked(true)
		spec.endOfEbonMight.mode = "time"
	end)

	controls.endOfEbonMightTime = TRB.Functions.OptionsUi:BuildSlider(parent, L["EvokerAugmentationEndOfEbonMightTimeSlider"], 0, 15, spec.endOfEbonMight.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfEbonMightTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfEbonMight.timeMax = value
	end)
end

local function AugmentationConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Evoker_Augmentation_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 13, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 13, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DPSManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 13, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DPSColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 13, 3, yCoord)
end

local function AugmentationConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 13
	local specId = 3
	local spec = TRB.Data.settings.evoker.augmentation

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5

	controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "ebonMightEnding", spec, classId, specId, yCoord, L["EvokerAugmentationAudioCheckboxEbonMightEnding"], L["EvokerAugmentationAudioCheckboxEbonMightEndingTooltip"])

	local yCoord2 = yCoord - 20

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "secondaryThreshold", spec, classId, specId, yCoord, L["EvokerAudioCheckboxSecondaryThreshold"], L["EvokerAudioCheckboxSecondaryThresholdTooltip"])
	
	local title = string.format(L["SecondaryThresholdValueTitle"], L["ResourceEssence"])
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 6, spec.audio["secondaryThreshold"].configuration.thresholdValue, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord2)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	local controls = interfaceSettingsFrame.controls.augmentation
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Evoker_Augmentation_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Evoker_Augmentation_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 13, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 13, 3, yCoord, cache)
end

local function AugmentationConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(13, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.augmentation or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.augmentationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Evoker_Augmentation", UIParent)
	interfaceSettingsFrame.augmentationDisplayPanel.name = L["EvokerAugmentationFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.augmentationDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["augmentation"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.augmentationDisplayPanel, L["EvokerAugmentationFull"])

	parent = interfaceSettingsFrame.augmentationDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["EvokerAugmentationFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.augmentationEvokerEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Evoker_Augmentation_augmentationEvokerEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.augmentationEvokerEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)		
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["EvokerAugmentationFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.evoker.augmentation)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.evoker.augmentation = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.augmentationEvokerEnabled, TRB.Data.settings.core.enabled.evoker.augmentation, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)		
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Evoker_Augmentation_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Evoker_Augmentation_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["EvokerAugmentationFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 13, 3, true, true, true, true, true, false)
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
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab4", L["TabAudioTracking"], 4, parent, 120, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab5", L["TabBarText"], 5, parent, 60, tabs[4])
	tabs[6] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_" .. namePrefix .. "_Tab6", L["TabResetDefaults"], 6, parent, 100, tabs[5])

	yCoord = yCoord - 15

	for i = 1, 6 do
		--[[
			This spec doesn't use Threshold Lines. Don't let this tab be made/rendered.
		]]
		if i == 2 then
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.augmentation = controls

	AugmentationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--AugmentationConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	AugmentationConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	AugmentationConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	AugmentationConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	AugmentationConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	
	DevastationConstructOptionsPanel(specCache.devastation)
	PreservationConstructOptionsPanel(specCache.preservation)
	AugmentationConstructOptionsPanel(specCache.augmentation)
end
TRB.Options.Evoker.ConstructOptionsPanel = ConstructOptionsPanel