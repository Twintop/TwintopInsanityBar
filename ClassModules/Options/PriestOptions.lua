---@diagnostic disable: undefined-field
local _, TRB = ...

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
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true },
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


---Loads only the Holy Word bar text entries (no global mana text)
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadHolyWordBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSerenity1"],
			guid = TRB.Functions.String:Guid(),
			text = "{$hwSerenityTime&$hwSerenityCharges=0}[$hwSerenityTime]",
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
				relativeToFrame = "HolyWord_Serenity_1",
				relativeToFrameName = L["HolyWordSerenityCharge1"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSerenity2"],
			guid = TRB.Functions.String:Guid(),
			text = "{$hwSerenityTime&$hwSerenityCharges=1}[$hwSerenityTime]",
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
				relativeToFrame = "HolyWord_Serenity_2",
				relativeToFrameName = L["HolyWordSerenityCharge2"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSanctify1"],
			guid = TRB.Functions.String:Guid(),
			text = "{$hwSanctifyTime&$hwSanctifyCharges=0}[$hwSanctifyTime]",
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
				relativeToFrame = "HolyWord_Sanctify_1",
				relativeToFrameName = L["HolyWordSanctifyCharge1"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSanctify2"],
			guid = TRB.Functions.String:Guid(),
			text = "{$hwSanctifyTime&$hwSanctifyCharges=1}[$hwSanctifyTime]",
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
				relativeToFrame = "HolyWord_Sanctify_2",
				relativeToFrameName = L["HolyWordSanctifyCharge2"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWChastise"],
			guid = TRB.Functions.String:Guid(),
			text = "{$hwChastiseTime}[$hwChastiseTime]",
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
				relativeToFrame = "HolyWord_Chastise_1",
				relativeToFrameName = L["HolyWordChastiseCharge1"],
			},
		}
	}

	return textSettings
end
TRB.Options.Priest.HolyLoadHolyWordBarTextSettings = HolyLoadHolyWordBarTextSettings

---Loads extra default bar text settings for Holy (Holy Words + global mana text)
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadExtraBarTextSettings(classic)
	local textSettings = HolyLoadHolyWordBarTextSettings()
	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return textSettings
end
TRB.Options.Priest.HolyLoadExtraBarTextSettings = HolyLoadExtraBarTextSettings

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
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true },
			dragonriding = true
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		endOf = {
			apotheosis = TRB.Functions.Settings:DefaultEndOfSettings()
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
		settings.displayText.migrations = { holyWordBarTextSeeded = true }
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
			primary = { visibility = "always", smooth = true },
			secondary = { visibility = "always", smooth = false },
			health = { visibility = "always", smooth = true },
			mana = { visibility = "never", smooth = true },
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

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.priest_discipline
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

local function DisciplineConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord)

	--yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	
	controls.colors.shadowCovenant = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPickerShadowCovenant"], spec.colors.bar.shadowCovenant, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.shadowCovenant
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "shadowCovenant")
	end)]]

	yCoord = yCoord - 30
	controls.colors.surgeOfLight = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight"], spec.colors.bar.surgeOfLight.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
end

local function DisciplineConstructPowerWordsPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestDisciplinePowerWordColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.checkBoxes.powerWordRadianceComboPointEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_powerWordRadianceComboPointEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.powerWordRadianceComboPointEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestDisciplineCheckboxEnablePowerWordRadiance"])
	f.tooltip = L["PriestDisciplineCheckboxEnablePowerWordRadianceTooltip"]
	f:SetChecked(spec.colors.comboPoints.powerWordRadiance.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.powerWordRadiance.enabled = self:GetChecked()
		if TRB.Data.character.classId == 5 and TRB.Data.character.specId == 1 then
			TRB.Functions.Character:ResetCaches()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(spec, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(spec, TRB.Frames.barGroups)
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.colors.comboPoints.powerWordRadiance = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordRadiance"], spec.colors.comboPoints.powerWordRadiance.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.powerWordRadiance
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "powerWordRadiance")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordUnfilled"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)
end

local function DisciplineConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 1, yCoord)
end

local function DisciplineConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 1, yCoord, true, L["PriestDisciplinePowerWords"])
end

local function DisciplineConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["PriestDisciplinePowerWords"], true)
end

local function DisciplineConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Discipline_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Priest_Discipline_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 5, 1, false, true, false, false, false, false)
	end)
end

local function DisciplineConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.discipline

	local title = ""

	controls.buttons.exportButton_Priest_Discipline_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Priest_Discipline_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 1, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 1, yCoord)
	
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
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Discipline_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Priest_Discipline_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_discipline or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.disciplineDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Discipline")
	TRB.Options.OptionsFrame:RegisterSpecPanel("priest", "priest_discipline", L["PriestDisciplineFull"], interfaceSettingsFrame.disciplineDisplayPanel)
	parent = interfaceSettingsFrame.disciplineDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["PriestDisciplineFull"],
		TRB.Data.settings.core.enabled.priest, "discipline",
		"TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled", "disciplinePriestEnabled",
		"exportButton_Priest_Discipline_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestDisciplineFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 1, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_discipline = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = DisciplineConstructManaBarPanel },
		{ key = "powerWordsBar", label = L["TabPowerWords"], width = oUi.tabWidth.medium, constructor = DisciplineConstructPowerWordsPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = DisciplineConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = DisciplineConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = DisciplineConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = DisciplineConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = DisciplineConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) DisciplineConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = DisciplineConstructResetDefaultsPanel },
	}, yCoord)
end




--[[

Holy Option Menus

]]

local function HolyConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.priest_holy
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.holyWordBarTextSeeded = true
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.holyWordBarTextSeeded = true
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.holyWordBarTextSeeded = true
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

local function HolyConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])
	
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

	controls.colors.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.bar.holyWordSerenity.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordSerenity
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordSerenity")
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

	controls.colors.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.bar.holyWordSanctify.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordSanctify
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordSanctify")
	end)
	
	yCoord = yCoord - 30
	controls.checkBoxes.holyWordChastiseEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.holyWordChastiseEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestHolyCheckboxHolyWordChastise"])
	f.tooltip = L["PriestHolyCheckboxHolyWordChastiseTooltip"]
	f:SetChecked(spec.colors.bar.holyWordChastise.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.holyWordChastise.enabled = self:GetChecked()
	end)

	controls.colors.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.bar.holyWordChastise.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.holyWordChastise
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "holyWordChastise")
	end)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, 5, 2, yCoord, {
		endOfKey = "apotheosis",
		activeColorKey = "apotheosis",
		endColorKey = "apotheosisEnd",
		checkboxLabel = L["PriestHolyCheckboxApotheosis"],
		checkboxTooltip = L["PriestHolyCheckboxApotheosisTooltip"],
		activeColorLabel = L["PriestHolyColorPickerApotheosis"],
		endCheckboxLabel = L["PriestHolyCheckboxApotheosisEnd"],
		endCheckboxTooltip = L["PriestHolyCheckboxApotheosisEndTooltip"],
		endColorLabel = L["PriestHolyColorPickerApotheosisEnd"],
	})

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.surgeOfLight = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestColorPickerSurgeOfLight"], spec.colors.bar.surgeOfLight.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.surgeOfLight
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "surgeOfLight")
	end)
	
	--[[controls.colors.resonantWords = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerResonantWords"], spec.colors.bar.resonantWords, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-90)
	f = controls.colors.resonantWords
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "resonantWords")
	end)

	controls.colors.lightweaver = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerLightweaver"], spec.colors.bar.lightweaver, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-120)
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

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, 5, 2, yCoord, {
		endOfKey = "apotheosis",
		sectionHeader = L["PriestHolyHeaderEndOfApotheosisConfiguration"],
		gcdRadioLabel = L["PriestHolyCheckboxApotheosisGcds"],
		gcdSliderLabel = L["PriestHolyApotheosisGcds"],
		timeRadioLabel = L["PriestHolyCheckboxApotheosisTime"],
		timeSliderLabel = L["PriestHolyApotheosisTime"],
	})
end

local function HolyConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 2, yCoord)
end

local function HolyConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 2, yCoord)--, true, L["PriestHolyHolyWords"])
end

local function HolyConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], "notFull", false, nil, nil, true, L["PriestHolyHolyWords"], true)
end

local function HolyConstructHolyWordsPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], L["PriestHolyHolyWords"])

	yCoord = yCoord - 60
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
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(spec, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(spec, TRB.Frames.barGroups)
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.colors.comboPoints.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSerenity"], spec.colors.comboPoints.holyWordSerenity.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(spec, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(spec, TRB.Frames.barGroups)
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.colors.comboPoints.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordSanctify"], spec.colors.comboPoints.holyWordSanctify.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(spec, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(spec, TRB.Frames.barGroups)
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.colors.comboPoints.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerHolyWordChastise"], spec.colors.comboPoints.holyWordChastise.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.comboPoints.completeCooldown = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorPickerCompleteHolyWordCooldown"], spec.colors.comboPoints.completeCooldown.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.completeCooldown
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "completeCooldown")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestHolyColorHolyWordUnfilled"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)
end

local function HolyConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Holy_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
	controls.buttons.exportButton_Priest_Holy_Thresholds:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixThresholds"] .. ".", 5, 2, false, true, false, false, false, false)
	end)
end

local function HolyConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5
	local f = nil

	local spec = TRB.Data.settings.priest.holy

	local title = ""

	controls.buttons.exportButton_Priest_Holy_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 2, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 2, yCoord)
	
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
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)		
	controls.buttons.exportButton_Priest_Holy_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_holy or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.holyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Holy")
	TRB.Options.OptionsFrame:RegisterSpecPanel("priest", "priest_holy", L["PriestHolyFull"], interfaceSettingsFrame.holyDisplayPanel)

	parent = interfaceSettingsFrame.holyDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["PriestHolyFull"],
		TRB.Data.settings.core.enabled.priest, "holy",
		"TwintopResourceBar_Priest_Holy_holyPriestEnabled", "holyPriestEnabled",
		"exportButton_Priest_Holy_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestHolyFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 2, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_holy = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = HolyConstructManaBarPanel },
		{ key = "holyWordsBar", label = L["TabHolyWords"], width = oUi.tabWidth.medium, constructor = HolyConstructHolyWordsPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = HolyConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = HolyConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = HolyConstructBarVisibilityPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = HolyConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = HolyConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) HolyConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = HolyConstructResetDefaultsPanel },
	}, yCoord)
end



--[[

Shadow Option Menus

]]

local function ShadowConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.priest_shadow
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

local function ShadowConstructInsanityBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5
	local f = nil

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, 5, 3, yCoord, {
		endOfKey = "voidform",
		activeColorKey = "voidform",
		endColorKey = "voidformEnd",
		checkboxLabel = L["PriestShadowCheckboxVoidform"],
		checkboxTooltip = L["PriestShadowCheckboxVoidformTooltip"],
		activeColorLabel = L["PriestShadowColorPickerVoidform"],
		endCheckboxLabel = L["PriestShadowCheckboxVoidformEnd"],
		endCheckboxTooltip = L["PriestShadowCheckboxVoidformEndTooltip"],
		endColorLabel = L["PriestShadowColorPickerVoidformEnd"],
	})

	yCoord = yCoord - 30
	controls.colors.shadowWordMadnessUsable = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerShadowWordMadness"], spec.colors.bar.shadowWordMadnessUsable.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	controls.colors.instantMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerInstantMindBlast"], spec.colors.bar.instantMindBlast.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.borderMindFlayInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerMindFlayInsanity"], spec.colors.bar.borderMindFlayInsanity.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.entropicRift = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerEntropicRift"], spec.colors.bar.entropicRift.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.critMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerCritMindBlast"], spec.colors.bar.critMindBlast.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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

	controls.colors.mindDevourer = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerMindDevourer"], spec.colors.bar.mindDevourer.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.mindDevourer
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "mindDevourer")
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, 5, 3, yCoord, {
		endOfKey = "voidform",
		sectionHeader = L["PriestShadowHeaderEndOfVoidformConfiguration"],
		gcdRadioLabel = L["PriestShadowCheckboxVoidformGcds"],
		gcdSliderLabel = L["PriestShadowVoidformGcds"],
		timeRadioLabel = L["PriestShadowCheckboxVoidformTime"],
		timeSliderLabel = L["PriestShadowVoidformTime"],
	})

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], SHADOW_MAX_INSANITY)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], 1, SHADOW_MAX_INSANITY)
end

local function ShadowConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceInsanity"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))
end

local function ShadowConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 3, yCoord, false, nil, true)
end

local function ShadowConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], "notEmpty", true, L["PriestShadowShadowWordMadness"], L["PriestShadowShadowWordMadnessAbbreviation"], false, nil, true, true)
end

local function ShadowConstructThresholdPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Priest_Shadow_Thresholds = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportThresholds"], yCoord-5)
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

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Shadow_FontAndText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportFontText"], yCoord-5)
	controls.buttons.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 5, 3, false, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["PriestShadowTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 5, 3, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["PriestShadowColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
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
	controls.colors.text.manaBar = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.manaBar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "manaBar")
	end)

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
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Priest_Shadow_AudioAndTracking = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportAudioTracking"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Priest_Shadow_BarText = TRB.Functions.OptionsUi:BuildExportButton(parent, L["ExportMessageExportBarText"], yCoord-5)
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
	local controls = interfaceSettingsFrame.controls.priest_shadow or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}
	
	interfaceSettingsFrame.shadowDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Shadow")
	TRB.Options.OptionsFrame:RegisterSpecPanel("priest", "priest_shadow", L["PriestShadowFull"], interfaceSettingsFrame.shadowDisplayPanel)

	parent = interfaceSettingsFrame.shadowDisplayPanel

	yCoord = TRB.Functions.OptionsUi:BuildSpecTitleRow(parent, controls, L["PriestShadowFull"],
		TRB.Data.settings.core.enabled.priest, "shadow",
		"TwintopResourceBar_Priest_Shadow_shadowPriestEnabled", "shadowPriestEnabled",
		"exportButton_Priest_Shadow_All",
		function(self, ...)
			TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["PriestShadowFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 5, 3, true, true, true, true, true, false)
		end)

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_shadow = controls

	yCoord = TRB.Functions.OptionsUi:BuildTabGroup(parent, namePrefix, {
		{ key = "insanityBar", label = L["TabInsanity"], width = oUi.tabWidth.small, constructor = ShadowConstructInsanityBarPanel },
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = ShadowConstructManaBarPanel },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = ShadowConstructHealthBarPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = ShadowConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = ShadowConstructBarVisibilityPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = ShadowConstructThresholdPanel },
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = ShadowConstructFontAndTextPanel },
		{ key = "audioTracking", label = L["TabAudioTracking"], width = oUi.tabWidth.large, constructor = ShadowConstructAudioAndTrackingPanel },
		{ key = "barText", label = L["TabBarText"], width = oUi.tabWidth.small, constructor = function(scrollChild) ShadowConstructBarTextDisplayPanel(scrollChild, cache) end },
		{ key = "resetDefaults", label = L["TabResetDefaults"], width = oUi.tabWidth.medium, constructor = ShadowConstructResetDefaultsPanel },
	}, yCoord)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	TRB.Options.OptionsFrame:RegisterClassHeader("priest", L["Priest"])
	DisciplineConstructOptionsPanel(specCache.priest_discipline)
	HolyConstructOptionsPanel(specCache.priest_holy)
	ShadowConstructOptionsPanel(specCache.priest_shadow)
	TRB.Options.OptionsFrame:RefreshNav()
end
TRB.Options.Priest.ConstructOptionsPanel = ConstructOptionsPanel