---@diagnostic disable: undefined-field
local _, TRB = ...
if TRB.Data.character.classId ~= 5 then --Only do this if we're on a Priest!
	return
end

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Priest = {}
TRB.Options.Priest.Discipline = {}
TRB.Options.Priest.Holy = {}
TRB.Options.Priest.Shadow = {}

local SHADOW_MAX_INSANITY = 150

---Loads extra default bar text settings for Discipline
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DisciplineLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end

---Loads default bar text settings for Discipline
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DisciplineLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local extraTextSettings = DisciplineLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Priest.DisciplineLoadDefaultBarTextSettings = DisciplineLoadDefaultBarTextSettings

---Loads default settings for Discipline
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function DisciplineLoadDefaultSettings(includeBarText, classic)
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
					color = "FF0000FF"
				},
				surgeOfLight = {
					color = "FFFCE58E",
					enabled = true
				},
				shadowCovenant = {
					color = "FFC4A5E2",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF000099"
				},
				base = {
					color = "FF000099" --required for generic combo point code
				},
				background = {
					color = "66000000"
				},
				powerWordRadiance = {
					color = "FFFFDD22",
					enabled = true
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
				color = { color = "FFFFFFFF" },
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
			surgeOfLight={
				name = L["PriestAudioSurgeOfLight"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = DisciplineLoadDefaultBarTextSettings(classic)
	end

	return settings
end


---Loads extra default bar text settings for Holy
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end

---Loads default bar text settings for Holy
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("apotheosisTime", "apotheosis", classic, "CENTER", "CENTER"),
	}

	local extraTextSettings = HolyLoadExtraBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return textSettings
end
TRB.Options.Priest.HolyLoadDefaultBarTextSettings = HolyLoadDefaultBarTextSettings

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
			primary = "always",
			secondary = "always",
			health = "always",
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOfApotheosis = {
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
				},
			},
			bar = {
				border = {
					color = "FF000099"
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF0000FF"
				},
				apotheosis = {
					color = "FFFADA5E",
					enabled = true
				},
				apotheosisEnd = {
					color = "FFFF0000"
				},
				holyWordChastise = {
					color = "FFAAFFAA",
					enabled = false
				},
				holyWordSanctify = {
					color = "FF55FF55",
					enabled = true
				},
				holyWordSerenity = {
					color = "FF00FF00",
					enabled = true
				},
				surgeOfLight = {
					color = "FFFCE58E",
					enabled = true
				},
				resonantWords = {
					color = "FFAA00FF",
					enabled = true
				},
				lightweaver = {
					color = "FF00FFFF",
					enabled = true
				},
			},
			comboPoints = {
				border = {
					color = "FF000099"
				},
				base = {
					color = "FF000099" --required for generic combo point code
				},
				background = {
					color = "66000000"
				},
				holyWordSerenity = {
					color = "FF00DDDD",
					enabled = true
				},
				holyWordSanctify = {
					color = "FFFFDD22",
					enabled = true
				},
				holyWordChastise = {
					color = "FFFF8080",
					enabled = true
				},
				completeCooldown = {
					color = "FF00B500",
					enabled = true
				},
				sacredReverence = {
					color = "FF90FF64",
					enabled = true
				}
			},
			threshold = {
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
				color = { color = "FFFFFFFF" },
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
			surgeOfLight={
				name = L["PriestAudioSurgeOfLight"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			resonantWords={
				name = L["PriestHolyAudioResonantWords"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			lightweaver={
				name = L["PriestHolyAudioLightweaver"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(true),
	}

	if includeBarText then
		settings.displayText.barText = HolyLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default bar text settings for Shadow
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function ShadowLoadDefaultBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
	}

	table.insert(textSettings, TRB.Functions.Settings:DefaultBuffTimeBarTextEntry("vfTime", "voidform", classic, "CENTER", "RIGHT"))

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end

	local manaBarTextSettings = TRB.Functions.Settings:LoadDefaultManaBarTextSettings(classic)
	for k,v in pairs(manaBarTextSettings) do table.insert(textSettings, v) end

	return textSettings
end
TRB.Options.Priest.ShadowLoadDefaultBarTextSettings = ShadowLoadDefaultBarTextSettings

---Loads default settings for Shadow
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function ShadowLoadDefaultSettings(includeBarText, classic)
	local settings = {
		hasteApproachingThreshold=135,
		hasteThreshold=140,
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
			specProperties = {
				shadowWordMadnessThresholdOnlyOverShow = false,
			},
			thresholdDictionary = {
				shadowWordMadness = {
					enabled = true,
				},
				shadowWordMadness2 = {
					enabled = true,
				},
				shadowWordMadness3 = {
					enabled = true,
				}
			}
		},
		maxResource = {
			value = SHADOW_MAX_INSANITY,
			enabled = false
		},
		displayBar = {
			primary = "always",
			secondary = "always",
			health = "always",
			mana = "never",
			dragonriding = true
		},
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = SHADOW_MAX_INSANITY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			mana = TRB.Functions.Settings:DefaultManaBarDimensions(classic),
		},
		endOf = {
			voidform = TRB.Functions.Settings:DefaultEndOfSettings("gcd", 2, 3.0)
		},
		colors={
			text = {
				current = {
					color = "FFC2A3E0"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FFDF00FF"
				},
				overThreshold = {
					color = "FF00FF00",
					enabled = true
				},
				manaBar = {
					color = "FF0000FF"
				},
				hasteBelow = { color = "FFFFFFFF" },
				hasteApproaching = { color = "FFFFFF00" },
				hasteAbove = { color = "FF00FF00" },
				overcap = {
					color = "FFFF0000",
					enabled = true
				},
			},
			bar = {
				border = {
					color = "FF431863"
				},
				borderOvercap = {
					color = "FFFF0000",
					enabled = true
				},
				borderMindFlayInsanity = {
					color = "FF00FF00",
					enabled = true
				},
				background = {
					color = "66000000"
				},
				base = {
					color = "FF763BAF"
				},
				shadowWordMadnessUsable = {
					color = "FF5C2F89",
					enabled = true
				},
				shadowWordMadnessUsableCasting = {
					color = "FFFFFFFF",
					enabled = true
				},
				critMindBlast = {
					color = "FFC2A3E0",
					enabled = true
				},
				instantMindBlast = {
					color = "FFC2A3E0",
					enabled = true
				},
				mindDevourer = {
					color = "FF00C3FF",
					enabled = true,
				},
				entropicRift = {
					color = "FF8A004C",
					enabled = true
				},
				voidform = {
					color = "FF431863",
					enabled = true
				},
				voidformEnd = {
					color = "FFFF0000"
				},
				flashAlpha = 0.70,
				flashPeriod = 0.5,
				flashEnabled = true,
			},
			threshold = {
				under = {
					color = "FFFFFFFF"
				},
				over = {
					color = "FF00FF00"
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
				color = { color = "FFFFFFFF" },
			},
			barText = {}
		},
		audio = {
			mdProc={
				name = L["PriestShadowAudioMindDevourer"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			dpReady={
				name = L["PriestShadowAudioShadowWordMadness"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			powerInfusion={
				name = L["GlobalAudioPowerInfusion"],
				enabled = false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, true),
	}

	if includeBarText then
		settings.displayText.barText = ShadowLoadDefaultBarTextSettings(classic)
	end

	return settings
end

---Loads default settings for Priest
---@param includeBarText boolean?
---@param classic boolean?
---@return table
local function LoadDefaultSettings(includeBarText, classic)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.priest.discipline = DisciplineLoadDefaultSettings(includeBarText, classic)
	settings.priest.holy = HolyLoadDefaultSettings(includeBarText, classic)
	settings.priest.shadow = ShadowLoadDefaultSettings(includeBarText, classic)
	return settings
end
TRB.Options.Priest.LoadDefaultSettings = LoadDefaultSettings


--[[

Discipline Option Menus

]]


local function DisciplineConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PriestDisciplineFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.discipline = DisciplineLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["PriestDisciplineFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DisciplineLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PriestDisciplineFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.discipline = DisciplineLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PriestDisciplineFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DisciplineLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PriestDisciplineFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = DisciplineLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function DisciplineConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.discipline
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.discipline

	local title = ""

	controls.buttons.exportButton_Priest_Discipline_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Discipline_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 1, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord)

	--yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 1, yCoord)--, true, L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], false, true)
	
	--[[yCoord = yCoord - 30
	controls.checkBoxes.shadowCovenantBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_shadowCovenantEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowCovenantBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxShadowCovenant"])
	f.tooltip = L["PriestDisciplineCheckboxShadowCovenantTooltip"]
	f:SetChecked(spec.colors.bar.shadowCovenant.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.shadowCovenant.enabled = self:GetChecked()
	end)
	
	controls.colors.shadowCovenant = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPickerShadowCovenant"], spec.colors.bar.shadowCovenant, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.shadowCovenant
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "shadowCovenant")
	end)]]

	yCoord = yCoord - 30
	controls.colors.surgeOfLight = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight"], spec.colors.bar.surgeOfLight.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.surgeOfLight
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "surgeOfLight")
	end)
	
	controls.checkBoxes.surgeOfLightBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Threshold_Option_surgeOfLightBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.surgeOfLightBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight"])
	f.tooltip = L["PriestCheckboxSurgeOfLightTooltip"]
	f:SetChecked(spec.colors.bar.surgeOfLight.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.surgeOfLight.enabled = self:GetChecked()
	end)

	--[[
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplinePowerWordColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.checkBoxes.holyWordSerenityComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_powerWordRadianceComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordSerenityComboPointEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxEnablePowerWordRadiance"])
	f.tooltip = L["PriestDisciplineCheckboxEnablePowerWordRadianceTooltip"]
	f:SetChecked(spec.colors.comboPoints.powerWordRadiance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.powerWordRadiance.enabled = self:GetChecked()
		if TRB.Data.character.classId == 5 and TRB.Data.character.specId == 1 then
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
			TRB.Functions.Bar:Construct(TRB.Data.specCache.discipline.settings)
		end
	end)

	controls.colors.comboPoints.powerWordRadiance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordRadiance"], spec.colors.comboPoints.powerWordRadiance, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.powerWordRadiance
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "powerWordRadiance")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordUnfilled"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 1, yCoord)
end

local function DisciplineConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.discipline
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Discipline_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Discipline_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 5, 1, false, true, false, false, false, false)
	end)
end

local function DisciplineConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.discipline
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.discipline

	local title = ""

	controls.buttons.exportButton_Priest_Discipline_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Discipline_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 1, yCoord)
	
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 1, yCoord)
end

local function DisciplineConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 5
	local specId = 1
	local spec = TRB.Data.settings.priest.discipline

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.discipline
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Discipline_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Discipline_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "innervate", spec, classId, specId, yCoord, L["HealerAudioCheckboxInnervate"], L["HealerAudioCheckboxInnervateTooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "surgeOfLight", spec, classId, specId, yCoord, L["PriestAudioCheckboxSurgeOfLight"], L["PriestAudioCheckboxSurgeOfLightTooltip"])
end

local function DisciplineConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.discipline
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Priest_Discipline_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Discipline_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 1, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 1, yCoord, cache)
end

local function DisciplineConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(5, 1)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.discipline or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.disciplineDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Discipline", UIParent)
	interfaceSettingsFrame.disciplineDisplayPanel.name = L["PriestDisciplineFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.disciplineDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["discipline"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.disciplineDisplayPanel, L["PriestDisciplineFull"])
	parent = interfaceSettingsFrame.disciplineDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplineFull"], oUi.xCoord, yCoord-5)
	
	controls.checkBoxes.disciplinePriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.disciplinePriestEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestDisciplineFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.priest.discipline)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.priest.discipline = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Priest_Discipline_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Priest_Discipline_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 1, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls

	DisciplineConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--DisciplineConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	DisciplineConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	DisciplineConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	DisciplineConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	DisciplineConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end




--[[

Holy Option Menus

]]

local function HolyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	StaticPopupDialogs["TwintopResourceBar_Priest_Holy_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PriestHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.holy = HolyLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["PriestHolyFull"]),
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
	StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PriestHolyFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.holy = HolyLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PriestHolyFull"]),
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
	StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PriestHolyFull"]),
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

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function HolyConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.holy
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.holy

	local title = ""

	controls.buttons.exportButton_Priest_Holy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 2, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord)

	--yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], L["PriestHolyHolyWords"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 2, yCoord)--, true, L["PriestHolyHolyWords"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, false, nil, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])
	
	--[[yCoord = yCoord - 30
	controls.checkBoxes.holyWordChastiseEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordChastiseEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordChastise"])
	f.tooltip = L["PriestHolyCheckboxHolyWordChastiseTooltip"]
	f:SetChecked(spec.colors.bar.holyWordChastise.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.holyWordChastise.enabled = self:GetChecked()
	end)

	controls.colors.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.bar.holyWordChastise, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordChastise
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordChastise")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.holyWordSanctifyEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSanctifyEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordSanctifyEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordSanctify"])
	f.tooltip = L["PriestHolyCheckboxHolyWordSanctifyTooltip"]
	f:SetChecked(spec.colors.bar.holyWordSanctify.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.holyWordSanctify.enabled = self:GetChecked()
	end)

	controls.colors.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.bar.holyWordSanctify, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordSanctify
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordSanctify")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.holyWordSerenityEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSerenityEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordSerenityEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordSerenity"])
	f.tooltip = L["PriestHolyCheckboxHolyWordSerenityTooltip"]
	f:SetChecked(spec.colors.bar.holyWordSerenity.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.holyWordSerenity.enabled = self:GetChecked()
	end)

	controls.colors.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.bar.holyWordSerenity, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordSerenity
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordSerenity")
	end)]]

	yCoord = yCoord - 30
	controls.checkBoxes.apotheosis = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Bar_Option_apotheosisColorChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.apotheosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosis"])
	f.tooltip = L["PriestHolyCheckboxApotheosisTooltip"]
	f:SetChecked(spec.colors.bar.apotheosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.apotheosis.enabled = self:GetChecked()
	end)

	controls.colors.apotheosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerApotheosis"], spec.colors.bar.apotheosis.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.apotheosis
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "apotheosis")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.endOfApotheosis = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.endOfApotheosis
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisEnd"])
	f.tooltip = L["PriestHolyCheckboxApotheosisEndTooltip"]
	f:SetChecked(spec.endOfApotheosis.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOfApotheosis.enabled = self:GetChecked()
	end)

	controls.colors.apotheosisEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerApotheosisEnd"], spec.colors.bar.apotheosisEnd.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.apotheosisEnd
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "apotheosisEnd")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], false, true)

	yCoord = yCoord - 30
	controls.checkBoxes.surgeOfLightBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_surgeOfLightBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.surgeOfLightBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestCheckboxSurgeOfLight"])
	f.tooltip = L["PriestCheckboxSurgeOfLightTooltip"]
	f:SetChecked(spec.colors.bar.surgeOfLight.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.surgeOfLight.enabled = self:GetChecked()
	end)

	controls.colors.surgeOfLight = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight"], spec.colors.bar.surgeOfLight.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.surgeOfLight
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "surgeOfLight")
	end)
	
	--[[controls.colors.resonantWords = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerResonantWords"], spec.colors.bar.resonantWords, 300, 25, oUi.xCoord2, yCoord-90)
	f = controls.colors.resonantWords
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "resonantWords")
	end)

	controls.colors.lightweaver = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerLightweaver"], spec.colors.bar.lightweaver, 300, 25, oUi.xCoord2, yCoord-120)
	f = controls.colors.lightweaver
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "lightweaver")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.resonantWordsBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_resonantWordsBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.resonantWordsBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxResonantWords"])
	f.tooltip = L["PriestHolyCheckboxResonantWordsTooltip"]
	f:SetChecked(spec.colors.bar.resonantWords.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.resonantWords.enabled = self:GetChecked()
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.lightweaverBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_lightweaverBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.lightweaverBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxLightweaver"])
	f.tooltip = L["PriestHolyCheckboxLightweaverTooltip"]
	f:SetChecked(spec.colors.bar.lightweaver.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.lightweaver.enabled = self:GetChecked()
	end)]]

	--[[yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyHolyWordColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.checkBoxes.holyWordSerenityComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSerenityComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordSerenityComboPointEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordSerenity"])
	f.tooltip = L["PriestHolyCheckboxEnableHolyWordSerenityTooltip"]
	f:SetChecked(spec.colors.comboPoints.holyWordSerenity.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.holyWordSerenity.enabled = self:GetChecked()
		if TRB.Data.character.classId == 5 and TRB.Data.character.specId == 2 then
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
			TRB.Functions.Bar:Construct(TRB.Data.specCache.holy.settings)
		end
	end)

	controls.colors.comboPoints.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.comboPoints.holyWordSerenity, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.holyWordSerenity
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordSerenity")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.holyWordSanctifyComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSanctifyComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordSanctifyComboPointEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordSanctify"])
	f.tooltip = L["PriestHolyCheckboxEnableHolyWordSanctifyTooltip"]
	f:SetChecked(spec.colors.comboPoints.holyWordSanctify.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.holyWordSanctify.enabled = self:GetChecked()
		if TRB.Data.character.classId == 5 and TRB.Data.character.specId == 2 then
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
			TRB.Functions.Bar:Construct(TRB.Data.specCache.holy.settings)
		end
	end)

	controls.colors.comboPoints.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.comboPoints.holyWordSanctify, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.holyWordSanctify
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordSanctify")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.holyWordChastiseComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordChastiseComboPointEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxEnableHolyWordChastise"])
	f.tooltip = L["PriestHolyCheckboxEnableHolyWordChastiseTooltip"]
	f:SetChecked(spec.colors.comboPoints.holyWordChastise.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.holyWordChastise.enabled = self:GetChecked()
		if TRB.Data.character.classId == 5 and TRB.Data.character.specId == 2 then
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
			TRB.Functions.Bar:Construct(TRB.Data.specCache.holy.settings)
		end
	end)

	controls.colors.comboPoints.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.comboPoints.holyWordChastise, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.holyWordChastise
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "holyWordChastise")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.completeCooldownEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_completeCooldownEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.completeCooldownEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxCompleteHolyWordCooldown"])
	f.tooltip = L["PriestHolyCheckboxCompleteHolyWordCooldownTooltip"]
	f:SetChecked(spec.colors.comboPoints.completeCooldown.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.completeCooldown.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.completeCooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerCompleteHolyWordCooldown"], spec.colors.comboPoints.completeCooldown, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.completeCooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "sacredReverence")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sacredReverenceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_sacredReverenceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sacredReverenceEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxSacredReverence"])
	f.tooltip = L["PriestHolyCheckboxSacredReverenceTooltip"]
	f:SetChecked(spec.colors.comboPoints.sacredReverence.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.sacredReverence.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.sacredReverence = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerSacredReverence"], spec.colors.comboPoints.sacredReverence, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.sacredReverence
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "sacredReverence")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordBorder"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordUnfilled"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)]]

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 2, yCoord)
	
	
	
	yCoord = yCoord - 40
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyHeaderEndOfApotheosisConfiguration"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.endOfApotheosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_GCD", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfApotheosisModeGCDs
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisGcds"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfApotheosis.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(true)
		controls.checkBoxes.endOfApotheosisModeTime:SetChecked(false)
		spec.endOfApotheosis.mode = "gcd"
	end)

	title = L["PriestHolyApotheosisGcds"]
	controls.endOfApotheosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfApotheosis.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfApotheosisGCDs:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.endOfApotheosis.gcdsMax = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.endOfApotheosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_TIME", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.endOfApotheosisModeTime
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxApotheosisTime"])
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.endOfApotheosis.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(false)
		controls.checkBoxes.endOfApotheosisModeTime:SetChecked(true)
		spec.endOfApotheosis.mode = "time"
	end)

	title = L["PriestHolyApotheosisTime"]
	controls.endOfApotheosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfApotheosis.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.endOfApotheosisTime:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.endOfApotheosis.timeMax = value
	end)
end

local function HolyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.holy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Holy_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 5, 2, false, true, false, false, false, false)
	end)
end

local function HolyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.holy
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.holy

	local title = ""

	controls.buttons.exportButton_Priest_Holy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 2, yCoord)
	
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

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 2, yCoord)
end

local function HolyConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 5
	local specId = 2
	local spec = TRB.Data.settings.priest.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.holy
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "innervate", spec, classId, specId, yCoord, L["HealerAudioCheckboxInnervate"], L["HealerAudioCheckboxInnervateTooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "surgeOfLight", spec, classId, specId, yCoord, L["PriestAudioCheckboxSurgeOfLight"], L["PriestAudioCheckboxSurgeOfLightTooltip"])
	
	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "resonantWords", spec, classId, specId, yCoord, L["PriestHolyAudioCheckboxResonantWords"], L["PriestHolyAudioCheckboxResonantWordsTooltip"])
	
	--yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "lightweaver", spec, classId, specId, yCoord, L["PriestHolyAudioCheckboxLightweaver"], L["PriestHolyAudioCheckboxLightweaverTooltip"])
end

local function HolyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.holy
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Priest_Holy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Holy_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 2, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 2, yCoord, cache)
end

local function HolyConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(5, 2)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.holy or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.holyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Holy", UIParent)
	interfaceSettingsFrame.holyDisplayPanel.name = L["PriestHolyFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.holyDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["holy"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.holyDisplayPanel, L["PriestHolyFull"])

	parent = interfaceSettingsFrame.holyDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestHolyFull"], oUi.xCoord, yCoord-5)
	
	controls.checkBoxes.holyPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyPriestEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestHolyFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.priest.holy)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.priest.holy = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Priest_Holy_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Priest_Holy_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 2, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls

	HolyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	--HolyConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	HolyConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	HolyConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	HolyConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	HolyConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end



--[[

Shadow Option Menus

]]

local function ShadowConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shadow
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["PriestShadowFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.shadow = ShadowLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["PriestShadowFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ShadowLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetClassic"] = {
		text = string.format(L["ResetBarClassicDialog"], L["PriestShadowFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.priest.shadow = ShadowLoadDefaultSettings(true, true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextCompact"] = {
		text = string.format(L["ResetBarTextCompactDialog"], L["PriestShadowFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ShadowLoadDefaultBarTextSettings()
			controls.barTextFields.ResetTableValues(spec.displayText.barText)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextClassic"] = {
		text = string.format(L["ResetBarTextClassicDialog"], L["PriestShadowFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = ShadowLoadDefaultBarTextSettings(true)
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
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ShadowConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shadow
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Shadow_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 5, 3, true, false, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceInsanity"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 3, yCoord, false, nil, true)

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], "notEmpty", true, L["PriestShadowShadowWordMadness"], L["PriestShadowShadowWordMadnessAbbreviation"], false, nil, true, true)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 30
	controls.checkBoxes.voidform = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Bar_Option_voidformColorChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.voidform
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxVoidform"])
	f.tooltip = L["PriestShadowCheckboxVoidformTooltip"]
	f:SetChecked(spec.colors.bar.voidform.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.voidform.enabled = self:GetChecked()
	end)

	controls.colors.voidform = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerVoidform"], spec.colors.bar.voidform.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.voidform		
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "voidform")
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, yCoord, "voidform", L["PriestShadowCheckboxVoidformEnd"], L["PriestShadowCheckboxVoidformEndTooltip"], L["PriestShadowColorPickerVoidformEnd"])

	yCoord = yCoord - 30
	controls.colors.shadowWordMadnessUsable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerShadowWordMadness"], spec.colors.bar.shadowWordMadnessUsable.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.shadowWordMadnessUsable
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "shadowWordMadnessUsable")
	end)

	controls.checkBoxes.shadowWordMadnessUsable = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Checkbox_ShadowWordMadnessUsable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowWordMadnessUsable
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxShadowWordMadnessUsable"])
	f.tooltip = L["PriestShadowCheckboxShadowWordMadnessUsableTooltip"]
	f:SetChecked(spec.colors.bar.shadowWordMadnessUsable.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.shadowWordMadnessUsable.enabled = self:GetChecked()
	end)

	--[[
	yCoord = yCoord - 30
	controls.colors.instantMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerInstantMindBlast"], spec.colors.bar.instantMindBlast.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.instantMindBlast
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "instantMindBlast")
	end)

	controls.checkBoxes.instantMindBlast = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Checkbox_InstantMindBlast", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.instantMindBlast
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxInstantMindBlast"])
	f.tooltip = L["PriestShadowCheckboxInstantMindBlastTooltip"]
	f:SetChecked(spec.colors.bar.instantMindBlast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.instantMindBlast.enabled = self:GetChecked()
	end)]]
	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], true, false)
	
	yCoord = yCoord - 30
	controls.checkBoxes.mindFlayInsanityBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_mindFlayInsanityBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindFlayInsanityBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxMindFlayInsanity"])
	f.tooltip = L["PriestShadowCheckboxMindFlayInsanityTooltip"]
	f:SetChecked(spec.colors.bar.borderMindFlayInsanity.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.borderMindFlayInsanity.enabled = self:GetChecked()
	end)

	controls.colors.borderMindFlayInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerMindFlayInsanity"], spec.colors.bar.borderMindFlayInsanity.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.borderMindFlayInsanity
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderMindFlayInsanity")
	end)
	yCoord = yCoord - 30
	controls.checkBoxes.entropicRiftBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_entropicRiftBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.entropicRiftBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxEntropicRift"])
	f.tooltip = L["PriestShadowCheckboxEntropicRiftTooltip"]
	f:SetChecked(spec.colors.bar.entropicRift.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.entropicRift.enabled = self:GetChecked()
	end)

	controls.colors.entropicRift = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerEntropicRift"], spec.colors.bar.entropicRift.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.entropicRift
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "entropicRift")
	end)

	
	--[[yCoord = yCoord - 30
	controls.checkBoxes.critMindBlastBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_critMindBlastBorderChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.critMindBlastBorderChange
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxCritMindBlast"])
	f.tooltip = L["PriestShadowCheckboxCritMindBlastTooltip"]
	f:SetChecked(spec.colors.bar.critMindBlast.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.critMindBlast.enabled = self:GetChecked()
	end)

	controls.colors.critMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerCritMindBlast"], spec.colors.bar.critMindBlast.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.critMindBlast
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "critMindBlast")
	end)
	]]
	yCoord = yCoord - 30
	controls.checkBoxes.mindDevourer = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Border_Option_mindDevourerProc", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.mindDevourer
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowCheckboxMindDevourer"])
	f.tooltip = L["PriestShadowCheckboxMindDevourerTooltip"]
	f:SetChecked(spec.colors.bar.mindDevourer.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.mindDevourer.enabled = self:GetChecked()
	end)

	controls.colors.mindDevourer = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerMindDevourer"], spec.colors.bar.mindDevourer.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.mindDevourer
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "mindDevourer")
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, yCoord, "voidform", L["PriestShadowHeaderEndOfVoidformConfiguration"], L["PriestShadowCheckboxVoidformGcds"], L["PriestShadowVoidformGcds"], L["PriestShadowCheckboxVoidformTime"], L["PriestShadowVoidformTime"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], SHADOW_MAX_INSANITY)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], 1, SHADOW_MAX_INSANITY)
end

local function ShadowConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shadow
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Shadow_Thresholds = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportThresholds"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 5, 3, false, true, false, false, false, false)
	end)

	controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AbilityThresholdLinesHeader"], oUi.xCoord, yCoord)

	controls.colors.threshold = {}

	yCoord = yCoord - 30
	controls.checkBoxes.dpThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_shadowWordMadness", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThresholdShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdShadowWordMadness"])
	f.tooltip = L["PriestShadowThresholdShadowWordMadnessTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shadowWordMadness.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shadowWordMadness.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dpThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_shadowWordMadness2", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThreshold2Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdShadowWordMadness2x"])
	f.tooltip = L["PriestShadowThresholdShadowWordMadness2xTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shadowWordMadness2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shadowWordMadness2.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dpThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_shadowWordMadness3", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThreshold3Show
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdShadowWordMadness3x"])
	f.tooltip = L["PriestShadowThresholdShadowWordMadness3xTooltip"]
	f:SetChecked(spec.thresholds.thresholdDictionary.shadowWordMadness3.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.thresholdDictionary.shadowWordMadness3.enabled = self:GetChecked()
	end)

	yCoord = yCoord - 25
	controls.checkBoxes.dpThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_shadowWordMadnessOnlyOver", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThresholdOnlyOverShow
	f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdCheckboxOnlyCurrentNext"])
	f.tooltip = L["PriestShadowThresholdCheckboxOnlyCurrentNextTooltip"]
	f:SetChecked(spec.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow = self:GetChecked()
	end)

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], true, true, false, true, custom)

	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shadow
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Shadow_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCurrent"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCasting"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerThresholdOver"], spec.colors.text.overThreshold.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerOvercap"], spec.colors.text.overcap.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
	end)

	yCoord = yCoord - 30

	controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overThresholdEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["PriestShadowCheckboxThresholdOverTooltip"]
	f:SetChecked(spec.colors.text.overThreshold.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.text.overThreshold.enabled = self:GetChecked()
	end)

	controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.overcapTextEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = L["PriestShadowCheckboxThresholdOvercapTooltip"]
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

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowHeaderHasteThreshold"], oUi.xCoord, yCoord)

	yCoord = yCoord - 50
	title = L["PriestShadowHasteLowToMedium"]
	controls.hasteApproachingThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteApproachingThreshold, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value > spec.hasteThreshold then
			value = spec.hasteThreshold
		end

		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.hasteApproachingThreshold = value
	end)

	controls.colors.text.hasteBelow = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteLow"], spec.colors.text.hasteBelow.color,
												250, 25, oUi.xCoord2, yCoord+10)
	f = controls.colors.text.hasteBelow
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.hasteBelow, controls.colors.text, "hasteBelow", "color")
	end)

	controls.colors.text.hasteApproaching = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteMedium"], spec.colors.text.hasteApproaching.color,
												250, 25, oUi.xCoord2, yCoord-30)
	f = controls.colors.text.hasteApproaching
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.hasteApproaching, controls.colors.text, "hasteApproaching", "color")
	end)

	controls.colors.text.hasteAbove = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerHasteHigh"], spec.colors.text.hasteAbove.color,
												250, 25, oUi.xCoord2, yCoord-70)
	f = controls.colors.text.hasteAbove
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text.hasteAbove, controls.colors.text, "hasteAbove", "color")
	end)

	yCoord = yCoord - 60
	title = L["PriestShadowHasteMediumToHigh"]
	controls.hasteThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteThreshold, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
		local min, max = self:GetMinMaxValues()
		if value > max then
			value = max
		elseif value < min then
			value = min
		elseif value < spec.hasteApproachingThreshold then
			value = spec.hasteApproachingThreshold
		end

		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.hasteThreshold = value
	end)

	yCoord = yCoord - 10

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local classId = 5
	local specId = 3
	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shadow
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Shadow_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", classId, specId, false, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)
	yCoord = yCoord - 30

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "dpReady", spec, classId, specId, yCoord, L["PriestShadowAudioCheckboxShadowWordMadness"], L["PriestShadowAudioCheckboxShadowWordMadnessTooltip"])

	yCoord = TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, "mdProc", spec, classId, specId, yCoord, L["PriestShadowAudioCheckboxMindDevourer"], L["PriestShadowAudioCheckboxMindDevourerTooltip"])
end

local function ShadowConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.shadow
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Priest_Shadow_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 5, 3, false, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 5, 3, yCoord, cache)
end

local function ShadowConstructOptionsPanel(cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(5, 3)
	local namePrefix = className .. "_" .. specName
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.shadow or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}
	
	interfaceSettingsFrame.shadowDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Shadow", UIParent)
	interfaceSettingsFrame.shadowDisplayPanel.name = L["PriestShadowFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.shadowDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["shadow"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.shadowDisplayPanel, L["PriestShadowFull"])

	parent = interfaceSettingsFrame.shadowDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowFull"], oUi.xCoord, yCoord-5)

	controls.checkBoxes.shadowPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_shadowPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowPriestEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["Enabled"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["PriestShadowFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.priest.shadow)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.priest.shadow = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)
	end)

	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Priest_Shadow_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 3, true, true, true, true, true, false)
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
	TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls

	ShadowConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	ShadowConstructThresholdPanel(tabsheets[2].scrollFrame.scrollChild)
	ShadowConstructFontAndTextPanel(tabsheets[3].scrollFrame.scrollChild)
	ShadowConstructAudioAndTrackingPanel(tabsheets[4].scrollFrame.scrollChild)
	ShadowConstructBarTextDisplayPanel(tabsheets[5].scrollFrame.scrollChild, cache)
	ShadowConstructResetDefaultsPanel(tabsheets[6].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	DisciplineConstructOptionsPanel(specCache.discipline)
	HolyConstructOptionsPanel(specCache.holy)
	ShadowConstructOptionsPanel(specCache.shadow)
end
TRB.Options.Priest.ConstructOptionsPanel = ConstructOptionsPanel