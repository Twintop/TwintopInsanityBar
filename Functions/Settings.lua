local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

--[[@type TRB.Classes.Settings.SpecializationGlobalEnabled]]
local specGlobalDefaults = {
	--specEnable = false,
	bar = false,
	comboPoints = false,
	thresholdIcons = false,
	thresholdHealers = false,
	thresholdPotions = false,
	--displayBar = false,
	displayText = false,
	textColors = false,
	thresholdColors = false,
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
				dragonriding = true
			},
			bar = {
				width = 555,
				height = 34,
				xPos = 0,
				yPos = -200,
				border = 4,
				dragAndDrop = false,
				pinToPersonalResourceDisplay = false
			},
			comboPoints = {
				width = 25,
				height = 13,
				xPos = 0,
				yPos = 4,
				border = 1,
				spacing = 14,
				relativeTo = "TOP",
				relativeToName = L["PositionAboveMiddle"],
				fullWidth = false,
			},
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
			textures={
				background = "Interface\\Tooltips\\UI-Tooltip-Background",
				backgroundName = "Blizzard Tooltip",
				border = "Interface\\Buttons\\WHITE8X8",
				borderName = "1 Pixel",
				resourceBar = "Interface\\TargetingFrame\\UI-StatusBar",
				resourceBarName = "Blizzard",
				textureLock = true,
				comboPointsBackground = "Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName = "Blizzard Tooltip",
				comboPointsBorder = "Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName = "1 Pixel",
				comboPointsBar = "Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName = "Blizzard",
				healthBackground="Interface\\Tooltips\\UI-Tooltip-Background",
				healthBackgroundName="Blizzard Tooltip",
				healthBorder="Interface\\Buttons\\WHITE8X8",
				healthBorderName="1 Pixel",
				healthBar="Interface\\TargetingFrame\\UI-StatusBar",
				healthBarName="Blizzard",
			},
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
				specs = {
				}
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