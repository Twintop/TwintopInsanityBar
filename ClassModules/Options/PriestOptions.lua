---@diagnostic disable: undefined-field
local _, TRB = ...

local L = TRB.Localization

local oUi = TRB.Data.constants.optionsUi

TRB.Options.Priest = {}
TRB.Options.Priest.Discipline = {}
TRB.Options.Priest.Holy = {}
TRB.Options.Priest.Shadow = {}

local SHADOW_MAX_INSANITY = TRB.Data.maxResource.priest.shadow.insanity

local function GetPriestUtilityBarTypeDefinition()
	local utilityBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("utility")
	if utilityBarDef == nil then
		return nil
	end

	local priestUtilityBarDef = {
		displayName = L["ResourceAngelicFeather"]
	}
	setmetatable(priestUtilityBarDef, { __index = utilityBarDef })

	return priestUtilityBarDef
end


---Loads only the Angelic Feather charge bar text entries (shared across all Priest specs)
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function LoadAngelicFeatherBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestBarTextNameAFCharge1"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$afCharges=0}[$afTime]",
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
				relativeToFrame = "Angelic_Feather_Charge_1",
				relativeToFrameName = L["AngelicFeatherCharge1"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestBarTextNameAFCharge2"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$afCharges=1}[$afTime]",
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
				relativeToFrame = "Angelic_Feather_Charge_2",
				relativeToFrameName = L["AngelicFeatherCharge2"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestBarTextNameAFCharge3"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$afCharges=2}[$afTime]",
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
				relativeToFrame = "Angelic_Feather_Charge_3",
				relativeToFrameName = L["AngelicFeatherCharge3"],
			},
		},
	}

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Priest.LoadAngelicFeatherBarTextSettings = LoadAngelicFeatherBarTextSettings

---Loads only the Power Word bar text entries (no global mana text)
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DisciplineLoadPowerWordBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestDisciplineBarTextNamePWRadiance1"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$pwRadianceTime&$pwRadianceCharges=0}[$pwRadianceTime]",
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
				relativeToFrame = "PowerWord_Radiance_1",
				relativeToFrameName = L["PowerWordRadianceCharge1"],
			},
		},
		{
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestDisciplineBarTextNamePWRadiance2"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$pwRadianceTime&$pwRadianceCharges=1}[$pwRadianceTime]",
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
				relativeToFrame = "PowerWord_Radiance_2",
				relativeToFrameName = L["PowerWordRadianceCharge2"],
			},
		},
	}

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Priest.DisciplineLoadPowerWordBarTextSettings = DisciplineLoadPowerWordBarTextSettings

---Loads extra default bar text settings for Discipline
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function DisciplineLoadExtraBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = DisciplineLoadPowerWordBarTextSettings()
	local afTextSettings = LoadAngelicFeatherBarTextSettings()
	for _, v in ipairs(afTextSettings) do table.insert(textSettings, v) end
	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			utility = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			utility = TRB.Functions.Settings:DefaultUtilityBarDimensions(classic),
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
				surgeOfLight = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled",
					enabled = true
				},
				shadowCovenant = {
					color = "FFC4A5E2",
					color2 = "FFC4A5E2",
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
					color2 = "FFFFDD22",
					gradientDirection = "disabled",
					enabled = true
				}
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
				utility = TRB.Classes.Priest.DefaultAngelicFeatherUtilityBarColors(),
			},
			shared = {
				nodeOrder = {
					"voidShield",
					"surgeOfLight",
				},
				gradientOrder = {
				},
				indicatorColors = {
					surgeOfLight = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							powerWordsBar = { bar = false, border = false, background = false },
						},
					},
					voidShield = {
						color = "FFC2A3E0",
						color2 = "FFC2A3E0",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							manaBar = { bar = false, border = true, background = false },
							powerWordsBar = { bar = false, border = false, background = false },
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
			surgeOfLight={
				name = L["PriestAudioSurgeOfLight"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(true, nil, {
			GetPriestUtilityBarTypeDefinition(),
		}),
	}

	if includeBarText then
		settings.displayText.barText = DisciplineLoadDefaultBarTextSettings(classic)
		settings.displayText.migrations = { powerWordBarTextSeeded = true, angelicFeatherBarTextSeeded = true }
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSerenity1"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSerenity2"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSanctify1"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWSanctify2"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PriestHolyBarTextNameHWChastise"],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
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

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Priest.HolyLoadHolyWordBarTextSettings = HolyLoadHolyWordBarTextSettings

---Loads the default Lightweaver bar text entries (one per charge node)
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadLightweaverBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}
	local names = {
		L["PriestHolyBarTextNameLWCharge1"],
		L["PriestHolyBarTextNameLWCharge2"],
		L["PriestHolyBarTextNameLWCharge3"],
		L["PriestHolyBarTextNameLWCharge4"],
	}
	local frameNames = {
		L["LightweaverCharge1"],
		L["LightweaverCharge2"],
		L["LightweaverCharge3"],
		L["LightweaverCharge4"],
	}
	-- Derive the number of Lightweaver nodes from the bar type definition so we
 	-- stay in sync with the runtime bar configuration if the stack cap changes.
 	local maxNodes = 4
 	local barTypeRegistry = TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
 	if barTypeRegistry ~= nil then
 		-- The Lightweaver bar type is expected to define maxNodes.
 		local lightweaverBarDef = barTypeRegistry:Get("lightweaver")
 		if lightweaverBarDef ~= nil and type(lightweaverBarDef.maxNodes) == "number" and lightweaverBarDef.maxNodes > 0 then
 			maxNodes = lightweaverBarDef.maxNodes
 		end
 	end
 	-- Do not iterate beyond the number of localized entries we have.
 	maxNodes = math.min(maxNodes, #names, #frameNames)
 	for i = 1, maxNodes do
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			fontOutline = "OUTLINE",
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = names[i],
			guid = TRB.Functions.String:Guid(),
			constrainToParent = false,
			maxWidthPercent = 100,
			text = "{$lightweaverStacks=" .. i .. "}[$lightweaverStacks - $lightweaverTime]",
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
				relativeToFrame = "Lightweaver_Charge_" .. i,
				relativeToFrameName = frameNames[i],
			},
		})
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end
TRB.Options.Priest.HolyLoadLightweaverBarTextSettings = HolyLoadLightweaverBarTextSettings

---Loads extra default bar text settings for Holy (Holy Words + global mana text)
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
local function HolyLoadExtraBarTextSettings(classic)
	local textSettings = HolyLoadHolyWordBarTextSettings()
	local lwTextSettings = HolyLoadLightweaverBarTextSettings()
	for _, v in ipairs(lwTextSettings) do table.insert(textSettings, v) end
	local afTextSettings = LoadAngelicFeatherBarTextSettings()
	for _, v in ipairs(afTextSettings) do table.insert(textSettings, v) end
	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("mana", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			holyWords = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			lightweaver = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			utility = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			holyWords = TRB.Functions.Settings:DefaultHolyWordsBarDimensions(classic),
			lightweaver = TRB.Functions.Settings:DefaultLightweaverBarDimensions(classic),
			utility = TRB.Functions.Settings:DefaultUtilityBarDimensions(classic),
		},
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
					color = "FF0000FF",
					color2 = "FF0000FF",
					gradientDirection = "disabled"
				},
				apotheosis = {
					color = "FFFADA5E",
					color2 = "FFFADA5E",
					gradientDirection = "disabled",
					enabled = true
				},
				apotheosisEnd = {
					color = "FFFF0000",
					color2 = "FFFF0000",
					gradientDirection = "disabled"
				},
				benediction = {
					color = "FFC4933F",
					color2 = "FFC4933F",
					gradientDirection = "disabled",
					enabled = true
				},
				holyWordChastise = {
					color = "FFAAFFAA",
					color2 = "FFAAFFAA",
					gradientDirection = "disabled",
					enabled = false
				},
				holyWordSanctify = {
					color = "FF55FF55",
					color2 = "FF55FF55",
					gradientDirection = "disabled",
					enabled = true
				},
				holyWordSerenity = {
					color = "FF00FF00",
					color2 = "FF00FF00",
					gradientDirection = "disabled",
					enabled = true
				},
				surgeOfLight = {
					color = "FFFCE58E",
					color2 = "FFFCE58E",
					gradientDirection = "disabled",
					enabled = true
				},
				lightweaver = {
					color = "FF00FFFF",
					color2 = "FF00FFFF",
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
			healthBar = TRB.Functions.Settings:DefaultHealthBarColors(),
			bars = {
				holyWords = TRB.Functions.Settings:DefaultHolyWordsBarColors(),
				lightweaver = TRB.Functions.Settings:DefaultLightweaverBarColors(),
				utility = TRB.Classes.Priest.DefaultAngelicFeatherUtilityBarColors(),
			},
			shared = {
				nodeOrder = { "benediction", "holyWordSerenity", "holyWordSanctify", "holyWordChastise", "apotheosisEnd", "apotheosis", "surgeOfLight", "lightweaver" },
				gradientOrder = {},
				indicatorColors = {
					benediction = {
						color = "FFC4933F",
						color2 = "FFC4933F",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = true, border = false, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = true } },
					},
					holyWordSerenity = {
						color = "FF00FF00",
						color2 = "FF00FF00",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = true, border = false, background = false }, holyWordsBar = { bar = true, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					holyWordSanctify = {
						color = "FF55FF55",
						color2 = "FF55FF55",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = true, border = false, background = false }, holyWordsBar = { bar = true, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					holyWordChastise = {
						color = "FFAAFFAA",
						color2 = "FFAAFFAA",
						gradientDirection = "disabled",
						enabled = false,
						targets = { manaBar = { bar = false, border = false, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					apotheosisEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = true, border = false, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					apotheosis = {
						color = "FFFADA5E",
						color2 = "FFFADA5E",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = true, border = false, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					surgeOfLight = {
						color = "FFFCE58E",
						color2 = "FFFCE58E",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = false, border = true, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
					},
					lightweaver = {
						color = "FF00FFFF",
						color2 = "FF00FFFF",
						gradientDirection = "disabled",
						enabled = true,
						targets = { manaBar = { bar = false, border = true, background = false }, holyWordsBar = { bar = false, border = false, background = false }, lightweaverBar = { bar = false, border = false, background = false } },
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
			surgeOfLight={
				name = L["PriestAudioSurgeOfLight"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"],
				configuration = {
					requireSpiritwellTalent = false
				}
			},
			benediction={
				name = L["PriestHolyAudioBenediction"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			lightweaverExpiring={
				name = L["PriestHolyAudioLightweaverExpiring"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"],
				configuration = {
					thresholdValue = 5
				}
			},
			holyWordChastiseReady={
				name = L["PriestHolyAudioHolyWordChastiseReady"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			holyWordSerenityCharge1={
				name = L["PriestHolyAudioHolyWordSerenityCharge1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			holyWordSerenityCharge2={
				name = L["PriestHolyAudioHolyWordSerenityCharge2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			holyWordSanctifyCharge1={
				name = L["PriestHolyAudioHolyWordSanctifyCharge1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			},
			holyWordSanctifyCharge2={
				name = L["PriestHolyAudioHolyWordSanctifyCharge2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
			}
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, nil, {
			TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords"),
			TRB.Classes.BarTypeRegistry:GetInstance():Get("lightweaver"),
			GetPriestUtilityBarTypeDefinition(),
		}),
	}

	if includeBarText then
		settings.displayText.barText = HolyLoadDefaultBarTextSettings(classic)
		settings.displayText.migrations = { holyWordBarTextSeeded = true, lightweaverBarTextSeeded = true, angelicFeatherBarTextSeeded = true }
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

	local afTextSettings = LoadAngelicFeatherBarTextSettings()
	for _, v in ipairs(afTextSettings) do table.insert(textSettings, v) end

	local globalTextSettings = TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings("resource", classic)
	for k,v in pairs(globalTextSettings) do table.insert(textSettings, v) end

	local manaBarTextSettings = TRB.Functions.Settings:LoadDefaultManaBarTextSettings(classic)
	for k,v in pairs(manaBarTextSettings) do table.insert(textSettings, v) end

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			},
			customThresholds = {}
		},
		maxResource = {
			value = SHADOW_MAX_INSANITY,
			enabled = false
		},
		displayBar = {
			primary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			secondary = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			health = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			mana = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
			utility = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 },
		},
		barVisibilityThresholds = TRB.Functions.Settings:LoadDefaultManaBarVisibilityThresholds(),
		overcap = {
			mode = "relative",
			relative = 0,
			fixed = SHADOW_MAX_INSANITY
		},
		bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
		healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
		bars = {
			mana = TRB.Functions.Settings:DefaultManaBarDimensions(classic),
			utility = TRB.Functions.Settings:DefaultUtilityBarDimensions(classic),
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
				background = {
					color = "66000000"
				},
				base = {
					color = "FF763BAF",
					color2 = "FF763BAF",
					gradientDirection = "disabled"
				},
				critMindBlast = {
					color = "FFC2A3E0",
					color2 = "FFC2A3E0",
					gradientDirection = "disabled",
					enabled = true
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
			shared = {
				nodeOrder = {
					"instantMindBlast",
					"voidformEnd",
					"shadowWordMadnessUsable",
					"voidform",
					"mindDevourer",
					"entropicRift",
					"borderMindFlayInsanity",
				},
				gradientOrder = {
					"borderOvercap",
				},
				indicatorColors = {
					instantMindBlast = {
						color = "FFC2A3E0",
						color2 = "FFC2A3E0",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = true, border = false, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					voidformEnd = {
						color = "FFFF0000",
						color2 = "FFFF0000",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = true, border = false, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					mindDevourer = {
						color = "FF00C3FF",
						color2 = "FF00C3FF",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = false, border = true, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					entropicRift = {
						color = "FF8A004C",
						color2 = "FF8A004C",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = false, border = true, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					borderMindFlayInsanity = {
						color = "FF00FF00",
						enabled = true,
						targets = {
							insanityBar = { bar = false, border = true, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					shadowWordMadnessUsable = {
						color = "FF5C2F89",
						color2 = "FF5C2F89",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = true, border = false, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					voidform = {
						color = "FF431863",
						color2 = "FF431863",
						gradientDirection = "disabled",
						enabled = true,
						targets = {
							insanityBar = { bar = true, border = false, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
					borderOvercap = {
						color = "FFFF0000",
						enabled = true,
						isGradient = true,
						targets = {
							insanityBar = { bar = false, border = true, background = false },
							manaBar = { bar = false, border = false, background = false },
						},
					},
				},
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
				utility = TRB.Classes.Priest.DefaultAngelicFeatherUtilityBarColors(),
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
		},
		textures = TRB.Functions.Settings:DefaultTextures(false, true, {
			GetPriestUtilityBarTypeDefinition(),
		}),
	}

	if includeBarText then
		settings.displayText.barText = ShadowLoadDefaultBarTextSettings(classic)
		settings.displayText.migrations = { angelicFeatherBarTextSeeded = true }
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.powerWordBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.disciplineDisplayPanel, "barText")
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.powerWordBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.disciplineDisplayPanel, "barText")
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
			spec.displayText.migrations = spec.displayText.migrations or {}
			spec.displayText.migrations.powerWordBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.disciplineDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord)

	--yCoord = yCoord - 30
	--yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

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

	controls.colors.shadowCovenant = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestDisciplineColorPickerShadowCovenant"], spec.colors.bar.shadowCovenant, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.shadowCovenant
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "shadowCovenant")
	end)]]

end

local function DisciplineConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 5, 1, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "surgeOfLight",  label = L["PriestDisciplineCheckboxSurgeOfLight"],  tooltip = L["PriestDisciplineIndicatorSurgeOfLightTooltip"],  colorLabel = L["PriestDisciplineIndicatorSurgeOfLightColor"] },
			{ key = "voidShield",   label = L["PriestDisciplineCheckboxVoidShield"],   tooltip = L["PriestDisciplineIndicatorVoidShieldTooltip"],   colorLabel = L["PriestDisciplineIndicatorVoidShieldColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "powerWordsBar", label = L["BarNamePowerWordsBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Priest_Discipline",
	}))

	yCoord = yCoord - 40
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateComboPointDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], L["PriestDisciplinePowerWords"])

	yCoord = yCoord - 60
	controls.comboPointColorsSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PriestDisciplinePowerWordColorsHeader"], oUi.xCoord, yCoord)
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
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	controls.colors.comboPoints.powerWordRadiance = TRB.Functions.OptionsUi.ColorPickers:BuildGradientColorPicker(parent, L["PriestDisciplineColorPowerWordRadiance"], spec.colors.comboPoints.powerWordRadiance, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.powerWordRadiance
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "powerWordRadiance")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:GradientColor2OnMouseDown(button, spec.colors.comboPoints.powerWordRadiance, self)
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.background = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestDisciplineColorPowerWordUnfilled"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background", "backdrop", TRB.Functions.OptionsUi.ColorPickers:GetSecondaryBackdropFrames())
	end)

	yCoord = TRB.Functions.OptionsUi.ColorPickers:GenerateEndCapOptions(parent, controls, yCoord, spec.colors.comboPoints, "Priest_Discipline_ComboPoints", "endCapComboPoints", L["EndCap"], 5, 1)
end

local function DisciplineConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 5, 1, yCoord)
end

local function DisciplineConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 5, 1, yCoord, true, L["PriestDisciplinePowerWords"], false, { GetPriestUtilityBarTypeDefinition() })
end

local function DisciplineConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	local spec = TRB.Data.settings.priest.discipline

	local customBars = {}
	local utilityBarDef = GetPriestUtilityBarTypeDefinition()
	if utilityBarDef then
		table.insert(customBars, utilityBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], "notFull", true, L["PriestDisciplinePowerWords"], true, nil, customBars)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 5, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 5, 1, yCoord)

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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 1, yCoord)
end

local function DisciplineConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 5, 1, yCoord, cache)
end

local function PriestConstructAngelicFeatherBarPanel(spec, controls, classId, specId)
	return function(parent)
		if parent == nil then
			return
		end

		local yCoord = 5

		local utilityBarDef = GetPriestUtilityBarTypeDefinition()
		if utilityBarDef then
			yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, utilityBarDef)
		end

		yCoord = yCoord - 90
		if utilityBarDef then
			yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, utilityBarDef)
		end
	end
end

local function DisciplineConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.discipline
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_discipline
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 5, 1, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 1, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PriestDisciplineFull"],
		TRB.Data.settings.core.enabled.priest, "discipline",
		"TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled", "disciplinePriestEnabled",
		"priest", "discipline")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_discipline = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = DisciplineConstructManaBarPanel, visibilityKey = "primary" },
		{ key = "powerWordsBar", label = L["TabPowerWords"], width = oUi.tabWidth.medium, constructor = DisciplineConstructPowerWordsPanel, visibilityKey = "secondary" },
		{ key = "angelicFeatherBar", label = L["TabAngelicFeather"], width = oUi.tabWidth.small, constructor = PriestConstructAngelicFeatherBarPanel(TRB.Data.settings.priest.discipline, controls, 5, 1), visibilityKey = "utility" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = DisciplineConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = DisciplineConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("priest", "discipline", controls),
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = DisciplineConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = DisciplineConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = DisciplineConstructBarVisibilityPanel },
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("priest", "discipline", controls),
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = DisciplineConstructFontAndTextPanel },
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
			spec.displayText.migrations.lightweaverBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.holyDisplayPanel, "barText")
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
			spec.displayText.migrations.lightweaverBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.holyDisplayPanel, "barText")
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
			spec.displayText.migrations.lightweaverBarTextSeeded = true
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.holyDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])
end

local function HolyConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 5, 2, yCoord)
end

local function HolyConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 5, 2, yCoord, false, nil, false, { TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords"), TRB.Classes.BarTypeRegistry:GetInstance():Get("lightweaver"), GetPriestUtilityBarTypeDefinition() })
end

local function HolyConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy

	local customBars = {}
	local holyWordsBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
	if holyWordsBarDef then
		table.insert(customBars, holyWordsBarDef)
	end
	local lightweaverBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("lightweaver")
	if lightweaverBarDef then
		table.insert(customBars, lightweaverBarDef)
	end
	local utilityBarDef = GetPriestUtilityBarTypeDefinition()
	if utilityBarDef then
		table.insert(customBars, utilityBarDef)
	end

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], "notFull", false, nil, true, nil, customBars)
end

local function HolyConstructLightweaverBarPanel(parent)
	if parent == nil then
		return
	end

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	local spec = TRB.Data.settings.priest.holy
	local lightweaverBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("lightweaver")

	if lightweaverBarDef then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord, lightweaverBarDef, L["ResourceMana"])
	end

	yCoord = yCoord - 90
	if lightweaverBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 5, 2, yCoord, lightweaverBarDef)
	end

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
	local holyWordsBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")

	if holyWordsBarDef then
		yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord, holyWordsBarDef, L["ResourceMana"])
	end

	yCoord = yCoord - 90
	if holyWordsBarDef then
		yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 5, 2, yCoord, holyWordsBarDef)
	end
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 5, 2, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["HealerManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 5, 2, yCoord)

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

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 2, yCoord)
end

local function HolyConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 5, 2, yCoord, cache)
end

local function HolyConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 5, 2, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "benediction",        label = L["PriestHolyCheckboxBenedictionIndicator"],      tooltip = L["PriestHolyIndicatorBenedictionTooltip"],        colorLabel = L["PriestHolyIndicatorBenedictionColor"] },
			{ key = "holyWordSerenity",   label = L["PriestHolyCheckboxHolyWordSerenityCooldown"],  tooltip = L["PriestHolyIndicatorHolyWordSerenityTooltip"],   colorLabel = L["PriestHolyIndicatorHolyWordSerenityColor"] },
			{ key = "holyWordSanctify",   label = L["PriestHolyCheckboxHolyWordSanctifyCooldown"],  tooltip = L["PriestHolyIndicatorHolyWordSanctifyTooltip"],   colorLabel = L["PriestHolyIndicatorHolyWordSanctifyColor"] },
			{ key = "holyWordChastise",   label = L["PriestHolyCheckboxHolyWordChastiseCooldown"],  tooltip = L["PriestHolyIndicatorHolyWordChastiseTooltip"],   colorLabel = L["PriestHolyIndicatorHolyWordChastiseColor"] },
			{ key = "apotheosisEnd",      label = L["PriestHolyCheckboxApotheosisEndIndicator"],    tooltip = L["PriestHolyIndicatorApotheosisEndTooltip"],      colorLabel = L["PriestHolyIndicatorApotheosisEndColor"] },
			{ key = "apotheosis",         label = L["PriestHolyCheckboxApotheosis"],                tooltip = L["PriestHolyIndicatorApotheosisTooltip"],         colorLabel = L["PriestHolyIndicatorApotheosisColor"] },
			{ key = "surgeOfLight",       label = L["PriestCheckboxSurgeOfLight"],                  tooltip = L["PriestHolyIndicatorSurgeOfLightTooltip"],       colorLabel = L["PriestHolyIndicatorSurgeOfLightColor"] },
			{ key = "lightweaver",        label = L["PriestHolyCheckboxLightweaver"],               tooltip = L["PriestHolyIndicatorLightweaverTooltip"],        colorLabel = L["PriestHolyIndicatorLightweaverColor"] },
		},
		barTargetDefs = {
			{ key = "manaBar", label = L["BarNameManaBar"] },
			{ key = "holyWordsBar", label = L["BarNameHolyWordsBar"] },
			{ key = "lightweaverBar", label = L["BarNameLightweaverBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Priest_Holy",
		endOfConfigs = {
			{
				endOfKey = "apotheosis",
				sectionHeader = L["PriestHolyHeaderEndOfApotheosisConfiguration"],
				gcdRadioLabel = L["PriestHolyCheckboxApotheosisGcds"],
				gcdSliderLabel = L["PriestHolyApotheosisGcds"],
				timeRadioLabel = L["PriestHolyCheckboxApotheosisTime"],
				timeSliderLabel = L["PriestHolyApotheosisTime"],
			},
		},
	}))

	yCoord = yCoord - 40
end

local function HolyConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.holy
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_holy
	local yCoord = 5

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 5, 2, yCoord, L["ResourceMana"], true, true, true, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 2, yCoord)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PriestHolyFull"],
		TRB.Data.settings.core.enabled.priest, "holy",
		"TwintopResourceBar_Priest_Holy_holyPriestEnabled", "holyPriestEnabled",
		"priest", "holy")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_holy = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = HolyConstructManaBarPanel, visibilityKey = "primary" },
		{ key = "holyWordsBar", label = L["TabHolyWords"], width = oUi.tabWidth.medium, constructor = HolyConstructHolyWordsPanel, visibilityKey = "holyWords" },
		{ key = "lightweaverBar", label = L["TabLightweaver"], width = oUi.tabWidth.medium, constructor = HolyConstructLightweaverBarPanel, visibilityKey = "lightweaver" },
		{ key = "angelicFeatherBar", label = L["TabAngelicFeather"], width = oUi.tabWidth.small, constructor = PriestConstructAngelicFeatherBarPanel(TRB.Data.settings.priest.holy, controls, 5, 2), visibilityKey = "utility" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = HolyConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.large, constructor = HolyConstructThresholdSettingsPanel },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("priest", "holy", controls),
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = HolyConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = HolyConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = HolyConstructBarVisibilityPanel },
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("priest", "holy", controls),
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = HolyConstructFontAndTextPanel },
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.shadowDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.shadowDisplayPanel, "barText")
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
			TRB.Functions.OptionsUi.Tabs:EnsureTabConstructed(TRB.Frames.interfaceSettingsFrameContainer.shadowDisplayPanel, "barText")
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
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_Reset")
	end)

	yCoord = yCoord - 30
	controls.resetClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetToClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetClassic")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetBarTextCompactButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextCompact"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextCompactButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextCompact")
	end)

	yCoord = yCoord - 30
	controls.resetBarTextClassicButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["ResetBarTextClassic"], oUi.xCoord, yCoord, 250, 30)
	controls.resetBarTextClassicButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextClassic")
	end)
	yCoord = yCoord - 40
end

local function ShadowConstructIndicatorColorsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Indicators:GenerateIndicatorColorsPanel(parent, controls, spec, 5, 3, yCoord, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New({
		indicatorDefs = {
			{ key = "instantMindBlast",                label = L["PriestShadowCheckboxInstantMindBlast"],                tooltip = L["PriestShadowIndicatorInstantMindBlastTooltip"],                colorLabel = L["PriestShadowIndicatorInstantMindBlastColor"] },
			{ key = "voidformEnd",                     label = L["PriestShadowCheckboxVoidformEnd"],                     tooltip = L["PriestShadowIndicatorVoidformEndTooltip"],                     colorLabel = L["PriestShadowIndicatorVoidformEndColor"] },
			{ key = "shadowWordMadnessUsable",         label = L["PriestShadowCheckboxShadowWordMadnessUsable"],         tooltip = L["PriestShadowIndicatorShadowWordMadnessUsableTooltip"],         colorLabel = L["PriestShadowIndicatorShadowWordMadnessUsableColor"] },
			{ key = "voidform",                        label = L["PriestShadowCheckboxVoidform"],                        tooltip = L["PriestShadowIndicatorVoidformTooltip"],                        colorLabel = L["PriestShadowIndicatorVoidformColor"] },
			{ key = "mindDevourer",                    label = L["PriestShadowCheckboxMindDevourer"],                    tooltip = L["PriestShadowIndicatorMindDevourerTooltip"],                    colorLabel = L["PriestShadowIndicatorMindDevourerColor"] },
			{ key = "entropicRift",                    label = L["PriestShadowCheckboxEntropicRift"],                    tooltip = L["PriestShadowIndicatorEntropicRiftTooltip"],                    colorLabel = L["PriestShadowIndicatorEntropicRiftColor"] },
			{ key = "borderMindFlayInsanity",          label = L["PriestShadowCheckboxMindFlayInsanity"],                tooltip = L["PriestShadowIndicatorMindFlayInsanityTooltip"],                colorLabel = L["PriestShadowIndicatorMindFlayInsanityColor"] },
		},
		gradientDefs = {
			{ key = "borderOvercap",                   label = L["PriestShadowCheckboxBorderOvercap"],                   tooltip = L["PriestShadowIndicatorOvercapTooltip"],                        colorLabel = L["PriestShadowIndicatorOvercapColor"] },
		},
		barTargetDefs = {
			{ key = "insanityBar", label = L["BarNameInsanityBar"] },
			{ key = "manaBar", label = L["BarNameManaBar"] },
		},
		ddNamePrefix = "TwintopResourceBar_Priest_Shadow",
		endOfConfigs = {
			{
				endOfKey = "voidform",
				sectionHeader = L["PriestShadowHeaderEndOfVoidformConfiguration"],
				gcdRadioLabel = L["PriestShadowCheckboxVoidformGcds"],
				gcdSliderLabel = L["PriestShadowVoidformGcds"],
				timeRadioLabel = L["PriestShadowCheckboxVoidformTime"],
				timeSliderLabel = L["PriestShadowVoidformTime"],
			},
		},
		overcapConfig = { primaryResourceString = L["ResourceInsanity"], primaryResourceMax = SHADOW_MAX_INSANITY },
	}))

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

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateBaseColorsOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateMaxResourceOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], 1, SHADOW_MAX_INSANITY)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Textures:GenerateFlashOptions(parent, controls, spec, 5, 3, yCoord, L["PriestShadowShadowWordMadness"], L["PriestShadowShadowWordMadnessAbbreviation"])
end

local function ShadowConstructManaBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"), L["ResourceInsanity"])

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, 5, 3, yCoord, TRB.Classes.BarTypeRegistry:GetInstance():Get("mana"))
end

local function ShadowConstructHealthBarPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateHealthBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi.Colors:GenerateHealthBarColorOptions(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructBarTexturesPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Textures:GenerateBarTexturesOptions(parent, controls, spec, 5, 3, yCoord, false, nil, true, { GetPriestUtilityBarTypeDefinition() })
end

local function ShadowConstructBarVisibilityPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	local customBars = {}
	local utilityBarDef = GetPriestUtilityBarTypeDefinition()
	if utilityBarDef then
		table.insert(customBars, utilityBarDef)
	end
	local extraThresholdTypes = TRB.Functions.OptionsUi.Visibility:CreateBarVisibilityThresholdTypes("mana", {
		{ key = "manaPercent", label = L["BarVisibilityThresholdManaPercent"], comparisonLabel = L["BarVisibilityThresholdManaPercentComparison"], valueLabel = L["BarVisibilityThresholdManaPercentValue"], isPercent = true, header = L["BarVisibilityThresholdHeaderWithMana"] },
		{ key = "manaValue", label = L["BarVisibilityThresholdManaValue"], comparisonLabel = L["BarVisibilityThresholdManaValueComparison"], valueLabel = L["BarVisibilityThresholdManaValueValue"], isPercent = false, header = L["BarVisibilityThresholdHeaderWithMana"] },
	})

	yCoord = TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], "notEmpty", false, nil, true, true, customBars, extraThresholdTypes)
end

local function ShadowConstructThresholdListPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.ThresholdList:GenerateThresholdListPanel(parent, controls, spec, 5, 3, yCoord, {
		labels = {
			shadowWordMadness = L["PriestShadowThresholdShadowWordMadness"],
			shadowWordMadness2 = L["PriestShadowThresholdShadowWordMadness2Times"],
			shadowWordMadness3 = L["PriestShadowThresholdShadowWordMadness3Times"],
		},
		tooltips = {
			shadowWordMadness = L["PriestShadowThresholdShadowWordMadnessTooltip"],
			shadowWordMadness2 = L["PriestShadowThresholdShadowWordMadness2TimesTooltip"],
			shadowWordMadness3 = L["PriestShadowThresholdShadowWordMadness3TimesTooltip"],
		},
		barTargetLabels = {
			primary = L["ResourceInsanity"],
		},
	})
end

local function ShadowConstructThresholdSettingsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5
	local f = nil

	controls.colors.threshold = {}

	controls.swmThresholdSection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PriestShadowSWMThresholdsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.dpThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_shadowWordMadnessOnlyOver", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.dpThresholdOnlyOverShow
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["PriestShadowThresholdCheckboxOnlyCurrentNext"])
	f.tooltip = L["PriestShadowThresholdCheckboxOnlyCurrentNextTooltip"]
	f:SetChecked(spec.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow)
	f:SetScript("OnClick", function(self, ...)
		spec.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow = self:GetChecked()
	end)

	yCoord = yCoord - 30

	---@type TRB.Classes.OptionsUi.Color[]
	local custom = {
	}

	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineColorOptions(parent, controls, spec, 5, 3, yCoord, L["ResourceInsanity"], true, true, false, true, custom)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi.Thresholds:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 3, yCoord)
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


	yCoord = TRB.Functions.OptionsUi.Text:GenerateDefaultFontOptions(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["PriestShadowTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultTextColors(parent, controls, spec, 5, 3, yCoord)

	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestShadowColorPickerTextCurrent"], spec.colors.text.current.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestShadowColorPickerTextCasting"], spec.colors.text.casting.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.overThreshold = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestShadowColorPickerThresholdOver"], spec.colors.text.overThreshold.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.overThreshold
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
	end)

	controls.colors.text.overcap = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["PriestShadowColorPickerOvercap"], spec.colors.text.overcap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.overcap
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
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
	controls.colors.text.manaBar = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(parent, L["ManaBarTextColor"], spec.colors.text.manaBar.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord, yCoord)
	f = controls.colors.text.manaBar
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "manaBar")
	end)

	yCoord = TRB.Functions.OptionsUi.Text:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 5, 3, yCoord)
end

local function ShadowConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.priest.shadow
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.priest_shadow
	local yCoord = 5

	TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, 5, 3, yCoord, cache)
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

	yCoord = TRB.Functions.OptionsUi.Profiles:BuildSpecTitleRow(parent, controls, L["PriestShadowFull"],
		TRB.Data.settings.core.enabled.priest, "shadow",
		"TwintopResourceBar_Priest_Shadow_shadowPriestEnabled", "shadowPriestEnabled",
		"priest", "shadow")

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.priest_shadow = controls

	yCoord = TRB.Functions.OptionsUi.Tabs:BuildTabGroup(parent, namePrefix, {
		{ key = "insanityBar", label = L["TabInsanity"], width = oUi.tabWidth.small, constructor = ShadowConstructInsanityBarPanel, visibilityKey = "primary" },
		{ key = "manaBar", label = L["TabMana"], width = oUi.tabWidth.small, constructor = ShadowConstructManaBarPanel, visibilityKey = "mana" },
		{ key = "angelicFeatherBar", label = L["TabAngelicFeather"], width = oUi.tabWidth.small, constructor = PriestConstructAngelicFeatherBarPanel(TRB.Data.settings.priest.shadow, controls, 5, 3), visibilityKey = "utility" },
		{ key = "healthBar", label = L["TabHealth"], width = oUi.tabWidth.small, constructor = ShadowConstructHealthBarPanel, visibilityKey = "health" },
		{ key = "indicatorColors", label = L["TabIndicatorColors"], width = oUi.tabWidth.large, constructor = ShadowConstructIndicatorColorsPanel },
		{ key = "barTextures", label = L["TabTextures"], width = oUi.tabWidth.small, constructor = ShadowConstructBarTexturesPanel },
		{ key = "barVisibility", label = L["TabVisibility"], width = oUi.tabWidth.small, constructor = ShadowConstructBarVisibilityPanel },
		{ key = "thresholdSettings", label = L["TabThresholdSettings"], width = oUi.tabWidth.xlarge, constructor = ShadowConstructThresholdSettingsPanel },
		{ key = "thresholds", label = L["TabThresholds"], width = oUi.tabWidth.large, constructor = ShadowConstructThresholdListPanel, isManualScrollFrame = true },
		TRB.Functions.OptionsUi.CustomThresholds:BuildTabDefinition("priest", "shadow", controls),
		TRB.Functions.OptionsUi.AudioCues:BuildTabDefinition("priest", "shadow", controls),
		{ key = "fontText", label = L["TabFontText"], width = oUi.tabWidth.medium, constructor = ShadowConstructFontAndTextPanel },
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
