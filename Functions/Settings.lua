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
	displayBar = false,
	displayText = false,
	textColors = false,
	thresholdColors = false,
	healthBarColors = false,
	precision = false,
	textures = false
}

---Loads the default settings structure
---@param classic boolean?
---@return TRB.Classes.Settings.Core
function TRB.Functions.Settings:LoadDefaultSettings(classic)
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
				icons = TRB.Functions.Settings:DefaultThresholdIconmSettings(),
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
	local classes = {
		"deathknight", "demonhunter", "druid", "evoker", "hunter",
		"mage", "monk", "paladin", "priest", "rogue",
		"shaman", "warlock", "warrior"
	}
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
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.displayBar then
		MigrateDisplayBar(TwintopInsanityBarSettings.displayBar)
	end

	-- Migrate all class/spec settings
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if specSettings then
					if specSettings.displayBar then
						MigrateDisplayBar(specSettings.displayBar)
					end

					if specSettings.textures and not specSettings.healthBar then
						specSettings.healthBar = TRB.Functions.Settings:DefaultHealthDimensions(true)
						
						specSettings.textures.healthBackground="Interface\\Tooltips\\UI-Tooltip-Background"
						specSettings.textures.healthBackgroundName="Blizzard Tooltip"
						specSettings.textures.healthBorder="Interface\\Buttons\\WHITE8X8"
						specSettings.textures.healthBorderName="1 Pixel"
						specSettings.textures.healthBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
						specSettings.textures.healthBarName=L["LSMStatusBarSmoother"]

						local healthBarText = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings()
						for k,v in pairs(healthBarText) do table.insert(specSettings.displayText.barText, v) end
					end

					-- Migrate mana bar settings for Shadow Priest, Balance Druid, and Elemental Shaman
					local isManaBarSpec = (className == "priest" and specName == "shadow") or
						(className == "druid" and specName == "balance") or
						(className == "shaman" and specName == "elemental")

					if isManaBarSpec and specSettings.textures and not specSettings.manaBar then
						specSettings.manaBar = TRB.Functions.Settings:DefaultManaBarDimensions()
						
						if specSettings.displayBar then
							specSettings.displayBar.mana = "never"
						end

						if specSettings.colors then
							specSettings.colors.manaBar = TRB.Functions.Settings:DefaultManaBarColors()
						end

						specSettings.textures.manaBarBackground="Interface\\Tooltips\\UI-Tooltip-Background"
						specSettings.textures.manaBarBackgroundName="Blizzard Tooltip"
						specSettings.textures.manaBarBorder="Interface\\Buttons\\WHITE8X8"
						specSettings.textures.manaBarBorderName="1 Pixel"
						specSettings.textures.manaBarBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
						specSettings.textures.manaBarBarName=L["LSMStatusBarSmoother"]

						local manaBarText = TRB.Functions.Settings:LoadDefaultManaBarTextSettings()
						if specSettings.displayText and specSettings.displayText.barText then
							for k,v in pairs(manaBarText) do table.insert(specSettings.displayText.barText, v) end
						end
					end

					-- Ensure mana bar colors exist for mana bar specs (in case manaBar was added but colors weren't)
					if isManaBarSpec and specSettings.colors and not specSettings.colors.manaBar then
						specSettings.colors.manaBar = TRB.Functions.Settings:DefaultManaBarColors()
					end

					-- Ensure mana bar text color exists for mana bar specs
					if isManaBarSpec and specSettings.colors and specSettings.colors.text and not specSettings.colors.text.manaBar then
						specSettings.colors.text.manaBar = { color = "FF0000FF" }
					end

					-- Migrate Brewmaster Stagger bar from old comboPoints structure to new bars.stagger structure
					if className == "monk" and specName == "brewmaster" then
						-- Migrate dimensions: comboPoints -> bars.stagger
						if specSettings.comboPoints and not specSettings.bars then
							specSettings.bars = {}
						end
						if specSettings.comboPoints and specSettings.bars and not specSettings.bars.stagger then
							specSettings.bars.stagger = {
								width = specSettings.comboPoints.width or 555,
								height = specSettings.comboPoints.height or 24,
								xPos = specSettings.comboPoints.xPos or 0,
								yPos = specSettings.comboPoints.yPos or 4,
								border = specSettings.comboPoints.border or 2,
								spacing = specSettings.comboPoints.spacing or 0,
								relativeTo = specSettings.comboPoints.relativeTo or "TOP",
								relativeToName = specSettings.comboPoints.relativeToName or L["PositionAboveMiddle"],
								fullWidth = specSettings.comboPoints.fullWidth
							}
						end

						-- Migrate colors: colors.comboPoints -> colors.bars.stagger
						if specSettings.colors and specSettings.colors.comboPoints then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.stagger then
								local oldColors = specSettings.colors.comboPoints
								specSettings.colors.bars.stagger = {
									border = { color = oldColors.border or "FF00FF98" },
									background = { color = oldColors.background or "66000000" },
									type = oldColors.type or "step",
									low = { color = oldColors.light and oldColors.light.color or "FF85FF85", threshold = 0.0 },
									medium = { color = oldColors.medium and oldColors.medium.color or "FFFFFAB8", threshold = oldColors.medium and oldColors.medium.threshold or 0.30 },
									heavy = { color = oldColors.heavy and oldColors.heavy.color or "FFFF6B6B", threshold = oldColors.heavy and oldColors.heavy.threshold or 0.60 }
								}
							end
						end

						-- Migrate textures: textures.comboPointsBar/etc -> flat stagger texture keys
						if specSettings.textures then
							if not specSettings.textures.staggerBar then
								specSettings.textures.staggerBar = specSettings.textures.comboPointsBar or specSettings.textures.resourceBar
								specSettings.textures.staggerBarName = specSettings.textures.comboPointsBarName or specSettings.textures.resourceBarName
								specSettings.textures.staggerBorder = specSettings.textures.comboPointsBorder or specSettings.textures.border
								specSettings.textures.staggerBorderName = specSettings.textures.comboPointsBorderName or specSettings.textures.borderName
								specSettings.textures.staggerBackground = specSettings.textures.comboPointsBackground or specSettings.textures.background
								specSettings.textures.staggerBackgroundName = specSettings.textures.comboPointsBackgroundName or specSettings.textures.backgroundName
							end
						end

						-- Migrate displayBar: secondary -> stagger
						if specSettings.displayBar and specSettings.displayBar.secondary and not specSettings.displayBar.stagger then
							specSettings.displayBar.stagger = specSettings.displayBar.secondary
						elseif specSettings.displayBar and not specSettings.displayBar.stagger then
							specSettings.displayBar.stagger = "combat"
						end
					end

					-- Migrate Protection Warrior Defensives bar from old comboPoints structure to new bars.defensives structure
					if className == "warrior" and specName == "protection" then
						-- Migrate dimensions: comboPoints -> bars.defensives
						if specSettings.comboPoints and not specSettings.bars then
							specSettings.bars = {}
						end
						if specSettings.comboPoints and specSettings.bars and not specSettings.bars.defensives then
							specSettings.bars.defensives = {
								width = specSettings.comboPoints.width or 555,
								height = specSettings.comboPoints.height or 24,
								xPos = specSettings.comboPoints.xPos or 0,
								yPos = specSettings.comboPoints.yPos or 4,
								border = specSettings.comboPoints.border or 2,
								spacing = specSettings.comboPoints.spacing or 0,
								relativeTo = specSettings.comboPoints.relativeTo or "TOP",
								relativeToName = specSettings.comboPoints.relativeToName or L["PositionAboveMiddle"],
								fullWidth = specSettings.comboPoints.fullWidth
							}
							specSettings.comboPoints = nil -- Remove old comboPoints after migration
						end

						-- Migrate colors: colors.comboPoints.ignorePain/shieldBlock -> colors.bars.defensives.nodeColors
						if specSettings.colors and specSettings.colors.comboPoints then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.defensives then
								local oldColors = specSettings.colors.comboPoints
								specSettings.colors.bars.defensives = {
									border = { color = oldColors.border or "FFC21807" },
									background = { color = oldColors.background or "66000000" },
									nodeColors = {
										ignorePain = {
											color = oldColors.ignorePain and oldColors.ignorePain.color or "FFFFD000",
											enabled = oldColors.ignorePain and oldColors.ignorePain.enabled ~= false
										},
										shieldBlock = {
											color = oldColors.shieldBlock and oldColors.shieldBlock.color or "FF0099FF",
											enabled = oldColors.shieldBlock and oldColors.shieldBlock.enabled ~= false
										}
									}
								}
								specSettings.colors.comboPoints = nil -- Remove old colors after migration
							end
						end

						-- Migrate textures: textures.comboPointsBar/etc -> flat defensives texture keys
						if specSettings.textures then
							if not specSettings.textures.defensivesBar then
								specSettings.textures.defensivesBar = specSettings.textures.comboPointsBar or specSettings.textures.resourceBar
								specSettings.textures.defensivesBarName = specSettings.textures.comboPointsBarName or specSettings.textures.resourceBarName
								specSettings.textures.defensivesBorder = specSettings.textures.comboPointsBorder or specSettings.textures.border
								specSettings.textures.defensivesBorderName = specSettings.textures.comboPointsBorderName or specSettings.textures.borderName
								specSettings.textures.defensivesBackground = specSettings.textures.comboPointsBackground or specSettings.textures.background
								specSettings.textures.defensivesBackgroundName = specSettings.textures.comboPointsBackgroundName or specSettings.textures.backgroundName

								specSettings.textures.comboPointsBar = nil
								specSettings.textures.comboPointsBarName = nil
								specSettings.textures.comboPointsBorder = nil
								specSettings.textures.comboPointsBorderName = nil
								specSettings.textures.comboPointsBackground = nil
								specSettings.textures.comboPointsBackgroundName = nil
							end
						end

						-- Migrate displayBar: secondary -> defensives
						if specSettings.displayBar and specSettings.displayBar.secondary and not specSettings.displayBar.defensives then
							specSettings.displayBar.defensives = specSettings.displayBar.secondary
							specSettings.displayBar.secondary = nil
						elseif specSettings.displayBar and not specSettings.displayBar.defensives then
							specSettings.displayBar.defensives = "combat"
						end

						-- Ensure bars.defensives exists (fallback if no migration source)
						if not specSettings.bars then
							specSettings.bars = {}
						end
						if not specSettings.bars.defensives then
							specSettings.bars.defensives = TRB.Functions.Settings:DefaultDefensivesBarDimensions()
						end

						-- Ensure colors.bars.defensives exists (fallback if no migration source)
						if specSettings.colors then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.defensives then
								specSettings.colors.bars.defensives = TRB.Functions.Settings:DefaultDefensivesBarColors()
							end
						end

						-- Ensure textures exist (fallback if no migration source)
						if specSettings.textures and not specSettings.textures.defensivesBar then
							specSettings.textures.defensivesBar = specSettings.textures.resourceBar
							specSettings.textures.defensivesBarName = specSettings.textures.resourceBarName
							specSettings.textures.defensivesBorder = specSettings.textures.border
							specSettings.textures.defensivesBorderName = specSettings.textures.borderName
							specSettings.textures.defensivesBackground = specSettings.textures.background
							specSettings.textures.defensivesBackgroundName = specSettings.textures.backgroundName
						end
					end
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

---Gets the default primary bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.PrimaryBar
function TRB.Functions.Settings:DefaultBarDimensions(classic)
	local width = 300
	local border = 2

	if classic then
		border = 4
		width = 555
	end

	return {
		width = width,
		height = 30,
		xPos = 0,
		yPos = -200,
		border = border,
		dragAndDrop = false,
		pinToPersonalResourceDisplay = false
	}
end

---Gets the default health bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultHealthDimensions(classic)
	local width = 300
	local height = 20
	local yPos = 0
	local border = 2

	if classic then
		yPos = -4
		width = 555
		height = 13
		border = 1
	end

	return {
		width = width,
		height = height,
		xPos = 0,
		yPos = yPos,
		border = border,
		spacing = 0,
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelowMiddle"],
		fullWidth = true,
	}
end

---Gets the default secondary (comboPoints) dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultComboPointsDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		relativeTo ="TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
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

---Gets the default mana bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultManaBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 0,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
	}
end

---Gets the default mana bar colors
---@return TRB.Classes.Settings.GenericBarColorsBase
function TRB.Functions.Settings:DefaultManaBarColors()
	return {
		bar = { color = "FF0000FF" },
		border = { color = "FF0000AA" },
		background = { color = "66000000" }
	}
end

--[[
	Custom Bar Default Settings
	These functions provide defaults for bars stored under settings.bars.<key>,
	settings.colors.bars.<key>, and settings.textures.bars.<key>.
]]

---Gets the default dimensions for a custom bar (single node, fullWidth)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultCustomBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 0,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
	}
end

---Gets the default colors for a simple custom bar (no thresholds)
---@param barColor string? # ARGB hex color for bar (default: blue)
---@param borderColor string? # ARGB hex color for border (default: dark blue)
---@param backgroundColor string? # ARGB hex color for background (default: transparent black)
---@return table
function TRB.Functions.Settings:DefaultCustomBarColors(barColor, borderColor, backgroundColor)
	return {
		bar = { color = barColor or "FF0000FF" },
		border = { color = borderColor or "FF0000AA" },
		background = { color = backgroundColor or "66000000" }
	}
end

---Gets the default colors for a threshold-based custom bar (like Stagger or Health)
---@param lowColor string? # ARGB hex color for low state
---@param mediumColor string? # ARGB hex color for medium state
---@param highColor string? # ARGB hex color for high state
---@param mediumThreshold number? # Threshold for medium state (0-1)
---@param highThreshold number? # Threshold for high state (0-1)
---@param colorType string? # "step", "linear", or "none"
---@return table
function TRB.Functions.Settings:DefaultCustomBarThresholdColors(lowColor, mediumColor, highColor, mediumThreshold, highThreshold, colorType)
	return {
		border = { color = "FF000066" },
		background = { color = "66000000" },
		type = colorType or "step",
		low = { color = lowColor or "FF00FF00", threshold = 0.0 },
		medium = { color = mediumColor or "FFFFFF00", threshold = mediumThreshold or 0.30 },
		high = { color = highColor or "FFFF0000", threshold = highThreshold or 0.70 }
	}
end

---Gets the default textures for a custom bar (nested structure)
---@return table
function TRB.Functions.Settings:DefaultCustomBarTextures()
	return {
		bar = "Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		barName = L["LSMStatusBarSmoother"],
		border = "Interface\\Buttons\\WHITE8X8",
		borderName = "1 Pixel",
		background = "Interface\\Tooltips\\UI-Tooltip-Background",
		backgroundName = "Blizzard Tooltip"
	}
end

---Gets default Stagger bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultStaggerBarDimensions(classic)
	return self:DefaultCustomBarDimensions(classic)
end

---Gets default Stagger bar colors (green -> yellow -> red as stagger increases)
---@return table
function TRB.Functions.Settings:DefaultStaggerBarColors()
	return {
		border = { color = "FF000066" },
		background = { color = "66000000" },
		type = "step",
		low = { color = "FF00FF00", threshold = 0.0 },     -- Green (light stagger)
		medium = { color = "FFFFFF00", threshold = 0.30 }, -- Yellow (medium stagger)
		heavy = { color = "FFFF0000", threshold = 0.60 }   -- Red (heavy stagger)
	}
end

---Gets default Warrior Defensives bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultDefensivesBarDimensions(classic)
	-- Defensives is a 2-node bar (Ignore Pain + Shield Block)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
	}
end

---Gets default Warrior Defensives bar colors
---@return table
function TRB.Functions.Settings:DefaultDefensivesBarColors()
	return {
		border = { color = "FFC21807" },
		background = { color = "66000000" },
		nodeColors = {
			ignorePain = { color = "FFFFD000", enabled = true },
			shieldBlock = { color = "FF0099FF", enabled = true }
		}
	}
end

---Gets the default textures for bars
---@param includeComboPoints boolean?
---@param includeManaBar boolean?
---@return table
function TRB.Functions.Settings:DefaultTextures(includeComboPoints, includeManaBar)
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
	if includeManaBar then
		textures.manaBarBackground="Interface\\Tooltips\\UI-Tooltip-Background"
		textures.manaBarBackgroundName="Blizzard Tooltip"
		textures.manaBarBorder="Interface\\Buttons\\WHITE8X8"
		textures.manaBarBorderName="1 Pixel"
		textures.manaBarBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga"
		textures.manaBarBarName=L["LSMStatusBarSmoother"]
	end
	return textures
end

---Gets the default settings for threshold icons
---@return table
function TRB.Functions.Settings:DefaultThresholdIconmSettings()
	return {
		showCooldown = true,
		border = 2,
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelow"],
		enabled = true,
		desaturated = true,
		xPos = 0,
		yPos = 12,
		width = 24,
		height = 24
	}
end

---Returns default bar text for the health bar
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)
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
			text="$health/$healthMax $healthPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "HealthBar",
				relativeToFrameName = L["HealthBar"]
			}
		})
	else
		table.insert(textSettings, {
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
		})
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$health",
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
		})
	end
	return textSettings
end

---Returns default bar text for a secondary mana bar (used by DPS casters like Shadow Priest, Balance Druid, Elemental Shaman)
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultManaBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}

	if classic then
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$mana/$manaMax $manaPercent%",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			color = "FFFFFFFF",
			position = {
				xPos = -2,
				yPos = 0,
				relativeTo = "RIGHT",
				relativeToName = L["PositionRight"],
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
	else
		table.insert(textSettings, {
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
			fontSize=14,
			color = "FFFFFFFF",
			position = {
				xPos = 2,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$mana",
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
				relativeToFrame = "ManaBar",
				relativeToFrameName = L["ManaBar"]
			}
		})
	end
	return textSettings
end


---@alias trbIncludeResourceType
---| '"resource"' # Generic $resource centered
---| '"mana"' # $mana% left, $mana / $manaMax right

---Adds default bar text that is used globally
---@param includeResourceType trbIncludeResourceType?
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(includeResourceType, classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)

	if includeResourceType == "resource" then
		if classic then
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]$resource",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=20,
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
		end
	elseif includeResourceType == "mana" then
		if classic then
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]$mana/$manaMax $manaPercent%",
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
		else
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
				text="$mana",
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
	end

	return textSettings
end