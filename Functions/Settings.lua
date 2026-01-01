local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

--[[@type TRB.Classes.Settings.SpecializationGlobalEnabled]]
local specGlobalDefaults = {
	--specEnable = false,
	bar = false,
	comboPoints = false,
	healthBar = false,
	thresholdIcons = false,
	thresholdHealers = false,
	thresholdPotions = false,
	displayBar = false,
	displayText = false,
	textColors = false,
	thresholdColors = false,
	healthBarColors = false,
	precision = false,
	textures = false
}

function TRB.Functions.Settings:LoadDefaultSettings()
	local settings = {
		core = {
			dataRefreshRate = 5.0,
			reactionTime = 0.1,
			smoothBarValueUpdates = true,
			news = {
				enabled = true,
				lastUpdate = ""
			},
			audio = {
				channel = {
					name = L["AudioChannelMaster"],
					channel = "Master"
				}
			},
			strata = {
				level = "BACKGROUND",
				name = L["StrataBackground"]
			},
			timers = {
				precisionLow = 1,
				precisionHigh = 0,
				precisionThreshold = 5
			},
			thresholds = {
				properties = {
					width = 2,
					overlapBorder=true
				},
				icons = {
					showCooldown = true,
					border = 2,
					relativeTo = "TOP",
					relativeToName = L["PositionAbove"],
					enabled = true,
					desaturated = true,
					xPos = 0,
					yPos = -12,
					width = 24,
					height = 24
				},
				thresholdDictionaryHealers = {
					algariManaPotionRank1 = {
						enabled = false,
					},
					algariManaPotionRank2 = {
						enabled = false,
					},
					algariManaPotionRank3 = {
						enabled = true,
					},
					cavedwellersDelightRank1 = {
						enabled = false,
					},
					cavedwellersDelightRank2 = {
						enabled = false,
					},
					cavedwellersDelightRank3 = {
						enabled = true,
					},
					slumberingSoulSerumRank1 = {
						enabled = false,
					},
					slumberingSoulSerumRank2 = {
						enabled = false,
					},
					slumberingSoulSerumRank3 = {
						enabled = true,
					},
				},
				potionCooldown = {
					enabled=true,
					mode="time",
					gcdsMax=40,
					timeMax=60
				},
			},
			displayBar = {
				primary = "combat",
				secondary = "combat",
				health = "combat",
				dragonriding = true
			},
			bar = TRB.Functions.Settings:DefaultBarDimensions(),
			comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(),
			healthBar = TRB.Functions.Settings:DefaultHealthDimensions(),
			precision = {
				secondary = 2,
				resource = 0
			},
			colors = {
				text = {
					current = {
						color = "FFC2A3E0",
						enabled = true
					},
					casting = {
						color = "FFFFFFFF",
						enabled = true
					},
					spending = {
						color = "FF555555",
						enabled = true
					},
					passive = {
						color = "FFDF00FF",
						enabled = true
					},
					overThreshold = {
						color = "FF00FF00",
						enabled = false
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
					},
				}
			},
			textures = TRB.Functions.Settings:DefaultTextures(true),
			displayText={
				default = {
					fontFace = "Fonts\\FRIZQT__.TTF",
					fontFaceName = "Friz Quadrata TT",
					fontJustifyHorizontal = "LEFT",
					fontJustifyHorizontalName = L["PositionLeft"],
					fontSize = 18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			global = {
				globalEnable = false,
				deathknight = {
					blood = specGlobalDefaults,
					frost = specGlobalDefaults,
					unholy = specGlobalDefaults
				},
				demonhunter = {
					havoc = specGlobalDefaults,
					vengeance = specGlobalDefaults,
					devourer = specGlobalDefaults
				},
				druid = {
					balance = specGlobalDefaults,
					feral = specGlobalDefaults,
					guardian = specGlobalDefaults,
					restoration = specGlobalDefaults
				},
				evoker = {
					devastation = specGlobalDefaults,
					preservation = specGlobalDefaults,
					augmentation = specGlobalDefaults
				},
				hunter = {
					beastMastery = specGlobalDefaults,
					marksmanship = specGlobalDefaults,
					survival = specGlobalDefaults
				},
				mage = {
					arcane = specGlobalDefaults,
					fire = specGlobalDefaults,
					frost = specGlobalDefaults
				},
				monk = {
					brewmaster = specGlobalDefaults,
					mistweaver = specGlobalDefaults,
					windwalker = specGlobalDefaults
				},
				paladin = {
					holy = specGlobalDefaults,
					protection = specGlobalDefaults,
					retribution = specGlobalDefaults,
				},
				priest = {
					discipline = specGlobalDefaults,
					holy = specGlobalDefaults,
					shadow = specGlobalDefaults
				},
				rogue = {
					assassination = specGlobalDefaults,
					outlaw = specGlobalDefaults,
					subtlety = specGlobalDefaults
				},
				shaman = {
					elemental = specGlobalDefaults,
					enhancement = specGlobalDefaults,
					restoration = specGlobalDefaults
				},
				warlock = {
					affliction = specGlobalDefaults,
					demonology = specGlobalDefaults,
					destruction = specGlobalDefaults
				},
				warrior = {
					arms = specGlobalDefaults,
					fury = specGlobalDefaults,
					protection = specGlobalDefaults
				}
			},
			enabled = {
				deathknight = {
					blood = true,
					frost = true,
					unholy = true
				},
				demonhunter = {
					havoc = true,
					vengeance = true,
					devourer = true
				},
				druid = {
					balance = true,
					feral = true,
					guardian = true,
					restoration = true
				},
				evoker = {
					devastation = true,
					preservation = true,
					augmentation = true
				},
				hunter = {
					beastMastery = true,
					marksmanship = true,
					survival = true
				},
				mage = {
					arcane = true,
					fire = true,
					frost = true
				},
				monk = {
					brewmaster = true,
					mistweaver = true,
					windwalker = true
				},
				paladin = {
					holy = true,
					protection = true,
					retribution = true
				},
				priest = {
					discipline = true,
					holy = true,
					shadow = true
				},
				rogue = {
					assassination = true,
					outlaw = true,
					subtlety = true
				},
				shaman = {
					elemental = true,
					enhancement = true,
					restoration = true
				},
				warlock = {
					affliction = true,
					demonology = true,
					destruction = true
				},
				warrior = {
					arms = true,
					fury = true,
					protection = true
				}
			},
			experimental = {
			}
		},
		deathknight = {
			blood = {},
			frost = {},
			unholy = {}
		},
		demonhunter = {
			havoc = {},
			vengeance = {},
			devourer = {}
		},
		druid = {
			balance = {},
			feral = {},
			guardian = {},
			restoration = {}
		},
		evoker = {
			devastation = {},
			preservation = {},
			augmentation = {}
		},
		hunter = {
			beastMastery = {},
			marksmanship = {},
			survival = {}
		},
		mage = {
			arcane = {},
			fire = {},
			frost = {}
		},
		monk = {
			brewmaster = {},
			mistweaver = {},
			windwalker = {}
		},
		paladin = {
			holy = {},
			protection = {},
			retribution = {}
		},
		priest = {
			discipline = {},
			holy = {},
			shadow = {}
		},
		rogue = {
			assassination = {},
			outlaw = {},
			subtlety = {}
		},
		shaman = {
			elemental = {},
			enhancement = {},
			restoration = {}
		},
		warlock = {
			affliction = {},
			demonology = {},
			destruction = {}
		},
		warrior = {
			arms = {},
			fury = {},
			protection = {}
		}
	}

	return settings
end

function TRB.Functions.Settings:PortForwardSettings()
	-- Migrate displayBar settings from old boolean format to new enum format
	local function MigrateDisplayBar(displayBar)
		if displayBar == nil then
			return
		end
		-- Check if already migrated (has primary key instead of alwaysShow)
		if displayBar.primary ~= nil then
			return
		end
		-- Migrate old format to new format
		---@type trbBarVisibility
		local primaryValue = "combat"
		if displayBar.alwaysShow == true then
			primaryValue = "always"
		elseif displayBar.neverShow == true then
			primaryValue = "never"
		end
		-- Set new values
		displayBar.primary = primaryValue
		displayBar.secondary = "combat"
		-- Remove old keys
		displayBar.alwaysShow = nil
		displayBar.notZeroShow = nil
		displayBar.neverShow = nil
	end

	-- Migrate core settings
	if TRB.Data.settings and TRB.Data.settings.core and TRB.Data.settings.core.displayBar then
		MigrateDisplayBar(TRB.Data.settings.core.displayBar)
	end

	-- Migrate all class/spec settings
	local classes = {
		"deathknight", "demonhunter", "druid", "evoker", "hunter",
		"mage", "monk", "paladin", "priest", "rogue",
		"shaman", "warlock", "warrior"
	}
	for _, className in ipairs(classes) do
		if TRB.Data.settings and TRB.Data.settings[className] then
			for specName, specSettings in pairs(TRB.Data.settings[className]) do
				if specSettings and specSettings.displayBar then
					MigrateDisplayBar(specSettings.displayBar)
				end
			end
		end
	end
end

function TRB.Functions.Settings:CleanupSettings(oldSettings)
	local newSettings = {}
	if oldSettings ~= nil then
		for k, v in pairs(oldSettings) do
			if  k == "core" or
				k == "deathknight" or
				k == "demonhunter" or
				k == "druid" or
				k == "evoker" or
				k == "hunter" or
				k == "mage" or
				k == "monk" or
				k == "paladin" or
				k == "priest" or
				k == "rogue" or
				k == "shaman" or
				k == "warlock" or
				k == "warrior"
			then
				newSettings[k] = v
			end
		end
	end
	return newSettings
end

function TRB.Functions.Settings:DefaultBarDimensions()
	return {
		width=300,
		height=30,
		xPos=0,
		yPos=-200,
		border=2,
		dragAndDrop=false,
		pinToPersonalResourceDisplay=false
	}
end

function TRB.Functions.Settings:DefaultHealthDimensions()
	return {
		width = 300,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelowMiddle"],
		fullWidth = true,
	}
end

function TRB.Functions.Settings:DefaultComboPointsDimensions()
	return {
		width=30,
		height=20,
		xPos=0,
		yPos=0,
		border=2,
		spacing=0,
		relativeTo="TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth=true,
	}
end

function TRB.Functions.Settings:DefaultHealthBarColors()
	return {
		border = { color = "FF008800" },
		background = { color = "66000000" },
		type = "step",
		low = { color = "FFFF0000", threshold = 0.0 },
		medium = { color = "FFFFFF00", threshold = 0.30 },
		high = { color = "FF00FF00", threshold = 0.70 }
	}
end

---comment
---@param includeComboPoints boolean?
---@return table
function TRB.Functions.Settings:DefaultTextures(includeComboPoints)
	local textures = {
		background="Interface\\Tooltips\\UI-Tooltip-Background",
		backgroundName="Blizzard Tooltip",
		border="Interface\\Buttons\\WHITE8X8",
		borderName="1 Pixel",
		resourceBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		resourceBarName=L["LSMStatusBarSmoother"],
		textureLock=true,
		healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
		healthBackgroundName="Blizzard Tooltip",
		healthBorder="Interface\\Buttons\\WHITE8X8",
		healthBorderName="1 Pixel",
		healthBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		healthBarName=L["LSMStatusBarSmoother"],
	}
	if includeComboPoints then
		textures.comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background"
		textures.comboPointsBackgroundName="Blizzard Tooltip"
		textures.comboPointsBorder="Interface\\Buttons\\WHITE8X8"
		textures.comboPointsBorderName="1 Pixel"
		textures.comboPointsBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
		textures.comboPointsBarName=L["LSMStatusBarSmoother"]
	end
	return textures
end


---@alias trbIncludeResourceType
---| '"resource"' # Generic $resource centered
---| '"mana"' # $mana% left, $mana / $manaMax right

---Adds default bar text that is used globally
---@param includeResourceType trbIncludeResourceType?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(includeResourceType)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$healthPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		},
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$health / $healthMax",
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
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		},
	}

	if includeResourceType == "resource" then
		table.insert(textSettings,
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid = TRB.Functions.String:Guid(),
			text="$resource",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
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
	elseif includeResourceType == "mana" then
		table.insert(textSettings,
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$manaPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=16,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		})
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$mana / $manaMax",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=16,
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
	end

	return textSettings
end