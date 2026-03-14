local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

---Creates a new independent copy of NewSpecGlobalDefaults()
---@return TRB.Classes.Settings.SpecializationGlobalEnabled
local function NewSpecGlobalDefaults()
    return {
		--specEnable = false,
		bar = false,
		comboPoints = false,
		healthBar = false,
		thresholdIcons = false,
		displayBar = false,
		displayText = false,
		globalBarText = true,
		textColors = false,
		thresholdColors = false,
		healthBarColors = false,
		precision = false,
		textures = false
	}
end

---Loads the default settings structure
---@param classic boolean?
---@return table
function TRB.Functions.Settings:LoadDefaultSettings(classic)
	local settings = {
		manualUpdateChecks = {
			midnightBarTextReset = {
				deathknight = true,
				demonhunter = false,
				druid = false,
				evoker = false,
				hunter = false,
				mage = true,
				monk = false,
				paladin = false,
				priest = false,
				rogue = false,
				shaman = false,
				warlock = false,
				warrior = false
			}
		},
		core = {
			dataRefreshRate = 5.0,
			reactionTime = 0.1,
			news = {
				enabled = true,
				lastUpdate = ""
			},
			numberAbbreviation = true,
			minimap = {
				hide = false,
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
				icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
			},
			displayBar = {
				primary = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0
				},
				secondary = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					smooth = false,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0
				},
				health = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0
				},
				utility = {
					neverShow = true,
					alwaysShow = false,
					conditions = {},
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0
				},
			},
			overcap = {
				mode = "relative",
				relative = 0,
				fixed = 100
			},
			bar = TRB.Functions.Settings:DefaultBarDimensions(classic),
			comboPoints = TRB.Functions.Settings:DefaultComboPointsDimensions(classic),
			healthBar = TRB.Functions.Settings:DefaultHealthDimensions(classic),
			precision = {
				health = 1,
				secondary = 2,
				resource = 0,
				mana = 1
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
					overcap = {
						color = "FFFF0000",
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
					fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
					fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
					fontJustifyHorizontal = "LEFT",
					fontJustifyHorizontalName = L["PositionLeft"],
					fontSize = 18,
					color = {
						color = "FFFFFFFF"
					},
				},
				barText = TRB.Functions.Settings:LoadDefaultGlobalBarTextSettings(classic),
				migrations = {
					healthBarText = true
				}
			},
			global = {
				globalEnable = false,
				deathknight = {
					blood = NewSpecGlobalDefaults(),
					frost = NewSpecGlobalDefaults(),
					unholy = NewSpecGlobalDefaults()
				},
				demonhunter = {
					havoc = NewSpecGlobalDefaults(),
					vengeance = NewSpecGlobalDefaults(),
					devourer = NewSpecGlobalDefaults()
				},
				druid = {
					balance = NewSpecGlobalDefaults(),
					feral = NewSpecGlobalDefaults(),
					guardian = NewSpecGlobalDefaults(),
					restoration = NewSpecGlobalDefaults()
				},
				evoker = {
					devastation = NewSpecGlobalDefaults(),
					preservation = NewSpecGlobalDefaults(),
					augmentation = NewSpecGlobalDefaults()
				},
				hunter = {
					beastMastery = NewSpecGlobalDefaults(),
					marksmanship = NewSpecGlobalDefaults(),
					survival = NewSpecGlobalDefaults()
				},
				mage = {
					arcane = NewSpecGlobalDefaults(),
					fire = NewSpecGlobalDefaults(),
					frost = NewSpecGlobalDefaults()
				},
				monk = {
					brewmaster = NewSpecGlobalDefaults(),
					mistweaver = NewSpecGlobalDefaults(),
					windwalker = NewSpecGlobalDefaults()
				},
				paladin = {
					holy = NewSpecGlobalDefaults(),
					protection = NewSpecGlobalDefaults(),
					retribution = NewSpecGlobalDefaults(),
				},
				priest = {
					discipline = NewSpecGlobalDefaults(),
					holy = NewSpecGlobalDefaults(),
					shadow = NewSpecGlobalDefaults()
				},
				rogue = {
					assassination = NewSpecGlobalDefaults(),
					outlaw = NewSpecGlobalDefaults(),
					subtlety = NewSpecGlobalDefaults()
				},
				shaman = {
					elemental = NewSpecGlobalDefaults(),
					enhancement = NewSpecGlobalDefaults(),
					restoration = NewSpecGlobalDefaults()
				},
				warlock = {
					affliction = NewSpecGlobalDefaults(),
					demonology = NewSpecGlobalDefaults(),
					destruction = NewSpecGlobalDefaults()
				},
				warrior = {
					arms = NewSpecGlobalDefaults(),
					fury = NewSpecGlobalDefaults(),
					protection = NewSpecGlobalDefaults()
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
			},
			editMode = {
				layouts = {}
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
	
	-- Forward port old Insanity Bar settings
	if TwintopInsanityBarSettings ~= nil and TwintopInsanityBarSettings.priest == nil and TwintopInsanityBarSettings.bar ~= nil then
		local tempSettings = TwintopInsanityBarSettings
		TwintopInsanityBarSettings.priest = {}
		TwintopInsanityBarSettings.priest.discipline = {}
		TwintopInsanityBarSettings.priest.holy = {}
		TwintopInsanityBarSettings.priest.shadow = tempSettings
		TwintopInsanityBarSettings.priest.shadow.textures.resourceBar = TwintopInsanityBarSettings.priest.shadow.textures.insanityBar
		TwintopInsanityBarSettings.priest.shadow.textures.resourceBarName = TwintopInsanityBarSettings.priest.shadow.textures.insanityBarName
		TwintopInsanityBarSettings.core = {}
		TwintopInsanityBarSettings.core.dataRefreshRate = tempSettings.dataRefreshRate
		TwintopInsanityBarSettings.core.ttd = tempSettings.ttd
		TwintopInsanityBarSettings.core.audio = {}
		TwintopInsanityBarSettings.core.audio.channel = tempSettings.audio.channel
		TwintopInsanityBarSettings.core.strata = tempSettings.strata
	end

	-- Forward port old In/Out of Voidform settings
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.displayText ~= nil and
		TwintopInsanityBarSettings.priest.shadow.displayText.left ~= nil and
		TwintopInsanityBarSettings.priest.shadow.displayText.left.text == nil then
		local leftText = ""
		local middleText = ""
		local rightText = ""
		
		if TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText then
			leftText = TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText
		else
			leftText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText .. "]"
		end
		TwintopInsanityBarSettings.priest.shadow.displayText.left.text = leftText
		TwintopInsanityBarSettings.priest.shadow.displayText.left.inVoidformText = nil
		TwintopInsanityBarSettings.priest.shadow.displayText.left.outVoidformText = nil
		
		if TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText then
			middleText = TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText
		else
			middleText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText .. "]"
		end
		TwintopInsanityBarSettings.priest.shadow.displayText.middle.text = middleText
		TwintopInsanityBarSettings.priest.shadow.displayText.middle.inVoidformText = nil
		TwintopInsanityBarSettings.priest.shadow.displayText.middle.outVoidformText = nil
		
		if TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText == TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText then
			rightText = TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText
		else
			rightText = "{$vfTime}[" .. TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText .. "][" .. TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText .. "]"
		end
		TwintopInsanityBarSettings.priest.shadow.displayText.right.text = rightText
		TwintopInsanityBarSettings.priest.shadow.displayText.right.inVoidformText = nil
		TwintopInsanityBarSettings.priest.shadow.displayText.right.outVoidformText = nil
	end

	-- Shadow Thresholds
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.thresholdWidth ~= nil then
		
		TwintopInsanityBarSettings.priest.shadow.thresholds = {
			width = TwintopInsanityBarSettings.priest.shadow.thresholdWidth,
			overlapBorder = TwintopInsanityBarSettings.priest.shadow.thresholdsOverlapBorder,
			devouringPlague = {
				enabled = TwintopInsanityBarSettings.priest.shadow.devouringPlagueThreshold
			}
		}

		TwintopInsanityBarSettings.priest.shadow.thresholdWidth = nil
		TwintopInsanityBarSettings.priest.shadow.devouringPlagueThreshold = nil
		TwintopInsanityBarSettings.priest.shadow.searingNightmareThreshold = nil
		TwintopInsanityBarSettings.priest.shadow.thresholdsOverlapBorder = nil
	end

	-- Holy Thresholds
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.holy ~= nil and
	TwintopInsanityBarSettings.priest.holy.thresholdWidth ~= nil then
		
		TwintopInsanityBarSettings.priest.holy.thresholds.width = TwintopInsanityBarSettings.priest.holy.thresholdWidth
		TwintopInsanityBarSettings.priest.holy.thresholds.overlapBorder = TwintopInsanityBarSettings.priest.holy.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.priest.holy.thresholdWidth = nil
		TwintopInsanityBarSettings.priest.holy.thresholdsOverlapBorder = nil
	end

	-- Balance Thresholds
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.druid ~= nil and
	TwintopInsanityBarSettings.druid.balance ~= nil and
	TwintopInsanityBarSettings.druid.balance.thresholdWidth ~= nil then
	
		TwintopInsanityBarSettings.druid.balance.thresholds = {
			width = TwintopInsanityBarSettings.druid.balance.thresholdWidth,
			overlapBorder = TwintopInsanityBarSettings.druid.balance.thresholdsOverlapBorder,
			starsurgeThresholdOnlyOverShow = TwintopInsanityBarSettings.druid.balance.starsurgeThresholdOnlyOverShow,
			starsurge = {
				enabled = TwintopInsanityBarSettings.druid.balance.starsurgeThreshold
			},
			starsurge2 = {
				enabled = TwintopInsanityBarSettings.druid.balance.starsurge2Threshold
			},
			starsurge3 = {
				enabled = TwintopInsanityBarSettings.druid.balance.starsurge3Threshold
			},
			starfall = {
				enabled = TwintopInsanityBarSettings.druid.balance.starfallThreshold
			}
		}

		TwintopInsanityBarSettings.druid.balance.thresholdWidth = nil
		TwintopInsanityBarSettings.druid.balance.devouringPlagueThreshold = nil
		TwintopInsanityBarSettings.druid.balance.searingNightmareThreshold = nil
		TwintopInsanityBarSettings.druid.balance.thresholdsOverlapBorder = nil
	end
  
	-- Elemental Thresholds
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.elemental ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholdWidth ~= nil then

		TwintopInsanityBarSettings.shaman.elemental.thresholds = {
			width = TwintopInsanityBarSettings.shaman.elemental.thresholdWidth,
			overlapBorder = TwintopInsanityBarSettings.shaman.elemental.thresholdsOverlapBorder,
			earthShock = {
				enabled = TwintopInsanityBarSettings.shaman.elemental.earthShockThreshold
			}
		}
		
		TwintopInsanityBarSettings.shaman.elemental.thresholdWidth = nil
		TwintopInsanityBarSettings.shaman.elemental.earthShockThreshold = nil
		TwintopInsanityBarSettings.shaman.elemental.thresholdsOverlapBorder = nil
	end

	-- Hunter Thresholds
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.hunter.beastMastery.thresholds.width = TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth
		TwintopInsanityBarSettings.hunter.beastMastery.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.beastMastery.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.hunter.beastMastery.thresholdWidth = nil
		TwintopInsanityBarSettings.hunter.beastMastery.thresholdsOverlapBorder = nil
	end
	
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.hunter.marksmanship.thresholds.width = TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth
		TwintopInsanityBarSettings.hunter.marksmanship.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.marksmanship.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.hunter.marksmanship.thresholdWidth = nil
		TwintopInsanityBarSettings.hunter.marksmanship.thresholdsOverlapBorder = nil
	end
	
	-- ChimaeraShot threshold
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.thresholds ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.thresholds.chimaeraShot == nil then
		
		TwintopInsanityBarSettings.hunter.marksmanship.thresholds.chimaeraShot = TwintopInsanityBarSettings.hunter.marksmanship.thresholds.arcaneShot
	end

	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.survival ~= nil and
		TwintopInsanityBarSettings.hunter.survival.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.hunter.survival.thresholds.width = TwintopInsanityBarSettings.hunter.survival.thresholdWidth
		TwintopInsanityBarSettings.hunter.survival.thresholds.overlapBorder = TwintopInsanityBarSettings.hunter.survival.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.hunter.survival.thresholds.mongooseBite = {
			enabled = TwintopInsanityBarSettings.hunter.survival.thresholds.raptorStrike.enabled
		}
		TwintopInsanityBarSettings.hunter.survival.thresholds.butchery = {
			enabled = TwintopInsanityBarSettings.hunter.survival.thresholds.carve.enabled
		}

		TwintopInsanityBarSettings.hunter.survival.thresholdWidth = nil
		TwintopInsanityBarSettings.hunter.survival.thresholdsOverlapBorder = nil
	end

	-- Warriors
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.warrior ~= nil and
	TwintopInsanityBarSettings.warrior.arms ~= nil and
	TwintopInsanityBarSettings.warrior.arms.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.warrior.arms.thresholds.width = TwintopInsanityBarSettings.warrior.arms.thresholdWidth
		TwintopInsanityBarSettings.warrior.arms.thresholds.overlapBorder = TwintopInsanityBarSettings.warrior.arms.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.warrior.arms.thresholdWidth = nil
		TwintopInsanityBarSettings.warrior.arms.thresholdsOverlapBorder = nil
	end
	
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.warrior.fury.thresholds.width = TwintopInsanityBarSettings.warrior.fury.thresholdWidth
		TwintopInsanityBarSettings.warrior.fury.thresholds.overlapBorder = TwintopInsanityBarSettings.warrior.fury.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.warrior.fury.thresholdWidth = nil
		TwintopInsanityBarSettings.warrior.fury.thresholdsOverlapBorder = nil
	end

	-- Havoc
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.demonhunter ~= nil and
	TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
	TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.demonhunter.havoc.thresholds.width = TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth
		TwintopInsanityBarSettings.demonhunter.havoc.thresholds.overlapBorder = TwintopInsanityBarSettings.demonhunter.havoc.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.demonhunter.havoc.thresholdWidth = nil
		TwintopInsanityBarSettings.demonhunter.havoc.thresholdsOverlapBorder = nil
	end

	-- Assassination
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.assassination ~= nil and
		TwintopInsanityBarSettings.rogue.assassination.thresholdWidth ~= nil then
			
		TwintopInsanityBarSettings.rogue.assassination.thresholds.width = TwintopInsanityBarSettings.rogue.assassination.thresholdWidth
		TwintopInsanityBarSettings.rogue.assassination.thresholds.overlapBorder = TwintopInsanityBarSettings.rogue.assassination.thresholdsOverlapBorder
		
		TwintopInsanityBarSettings.rogue.assassination.thresholdWidth = nil
		TwintopInsanityBarSettings.rogue.assassination.thresholdsOverlapBorder = nil
	end


	-- Shadow Voidform color variable name changed to Devouring Plague
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors.bar ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform ~= nil then
		TwintopInsanityBarSettings.priest.shadow.colors.bar.devouringPlagueUsable = TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform
		TwintopInsanityBarSettings.priest.shadow.colors.bar.enterVoidform = nil
	end

	-- Elemental Elemental Blast threshold split from Earth Shock
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.elemental ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds.elementalBlast == nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.shaman.elemental.thresholds.elementalBlast = {
			enabled = TwintopInsanityBarSettings.shaman.elemental.thresholds.earthShock.enabled
		}
		
		TwintopInsanityBarSettings.shaman.elemental.thresholdWidth = nil
		TwintopInsanityBarSettings.shaman.elemental.earthShockThreshold = nil
		TwintopInsanityBarSettings.shaman.elemental.thresholdsOverlapBorder = nil
	end

	-- Shadow Instant Mindblast color
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors.bar ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors.bar.instantMindBlast ~= nil and
		type(TwintopInsanityBarSettings.priest.shadow.colors.bar.instantMindBlast) == "string" and
		type(TwintopInsanityBarSettings.priest.shadow.colors.bar.instantMindBlast) ~= "table" then
		local barColor = TwintopInsanityBarSettings.priest.shadow.colors.bar.instantMindBlast
		TwintopInsanityBarSettings.priest.shadow.colors.bar.instantMindBlast = {
			color = barColor,
			enabled = true
		}
	end

	-- Rename insanityPrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.insanityPrecision ~= nil
		then
		TwintopInsanityBarSettings.priest.shadow.precision.resource = TwintopInsanityBarSettings.priest.shadow.insanityPrecision
		TwintopInsanityBarSettings.priest.shadow.insanityPrecision = nil
	end

	-- Rename ragePrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.arms ~= nil and
		TwintopInsanityBarSettings.warrior.arms.ragePrecision ~= nil
		then
		TwintopInsanityBarSettings.warrior.arms.precision.resource = TwintopInsanityBarSettings.warrior.arms.ragePrecision
		TwintopInsanityBarSettings.warrior.arms.ragePrecision = nil
	end

	-- Rename ragePrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.ragePrecision ~= nil
		then
		TwintopInsanityBarSettings.warrior.fury.precision.resource = TwintopInsanityBarSettings.warrior.fury.ragePrecision
		TwintopInsanityBarSettings.warrior.fury.ragePrecision = nil
	end

	-- Rename astralPowerPrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.balance ~= nil and
		TwintopInsanityBarSettings.druid.balance.astralPowerPrecision ~= nil
		then
		TwintopInsanityBarSettings.druid.balance.precision.resource = TwintopInsanityBarSettings.druid.balance.astralPowerPrecision
		TwintopInsanityBarSettings.druid.balance.astralPowerPrecision = nil
	end

	-- Rename furyPrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.furyPrecision ~= nil
		then
		TwintopInsanityBarSettings.demonhunter.havoc.precision.resource = TwintopInsanityBarSettings.demonhunter.havoc.furyPrecision
		TwintopInsanityBarSettings.demonhunter.havoc.furyPrecision = nil
	end

	-- Change to new bar text format
	if TwintopInsanityBarSettings ~= nil then
		local classLength = TRB.Functions.Table:Length(TwintopInsanityBarSettings)
		if classLength > 0 then
			for class, classValue in pairs(TwintopInsanityBarSettings) do
				if class ~= "core" then
					local specLength = TRB.Functions.Table:Length(classValue)
					if specLength > 0 then
						for spec, specValue in pairs(classValue) do
							if specValue.displayText ~= nil and specValue.displayText.fontSizeLock ~= nil then
								specValue.displayText.default = {
									fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
									fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
									fontJustifyHorizontal = "LEFT",
									fontJustifyHorizontalName = L["PositionLeft"],
									fontSize=18,
									color = {
										color = "FFFFFFFF"
									}
								}

								if specValue.displayText.fontSizeLock then
									specValue.displayText.default.fontSize = specValue.displayText.left.fontSize
								end

								if specValue.displayText.fontFaceLock then
									specValue.displayText.default.fontFace = specValue.displayText.left.fontFace
									specValue.displayText.default.fontFaceName = specValue.displayText.left.fontFaceName
								end

								specValue.displayText.barText = {
									{
										enabled = true,
										useDefaultFontColor = false,
										useDefaultFontFace = specValue.displayText.fontFaceLock,
										useDefaultFontSize = specValue.displayText.fontSizeLock,
										name = L["PositionLeft"],
										guid = TRB.Functions.String:Guid(),
										text=specValue.displayText.left.text,
										fontFace=specValue.displayText.left.fontFace,
										fontFaceName=specValue.displayText.left.fontFaceName,
										fontJustifyHorizontal = "LEFT",
										fontJustifyHorizontalName = L["PositionLeft"],
										fontSize = specValue.displayText.left.fontSize,
										color = specValue.colors.text.left,
										position = {
											xPos = 2,
											yPos = 0,
											relativeTo = "LEFT",
											relativeToName = L["PositionLeft"],
											relativeToFrame = "Resource",
											relativeToFrameName = L["MainResourceBar"]
										}
									},
									{
										enabled = true,
										useDefaultFontColor = false,
										useDefaultFontFace = specValue.displayText.fontFaceLock,
										useDefaultFontSize = specValue.displayText.fontSizeLock,
										name = L["PositionMiddle"],
										guid = TRB.Functions.String:Guid(),
										text=specValue.displayText.middle.text,
										fontFace=specValue.displayText.middle.fontFace,
										fontFaceName=specValue.displayText.middle.fontFaceName,
										fontJustifyHorizontal = "CENTER",
										fontJustifyHorizontalName = L["PositionCenter"],
										fontSize = specValue.displayText.middle.fontSize,
										color = specValue.colors.text.middle,
										position = {
											xPos = 0,
											yPos = 0,
											relativeTo = "CENTER",
											relativeToName = L["PositionCenter"],
											relativeToFrame = "Resource",
											relativeToFrameName = L["MainResourceBar"]
										}
									},
									{
										enabled = true,
										useDefaultFontColor = false,
										useDefaultFontFace = specValue.displayText.fontFaceLock,
										useDefaultFontSize = specValue.displayText.fontSizeLock,
										name = L["PositionRight"],
										guid = TRB.Functions.String:Guid(),
										text=specValue.displayText.right.text,
										fontFace=specValue.displayText.right.fontFace,
										fontFaceName=specValue.displayText.right.fontFaceName,
										fontJustifyHorizontal = "RIGHT",
										fontJustifyHorizontalName = L["PositionRight"],
										fontSize = specValue.displayText.right.fontSize,
										color = specValue.colors.text.right,
										position = {
											xPos = -2,
											yPos = 0,
											relativeTo = "RIGHT",
											relativeToName = L["PositionRight"],
											relativeToFrame = "Resource",
											relativeToFrameName = L["MainResourceBar"]
										}
									}
								}

								specValue.displayText.left = nil
								specValue.displayText.middle = nil
								specValue.displayText.right = nil
								specValue.displayText.fontSizeLock = nil
								specValue.displayText.fontFaceLock = nil
								specValue.colors.text.left = nil
								specValue.colors.text.middle = nil
								specValue.colors.text.right = nil

								if spec == "feral" then
									local enabled = true
									
									if specValue.comboPoints ~= nil and specValue.comboPoints.generation == false then
										enabled = false
									end

									---@type TRB.Classes.Settings.DisplayTextEntry[]
									local extraTextSettings = {
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{$predatorRevealedNextCp=($comboPoints+1)&$comboPoints=0}[$predatorRevealedTickTime]{$incarnationNextCp=($comboPoints+1)&$comboPoints=0}[$incarnationTickTime]",
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											name = "CP1",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["ComboPoint1"],
												yPos = 0,
												relativeToFrame = "ComboPoint_1",
											},
											fontJustifyHorizontal = "CENTER",
											useDefaultFontSize = false,
											fontSize = 14,
											color = { color = "FFFFFFFF" },
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=1)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=0)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=1)||($incarnationNextCp=($comboPoints+2)&$comboPoints=0)}[$incarnationTickTime]",
											color = { color = "FFFFFFFF" },
											name = "CP2",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["ComboPoint2"],
												yPos = 0,
												relativeToFrame = "ComboPoint_2",
											},
											fontJustifyHorizontal = "CENTER",
											useDefaultFontSize = false,
											fontSize = 14,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=2)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=1)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=2)||($incarnationNextCp=($comboPoints+2)&$comboPoints=1)}[$incarnationTickTime]",
											color = { color = "FFFFFFFF" },
											name = "CP3",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["ComboPoint3"],
												yPos = 0,
												relativeToFrame = "ComboPoint_3",
											},
											fontJustifyHorizontal = "CENTER",
											useDefaultFontSize = false,
											fontSize = 14,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=3)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=2)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=3)||($incarnationNextCp=($comboPoints+2)&$comboPoints=2)}[$incarnationTickTime]",
											color = { color = "FFFFFFFF" },
											name = "CP4",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = -3,
												relativeToFrameName = L["ComboPoint4"],
												yPos = 0,
												relativeToFrame = "ComboPoint_4",
											},
											fontJustifyHorizontal = "CENTER",
											useDefaultFontSize = false,
											fontSize = 14,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=4)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=3)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=4)||($incarnationNextCp=($comboPoints+2)&$comboPoints=3)}[$incarnationTickTime]",
											color = { color = "FFFFFFFF" },
											name = "CP5",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["ComboPoint5"],
												yPos = 0,
												relativeToFrame = "ComboPoint_5",
											},
											fontJustifyHorizontal = "CENTER",
											useDefaultFontSize = false,
											fontSize = 14,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
										}
									}

									for x = 1, #extraTextSettings do
										table.insert(specValue.displayText.barText, extraTextSettings[x])
									end
								elseif class == "priest" and spec == "holy" then
									local enabled = true

									---@type TRB.Classes.Settings.DisplayTextEntry[]
									local extraTextSettings = {
										{
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwSerenityTime&$hwSerenityCharges=0}[$hwSerenityTime]",
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											fontSize = 14,
											name = "HW Serenity 1",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["HolyWordSerenityCharge1"],
												yPos = 0,
												relativeToFrame = "HolyWord_Serenity_1",
											},
											fontJustifyHorizontal = "LEFT",
											useDefaultFontSize = false,
											color = { color = "FFFFFFFF" },
											enabled = enabled,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwSerenityTime&$hwSerenityCharges=1}[$hwSerenityTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
											name = "HW Serenity 2",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["HolyWordSerenityCharge2"],
												yPos = 0,
												relativeToFrame = "HolyWord_Serenity_2",
											},
											fontJustifyHorizontal = "LEFT",
											useDefaultFontSize = false,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwSanctifyTime&$hwSanctifyCharges=0}[$hwSanctifyTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
											name = "HW Sanctify 1",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["HolyWordSanctifyCharge1"],
												yPos = 0,
												relativeToFrame = "HolyWord_Sanctify_1",
											},
											fontJustifyHorizontal = "LEFT",
											useDefaultFontSize = false,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwSanctifyTime&$hwSanctifyCharges=1}[$hwSanctifyTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
											name = "HW Sanctify 2",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["HolyWordSanctifyCharge2"],
												yPos = 0,
												relativeToFrame = "HolyWord_Sanctify_2",
											},
											fontJustifyHorizontal = "LEFT",
											useDefaultFontSize = false,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwChastiseTime}[$hwChastiseTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
											name = "HW Chastise",
											position = {
												relativeToName = L["PositionCenter"],
												relativeTo = "CENTER",
												xPos = 0,
												relativeToFrameName = L["HolyWordChastiseCharge1"],
												yPos = 0,
												relativeToFrame = "HolyWord_Chastise_1",
											},
											fontJustifyHorizontal = "LEFT",
											useDefaultFontSize = false,
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										}
									}

									for x = 1, #extraTextSettings do
										table.insert(specValue.displayText.barText, extraTextSettings[x])
									end
								elseif class == "evoker" then
									local enabled = true

									---@type TRB.Classes.Settings.DisplayTextEntry[]
									local extraTextSettings = {
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=0}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=1}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=2}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=3}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=4}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$essence=5}[$essenceRegenTime]",
											fontSize = 14,
											color = { color = "FFFFFFFF" },
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
											fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
											useDefaultFontColor = false,
										}
									}

									for x = 1, #extraTextSettings do
										table.insert(specValue.displayText.barText, extraTextSettings[x])
									end
								end
							end
						end
					end
				end
			end
		end
	end

	-- Earthquake (Targeted)
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.elemental ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquakeTargeted == nil and
		TwintopInsanityBarSettings.shaman.elemental.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquakeTargeted = {
			enabled = TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquake.enabled
		}
	end

	-- Mindbender threshold for Discipline
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.discipline ~= nil and
	TwintopInsanityBarSettings.priest.discipline.thresholds ~= nil and
	TwintopInsanityBarSettings.priest.discipline.thresholds.mindbender == nil and
	TwintopInsanityBarSettings.priest.discipline.thresholds.thresholdDictionary == nil then
		TwintopInsanityBarSettings.priest.discipline.thresholds.mindbender = {
			enabled = TwintopInsanityBarSettings.priest.discipline.thresholds.shadowfiend
		}
	end

	-- Voidwraith threshold for Discipline
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.discipline ~= nil and
		TwintopInsanityBarSettings.priest.discipline.thresholds ~= nil and
		TwintopInsanityBarSettings.priest.discipline.thresholds.voidwraith == nil and
		TwintopInsanityBarSettings.priest.discipline.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.priest.discipline.thresholds.voidwraith = {
			enabled = TwintopInsanityBarSettings.priest.discipline.thresholds.shadowfiend
		}
	end

	-- Ravage thresholds for Feral
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.feral ~= nil and
		TwintopInsanityBarSettings.druid.feral.thresholds ~= nil and
		TwintopInsanityBarSettings.druid.feral.thresholds.ravage == nil and
		TwintopInsanityBarSettings.druid.feral.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.druid.feral.thresholds.ravage = {
			enabled = TwintopInsanityBarSettings.druid.feral.thresholds.ferociousBite
		}
		TwintopInsanityBarSettings.druid.feral.thresholds.ravageMinimum = {
			enabled = TwintopInsanityBarSettings.druid.feral.thresholds.ferociousBiteMinimum
		}
		TwintopInsanityBarSettings.druid.feral.thresholds.ravageMaximum = {
			enabled = TwintopInsanityBarSettings.druid.feral.thresholds.ferociousBiteMaximum
		}
	end

	-- Coup de Grace thresholds for Outlaw
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.thresholds ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.thresholds.coupDeGrace == nil and
		TwintopInsanityBarSettings.rogue.outlaw.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.rogue.outlaw.thresholds.coupDeGrace = {
			enabled = TwintopInsanityBarSettings.rogue.outlaw.thresholds.dispatch
		}
	end

	-- Coup de Grace thresholds for Subtlety
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.thresholds ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.thresholds.coupDeGrace == nil and
		TwintopInsanityBarSettings.rogue.subtlety.thresholds.thresholdDictionary == nil then

		TwintopInsanityBarSettings.rogue.subtlety.thresholds.coupDeGrace = {
			enabled = TwintopInsanityBarSettings.rogue.subtlety.thresholds.eviscerate
		}
	end

	-- Text color standardization for Shadow
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.shadow ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text.current == nil then
		TwintopInsanityBarSettings.priest.shadow.colors.text.current = TwintopInsanityBarSettings.priest.shadow.colors.text.currentInsanity
		TwintopInsanityBarSettings.priest.shadow.colors.text.casting = TwintopInsanityBarSettings.priest.shadow.colors.text.castingInsanity
		TwintopInsanityBarSettings.priest.shadow.colors.text.passive = TwintopInsanityBarSettings.priest.shadow.colors.text.passiveInsanity
		TwintopInsanityBarSettings.priest.shadow.colors.text.overcap = TwintopInsanityBarSettings.priest.shadow.colors.text.overcapInsanity
		TwintopInsanityBarSettings.priest.shadow.colors.text.currentInsanity = nil
		TwintopInsanityBarSettings.priest.shadow.colors.text.castingInsanity = nil
		TwintopInsanityBarSettings.priest.shadow.colors.text.passiveInsanity = nil
		TwintopInsanityBarSettings.priest.shadow.colors.text.overcapInsanity = nil
	end

	-- Text color standardization for Elemental
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.shaman ~= nil and
	TwintopInsanityBarSettings.shaman.elemental ~= nil and
	TwintopInsanityBarSettings.shaman.elemental.colors ~= nil and
	TwintopInsanityBarSettings.shaman.elemental.colors.text ~= nil and
	TwintopInsanityBarSettings.shaman.elemental.colors.text.current == nil then
		TwintopInsanityBarSettings.shaman.elemental.colors.text.current = TwintopInsanityBarSettings.shaman.elemental.colors.text.currentMaelstrom
		TwintopInsanityBarSettings.shaman.elemental.colors.text.casting = TwintopInsanityBarSettings.shaman.elemental.colors.text.castingMaelstrom
		TwintopInsanityBarSettings.shaman.elemental.colors.text.passive = TwintopInsanityBarSettings.shaman.elemental.colors.text.passiveMaelstrom
		TwintopInsanityBarSettings.shaman.elemental.colors.text.overcap = TwintopInsanityBarSettings.shaman.elemental.colors.text.overcapMaelstrom
		TwintopInsanityBarSettings.shaman.elemental.colors.text.currentMaelstrom = nil
		TwintopInsanityBarSettings.shaman.elemental.colors.text.castingMaelstrom = nil
		TwintopInsanityBarSettings.shaman.elemental.colors.text.passiveMaelstrom = nil
		TwintopInsanityBarSettings.shaman.elemental.colors.text.overcapMaelstrom = nil
	end

	-- Move bar smoothing setting and reset bar and comboPoint global settings
	-- NOTE: This migration is ONLY for very old settings that had core.bar.smooth.
	-- Modern settings have displayBar.primary as a table. Skip if already modern.
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.core ~= nil and
	TwintopInsanityBarSettings.core.smoothBarValueUpdates == nil and
	TwintopInsanityBarSettings.core.bar ~= nil and
	TwintopInsanityBarSettings.core.bar.smooth ~= nil then
		TwintopInsanityBarSettings.core.smoothBarValueUpdates = TwintopInsanityBarSettings.core.bar.smooth

		
		TwintopInsanityBarSettings.core.bar = {
			width = 555,
			height = 34,
			xPos = 0,
			yPos = -200,
			border = 4,
			dragAndDrop = false
		}
		TwintopInsanityBarSettings.core.comboPoints = {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = false,
		}

		TwintopInsanityBarSettings.core.bar.smooth = nil
	end

	-- Recent bar-wide refactors, starting February 2025
	if TwintopInsanityBarSettings ~= nil then
		local classLength = TRB.Functions.Table:Length(TwintopInsanityBarSettings)
		if classLength > 0 then
			for class, classValue in pairs(TwintopInsanityBarSettings) do
				if class == "core" then
				else
					local specLength = TRB.Functions.Table:Length(classValue)
					if specLength > 0 then
						for spec, specValue in pairs(classValue) do
							-- Global color settings refactor
							if specValue ~= nil and
							specValue.colors ~= nil and
							specValue.colors.text ~= nil and
							specValue.colors.text.current ~= nil and
							type(specValue.colors.text.current) == "string" then
								local colorsText = specValue.colors.text
								local newColorsText = {}
								
								newColorsText.current = {
									color = colorsText.current
								}
								newColorsText.casting = {
									color = colorsText.casting
								}
								newColorsText.passive = {
									color = colorsText.passive
								}

								if colorsText.spending ~= nil then
									newColorsText.spending = {
										color = colorsText.spending
									}
								end

								if colorsText.overcap ~= nil then
									newColorsText.overcap = {
										color = colorsText.overcap,
										enabled = colorsText.overcapEnabled
									}
								end

								if colorsText.overThreshold ~= nil then
									newColorsText.overThreshold = {
										color = colorsText.overThreshold,
										enabled = colorsText.overThresholdEnabled
									}
								end

								if colorsText.dots ~= nil then
									newColorsText.dots = {}
									
									newColorsText.dots.options = {
										enabled = colorsText.dots.enabled
									}

									if spec == "feral" then
										newColorsText.dots.same = {
											color = colorsText.dots.same
										}
										newColorsText.dots.down = {
											color = colorsText.dots.down
										}
										newColorsText.dots.worse = {
											color = colorsText.dots.worse
										}
										newColorsText.dots.better = {
											color = colorsText.dots.better
										}
									else
										newColorsText.dots.up = {
											color = colorsText.dots.up
										}
										newColorsText.dots.down = {
											color = colorsText.dots.down
										}
										newColorsText.dots.pandemic = {
											color = colorsText.dots.pandemic
										}
									end
								end

								specValue.colors.text = newColorsText
							end

							-- Change to new bar text format
							if specValue.hastePrecision ~= nil or specValue.resourcePrecision ~= nil then
								specValue.precision = {
									health = 1,
									secondary = specValue.hastePrecision or 0,
									resource = specValue.resourcePrecision or 0
								}
								specValue.hastePrecision = nil
								specValue.resourcePrecision = nil
							end
							
							-- Move bar settings for global settings
							if specValue ~= nil and
							specValue.bar ~= nil and
							(specValue.bar.showPassive ~= nil or specValue.bar.showCasting ~= nil) then
								specValue.colors = specValue.colors or {}
								specValue.colors.bar = specValue.colors.bar or {}
								specValue.colors.bar.showPassive = specValue.bar.showPassive
								specValue.colors.bar.showCasting = specValue.bar.showCasting

								specValue.bar.showPassive = nil
								specValue.bar.showCasting = nil
							end

							-- Extra variables for Holy Priest
							if spec == "holy" and class == "priest" then
								if specValue ~= nil and
								specValue.bar ~= nil and
								(specValue.bar.holyWordChastiseEnabled ~= nil or specValue.bar.holyWordSanctifyEnabled ~= nil or specValue.bar.holyWordSerenityEnabled ~= nil) then
									specValue.colors = specValue.colors or {}
									specValue.colors.bar = specValue.colors.bar or {}
									specValue.colors.bar.holyWordChastiseEnabled = specValue.bar.holyWordChastiseEnabled
									specValue.colors.bar.holyWordSanctifyEnabled = specValue.bar.holyWordSanctifyEnabled
									specValue.colors.bar.holyWordSerenityEnabled = specValue.bar.holyWordSerenityEnabled

									specValue.bar.holyWordChastiseEnabled = nil
									specValue.bar.holyWordSanctifyEnabled = nil
									specValue.bar.holyWordSerenityEnabled = nil
								end
							end
							
							-- Move combo point settings for global settings
							if specValue ~= nil and
							specValue.comboPoints ~= nil and
							specValue.comboPoints.consistentUnfilledColor ~= nil then
								specValue.colors = specValue.colors or {}
								specValue.colors.comboPoints = specValue.colors.bar or {}
								specValue.colors.comboPoints.consistentUnfilledColor = specValue.bar.consistentUnfilledColor

								specValue.comboPoints.consistentUnfilledColor = nil
							end

							-- Extra variables for Feral Druid
							if spec == "feral" then
								if specValue ~= nil and
								specValue.comboPoints ~= nil and
								(specValue.comboPoints.generation ~= nil or specValue.comboPoints.spec ~= nil) then
									specValue.colors = specValue.colors or {}
									specValue.colors.comboPoints = specValue.colors.comboPoints or {}
									specValue.colors.comboPoints.generation = specValue.comboPoints.generation
									specValue.colors.comboPoints.spec = specValue.comboPoints.spec

									specValue.comboPoints.spec = nil
								end
							end

							-- Extra variables for Assassination Rogue
							if spec == "assassination" then
								if specValue ~= nil and
								specValue.comboPoints ~= nil and
								specValue.comboPoints.spec ~= nil then
									specValue.colors = specValue.colors or {}
									specValue.colors.comboPoints = specValue.colors.comboPoints or {}
									specValue.colors.comboPoints.spec = specValue.comboPoints.spec

									specValue.comboPoints.spec = nil
								end
							end

							-- Adjust threshold object for global bar settings
							if specValue.thresholds ~= nil
							and specValue.thresholds.width ~= nil then
								specValue.thresholds.properties = {
									width = specValue.thresholds.width,
									overlapBorder = specValue.thresholds.overlapBorder,
									outOfRange = specValue.thresholds.outOfRange
								}
								specValue.thresholds.width = nil
								specValue.thresholds.overlapBorder = nil
								specValue.thresholds.outOfRange = nil
							end

							-- Special case rename for Elemental
							if spec == "elemental" then
								if specValue.colors ~= nil and
								specValue.colors.threshold ~= nil and
								type(specValue.colors.threshold.echoesOfGreatSundering) == "string" then
									specValue.colors.threshold.special = specValue.colors.threshold.echoesOfGreatSundering
									specValue.colors.threshold.echoesOfGreatSundering = nil
								end
							end

							-- Change mindbender to passive for healers
							if spec == "holy" or -- Priest or Paladin
							spec == "restoration" or -- Druid or Shaman
							spec == "mistweaver" or
							spec == "preservation" or
							spec == "discipline" then
								if specValue.colors ~= nil and
								specValue.colors.threshold ~= nil and
								type(specValue.colors.threshold.mindbender) == "string"  then
									specValue.colors.threshold.passive = specValue.colors.threshold.mindbender
									specValue.colors.threshold.mindbender = nil
								end
							end

							-- Clean up threshold colors
							if specValue.colors ~= nil and
							specValue.colors.threshold ~= nil then
								for colorName, colorValue in pairs(specValue.colors.threshold) do
									if colorValue ~= nil and type(colorValue) == "string" then
										specValue.colors.threshold[colorName] = {
											color = colorValue
										}
									end
								end
							end

							-- Move out of range enable/disable to be under colors
							if specValue.thresholds ~= nil and
							specValue.thresholds.properties ~= nil and
							specValue.thresholds.properties.outOfRange ~= nil and
							specValue.colors ~= nil and
							specValue.colors.threshold ~= nil and
							specValue.colors.threshold.outOfRange ~= nil then
								specValue.colors.threshold.outOfRange.enabled = specValue.thresholds.properties.outOfRange
								specValue.thresholds.properties.outOfRange = nil
							end

							if specValue.thresholds ~= nil and
							specValue.thresholds.thresholdDictionary == nil then
								specValue.thresholds.thresholdDictionary = {}
								for thresholdName, value in pairs(specValue.thresholds) do
									if value ~= nil and type(value) == "table" then
										if thresholdName ~= "properties" and thresholdName ~= "icons" and thresholdName ~= "potionCooldown" and thresholdName ~= "specProperties" and thresholdName ~= "thresholdDictionary" then
											specValue.thresholds.thresholdDictionary[thresholdName] = value
											specValue.thresholds[thresholdName] = nil
										end
									else
										specValue.thresholds.specProperties = specValue.thresholds.specProperties or {}
										specValue.thresholds.specProperties[thresholdName] = value
										specValue.thresholds[thresholdName] = nil
									end
								end
							end

							if spec == "shadow" and
							specValue.threshold ~= nil and
							specValue.threshold.devouringPlagueThresholdOnlyOverShow ~= nil then
								spec.thresholds.specProperties = spec.thresholds.specProperties or {}
								spec.thresholds.specProperties.devouringPlagueThresholdOnlyOverShow = spec.thresholds.devouringPlagueThresholdOnlyOverShow
								spec.thresholds.devouringPlagueThresholdOnlyOverShow = nil
							end
							
							if spec == "balance" and
							specValue.threshold ~= nil and
							specValue.threshold.starsurgeThresholdOnlyOverShow ~= nil then
								spec.thresholds.specProperties = spec.thresholds.specProperties or {}
								spec.thresholds.specProperties.starsurgeThresholdOnlyOverShow = spec.thresholds.starsurgeThresholdOnlyOverShow
								spec.thresholds.starsurgeThresholdOnlyOverShow = nil
							end
						end
					end
				end
			end
		end
	end
	
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
		local primaryValue = "always"
		if displayBar.alwaysShow == true then
			primaryValue = "always"
		elseif displayBar.neverShow == true then
			primaryValue = "never"
		end
		-- Set new values
		displayBar.primary = primaryValue
		displayBar.secondary = "always"
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

					-- Migrate mana bar settings for Shadow Priest and Elemental Shaman, Balance Druid is excluded.
					local isManaBarSpec = (className == "priest" and specName == "shadow") or
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
								yPos = specSettings.comboPoints.yPos or 0,
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
							specSettings.displayBar.stagger = "always"
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
								yPos = specSettings.comboPoints.yPos or 0,
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
							specSettings.displayBar.defensives = "always"
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

					-- Migrate displayText.default.color from flat string to table format
					if specSettings.displayText and specSettings.displayText.default and 
					   specSettings.displayText.default.color and type(specSettings.displayText.default.color) == "string" then
						specSettings.displayText.default.color = {
							color = specSettings.displayText.default.color
						}
					end

					-- Migrate colors.bar.casting / .spending from flat string to table format
					-- Old configs stored these as plain color strings (e.g., "FFFFFFFF").
					-- New code expects { color = "FFFFFFFF", enabled = true/false }.
					if specSettings.colors and specSettings.colors.bar then
						local bar = specSettings.colors.bar
						if type(bar.casting) == "string" then
							local enabled = bar.showCasting
							if enabled == nil then enabled = true end
							bar.casting = { color = bar.casting, enabled = enabled }
							bar.showCasting = nil
						elseif type(bar.casting) == "table" and bar.showCasting ~= nil then
							bar.casting.enabled = bar.showCasting
							bar.showCasting = nil
						end
						if type(bar.spending) == "string" then
							bar.spending = { color = bar.spending, enabled = true }
						end
					end

					-- Migrate old *BorderChange* and flat *Enabled flags to nested .enabled format
					-- This runs after the color table migration above, so colors are already in { color = "..." } format
					if specSettings.colors and specSettings.colors.bar then
						local bar = specSettings.colors.bar
						
						-- Map of old enabled flag names to their corresponding color key
						-- Format: oldFlagName = colorKey (the .enabled will be set on colors.bar[colorKey].enabled)
						local enabledFlagMappings = {
							-- Priest Discipline/Holy
							surgeOfLightBorderChange1 = "surgeOfLight",
							shadowCovenantBorderChange = "shadowCovenant",
							-- Priest Holy
							holyWordChastiseEnabled = "holyWordChastise",
							holyWordSanctifyEnabled = "holyWordSanctify",
							holyWordSerenityEnabled = "holyWordSerenity",
							resonantWordsBorderChange = "resonantWords",
							lightweaverBorderChange = "lightweaver",
							-- Priest Shadow
							mindFlayInsanityBorderChange = "borderMindFlayInsanity",
						}
						
						for oldFlag, colorKey in pairs(enabledFlagMappings) do
							if bar[oldFlag] ~= nil then
								-- Ensure the color table exists
								bar[colorKey] = bar[colorKey] or {}
								if type(bar[colorKey]) == "table" then
									bar[colorKey].enabled = bar[oldFlag]
								end
								bar[oldFlag] = nil
							end
						end
					end

					-- Migrate old flat *Enabled flags in comboPoints to nested .enabled format
					if specSettings.colors and specSettings.colors.comboPoints then
						local cp = specSettings.colors.comboPoints
						
						local cpEnabledFlagMappings = {
							-- Priest Discipline
							powerWordRadianceEnabled = "powerWordRadiance",
							-- Priest Holy
							holyWordSerenityEnabled = "holyWordSerenity",
							holyWordSanctifyEnabled = "holyWordSanctify",
							holyWordChastiseEnabled = "holyWordChastise",
							completeCooldownEnabled = "completeCooldown",
						}
						
						for oldFlag, colorKey in pairs(cpEnabledFlagMappings) do
							if cp[oldFlag] ~= nil then
								-- Ensure the color table exists
								cp[colorKey] = cp[colorKey] or {}
								if type(cp[colorKey]) == "table" then
									cp[colorKey].enabled = cp[oldFlag]
								end
								cp[oldFlag] = nil
							end
						end
					end

					-- Migrate bar text entry colors from flat string format to table format
					if specSettings.displayText and specSettings.displayText.barText then
						for _, barTextEntry in ipairs(specSettings.displayText.barText) do
							if barTextEntry.color ~= nil and type(barTextEntry.color) == "string" then
								-- Flat string color, convert to table
								barTextEntry.color = { color = barTextEntry.color }
							elseif barTextEntry.color == nil then
								-- No color field, create default
								barTextEntry.color = { color = "FFFFFFFF" }
							elseif type(barTextEntry.color) == "table" and barTextEntry.color.color == nil then
								-- Table exists but missing inner .color key, add default
								barTextEntry.color.color = "FFFFFFFF"
							end
						end
					end
				end
			end
		end
	end

	-- Migrate core displayText.default.color from flat string to table format
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and
	   TwintopInsanityBarSettings.core.displayText and TwintopInsanityBarSettings.core.displayText.default and
	   TwintopInsanityBarSettings.core.displayText.default.color and
	   type(TwintopInsanityBarSettings.core.displayText.default.color) == "string" then
		TwintopInsanityBarSettings.core.displayText.default.color = {
			color = TwintopInsanityBarSettings.core.displayText.default.color
		}
	end

	-- Priest Holy colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.holy ~= nil and
		TwintopInsanityBarSettings.priest.holy.colors ~= nil and
		TwintopInsanityBarSettings.priest.holy.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.priest.holy.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.apotheosis) == "string" then
			bar.apotheosis = { color = bar.apotheosis }
		end
		if type(bar.apotheosisEnd) == "string" then
			bar.apotheosisEnd = { color = bar.apotheosisEnd }
		end
		if type(bar.surgeOfLight) == "string" then
			local enabled = bar.surgeOfLightBorderChange1
			if enabled == nil then enabled = true end
			bar.surgeOfLight = { color = bar.surgeOfLight, enabled = enabled }
			bar.surgeOfLightBorderChange1 = nil
		end
		if type(bar.resonantWords) == "string" then
			local enabled = bar.resonantWordsBorderChange
			if enabled == nil then enabled = true end
			bar.resonantWords = { color = bar.resonantWords, enabled = enabled }
			bar.resonantWordsBorderChange = nil
		end
		if type(bar.lightweaver) == "string" then
			local enabled = bar.lightweaverBorderChange
			if enabled == nil then enabled = true end
			bar.lightweaver = { color = bar.lightweaver, enabled = enabled }
			bar.lightweaverBorderChange = nil
		end
		if type(bar.holyWordChastise) == "string" then
			local enabled = bar.holyWordChastiseEnabled
			if enabled == nil then enabled = false end
			bar.holyWordChastise = { color = bar.holyWordChastise, enabled = enabled }
			bar.holyWordChastiseEnabled = nil
		end
		if type(bar.holyWordSanctify) == "string" then
			local enabled = bar.holyWordSanctifyEnabled
			if enabled == nil then enabled = true end
			bar.holyWordSanctify = { color = bar.holyWordSanctify, enabled = enabled }
			bar.holyWordSanctifyEnabled = nil
		end
		if type(bar.holyWordSerenity) == "string" then
			local enabled = bar.holyWordSerenityEnabled
			if enabled == nil then enabled = true end
			bar.holyWordSerenity = { color = bar.holyWordSerenity, enabled = enabled }
			bar.holyWordSerenityEnabled = nil
		end
	end

	-- Priest Holy colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.holy ~= nil and
		TwintopInsanityBarSettings.priest.holy.colors ~= nil and
		TwintopInsanityBarSettings.priest.holy.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.priest.holy.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.holyWordSerenity) == "string" then
			local enabled = cp.holyWordSerenityEnabled
			if enabled == nil then enabled = true end
			cp.holyWordSerenity = { color = cp.holyWordSerenity, enabled = enabled }
			cp.holyWordSerenityEnabled = nil
		end
		if type(cp.holyWordSanctify) == "string" then
			local enabled = cp.holyWordSanctifyEnabled
			if enabled == nil then enabled = true end
			cp.holyWordSanctify = { color = cp.holyWordSanctify, enabled = enabled }
			cp.holyWordSanctifyEnabled = nil
		end
		if type(cp.holyWordChastise) == "string" then
			local enabled = cp.holyWordChastiseEnabled
			if enabled == nil then enabled = true end
			cp.holyWordChastise = { color = cp.holyWordChastise, enabled = enabled }
			cp.holyWordChastiseEnabled = nil
		end
		if type(cp.completeCooldown) == "string" then
			local enabled = cp.completeCooldownEnabled
			if enabled == nil then enabled = true end
			cp.completeCooldown = { color = cp.completeCooldown, enabled = enabled }
			cp.completeCooldownEnabled = nil
		end
	end

	-- Priest Discipline colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.discipline ~= nil and
		TwintopInsanityBarSettings.priest.discipline.colors ~= nil and
		TwintopInsanityBarSettings.priest.discipline.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.priest.discipline.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.surgeOfLight) == "string" then
			local enabled = bar.surgeOfLightBorderChange1
			if enabled == nil then enabled = true end
			bar.surgeOfLight = { color = bar.surgeOfLight, enabled = enabled }
			bar.surgeOfLightBorderChange1 = nil
		end
		if type(bar.shadowCovenant) == "string" then
			local enabled = bar.shadowCovenantBorderChange
			if enabled == nil then enabled = true end
			bar.shadowCovenant = { color = bar.shadowCovenant, enabled = enabled }
			bar.shadowCovenantBorderChange = nil
		end
	end

	-- Priest Discipline colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.discipline ~= nil and
		TwintopInsanityBarSettings.priest.discipline.colors ~= nil and
		TwintopInsanityBarSettings.priest.discipline.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.priest.discipline.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.powerWordRadiance) == "string" then
			local enabled = cp.powerWordRadianceEnabled
			if enabled == nil then enabled = true end
			cp.powerWordRadiance = { color = cp.powerWordRadiance, enabled = enabled }
			cp.powerWordRadianceEnabled = nil
		end
	end

	-- Priest Shadow colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
		TwintopInsanityBarSettings.priest.shadow.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.priest.shadow.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderMindFlayInsanity) == "string" then
			local enabled = bar.mindFlayInsanityBorderChange
			if enabled == nil then enabled = true end
			bar.borderMindFlayInsanity = { color = bar.borderMindFlayInsanity, enabled = enabled }
			bar.mindFlayInsanityBorderChange = nil
		end
		if type(bar.shadowWordMadnessUsable) == "string" then
			bar.shadowWordMadnessUsable = { color = bar.shadowWordMadnessUsable }
		end
		if type(bar.shadowWordMadnessUsableCasting) == "string" then
			bar.shadowWordMadnessUsableCasting = { color = bar.shadowWordMadnessUsableCasting }
		end
		if type(bar.critMindBlast) == "string" then
			local enabled = bar.critMindBlastEnabled
			if enabled == nil then enabled = true end
			bar.critMindBlast = { color = bar.critMindBlast, enabled = enabled }
			bar.critMindBlastEnabled = nil
		end
		if type(bar.instantMindBlast) == "string" then
			local enabled = bar.instantMindBlastEnabled
			if enabled == nil then enabled = true end
			bar.instantMindBlast = { color = bar.instantMindBlast, enabled = enabled }
			bar.instantMindBlastEnabled = nil
		end
		if type(bar.mindDevourer) == "string" then
			local enabled = bar.mindDevourerEnabled
			if enabled == nil then enabled = true end
			bar.mindDevourer = { color = bar.mindDevourer, enabled = enabled }
			bar.mindDevourerEnabled = nil
		end
		if type(bar.entropicRift) == "string" then
			local enabled = bar.entropicRiftEnabled
			if enabled == nil then enabled = true end
			bar.entropicRift = { color = bar.entropicRift, enabled = enabled }
			bar.entropicRiftEnabled = nil
		end
		if type(bar.inVoidform) == "string" then
			bar.inVoidform = { color = bar.inVoidform }
		end
		if type(bar.inVoidform1GCD) == "string" then
			bar.inVoidform1GCD = { color = bar.inVoidform1GCD }
		end
	end

	-- Druid Balance colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.balance ~= nil and
		TwintopInsanityBarSettings.druid.balance.colors ~= nil and
		TwintopInsanityBarSettings.druid.balance.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.druid.balance.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.lunar) == "string" then
			bar.lunar = { color = bar.lunar }
		end
		if type(bar.solar) == "string" then
			bar.solar = { color = bar.solar }
		end
		if type(bar.celestial) == "string" then
			bar.celestial = { color = bar.celestial }
		end
		if type(bar.eclipse1GCD) == "string" then
			bar.eclipse1GCD = { color = bar.eclipse1GCD }
		end
	end

	-- Druid Feral colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.feral ~= nil and
		TwintopInsanityBarSettings.druid.feral.colors ~= nil and
		TwintopInsanityBarSettings.druid.feral.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.druid.feral.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderStealth) == "string" then
			bar.borderStealth = { color = bar.borderStealth }
		end
		if type(bar.clearcasting) == "string" then
			bar.clearcasting = { color = bar.clearcasting }
		end
		if type(bar.maxBite) == "string" then
			bar.maxBite = { color = bar.maxBite }
		end
		if type(bar.apexPredator) == "string" then
			bar.apexPredator = { color = bar.apexPredator }
		end
	end

	-- Druid Feral colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.feral ~= nil and
		TwintopInsanityBarSettings.druid.feral.colors ~= nil and
		TwintopInsanityBarSettings.druid.feral.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.druid.feral.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Druid Guardian colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.guardian ~= nil and
		TwintopInsanityBarSettings.druid.guardian.colors ~= nil and
		TwintopInsanityBarSettings.druid.guardian.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.druid.guardian.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.berserk) == "string" then
			local enabled = bar.berserkEnabled
			if enabled == nil then enabled = true end
			bar.berserk = { color = bar.berserk, enabled = enabled }
			bar.berserkEnabled = nil
		end
		if type(bar.berserkEnd) == "string" then
			bar.berserkEnd = { color = bar.berserkEnd }
		end
	end

	-- Druid Restoration colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.restoration ~= nil and
		TwintopInsanityBarSettings.druid.restoration.colors ~= nil and
		TwintopInsanityBarSettings.druid.restoration.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.druid.restoration.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.noEfflorescence) == "string" then
			bar.noEfflorescence = { color = bar.noEfflorescence }
		end
		if type(bar.clearcasting) == "string" then
			bar.clearcasting = { color = bar.clearcasting }
		end
		if type(bar.incarnation) == "string" then
			bar.incarnation = { color = bar.incarnation }
		end
		if type(bar.incarnationEnd) == "string" then
			bar.incarnationEnd = { color = bar.incarnationEnd }
		end
	end

	-- Death Knight Blood colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.blood ~= nil and
		TwintopInsanityBarSettings.deathknight.blood.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.blood.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.deathknight.blood.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
	end

	-- Death Knight Blood colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.blood ~= nil and
		TwintopInsanityBarSettings.deathknight.blood.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.blood.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.deathknight.blood.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.cooldown) == "string" then
			cp.cooldown = { color = cp.cooldown }
		end
		if type(cp.overcap) == "string" then
			local enabled = cp.overcapEnabled
			if enabled == nil then enabled = false end
			cp.overcap = { color = cp.overcap, enabled = enabled }
			cp.overcapEnabled = nil
		end
	end

	-- Death Knight Frost colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.frost ~= nil and
		TwintopInsanityBarSettings.deathknight.frost.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.frost.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.deathknight.frost.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
	end

	-- Death Knight Frost colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.frost ~= nil and
		TwintopInsanityBarSettings.deathknight.frost.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.frost.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.deathknight.frost.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.cooldown) == "string" then
			cp.cooldown = { color = cp.cooldown }
		end
		if type(cp.overcap) == "string" then
			local enabled = cp.overcapEnabled
			if enabled == nil then enabled = false end
			cp.overcap = { color = cp.overcap, enabled = enabled }
			cp.overcapEnabled = nil
		end
	end

	-- Death Knight Unholy colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.deathknight.unholy.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
	end

	-- Death Knight Unholy colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.deathknight ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy.colors ~= nil and
		TwintopInsanityBarSettings.deathknight.unholy.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.deathknight.unholy.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.cooldown) == "string" then
			cp.cooldown = { color = cp.cooldown }
		end
		if type(cp.overcap) == "string" then
			local enabled = cp.overcapEnabled
			if enabled == nil then enabled = false end
			cp.overcap = { color = cp.overcap, enabled = enabled }
			cp.overcapEnabled = nil
		end
	end

	-- Demon Hunter Havoc colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.colors ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.demonhunter.havoc.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.metamorphosis) == "string" then
			bar.metamorphosis = { color = bar.metamorphosis }
		end
		if type(bar.metamorphosisEnding) == "string" then
			bar.metamorphosisEnding = { color = bar.metamorphosisEnding }
		end
	end

	-- Demon Hunter Vengeance colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.colors ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.metamorphosis) == "string" then
			bar.metamorphosis = { color = bar.metamorphosis }
		end
		if type(bar.metamorphosisEnding) == "string" then
			bar.metamorphosisEnding = { color = bar.metamorphosisEnding }
		end
	end

	-- Demon Hunter Vengeance colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.colors ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.demonhunter.vengeance.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Demon Hunter Devourer colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.colors ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.demonhunter.devourer.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.voidMetamorphosis) == "string" then
			local enabled = bar.voidMetamorphosisEnabled
			if enabled == nil then enabled = true end
			bar.voidMetamorphosis = { color = bar.voidMetamorphosis, enabled = enabled }
			bar.voidMetamorphosisEnabled = nil
		end
	end

	-- Demon Hunter Devourer colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.colors ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.demonhunter.devourer.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if type(cp.voidMetamorphosisReady) == "string" then
			local enabled = cp.voidMetamorphosisReadyEnabled
			if enabled == nil then enabled = true end
			cp.voidMetamorphosisReady = { color = cp.voidMetamorphosisReady, enabled = enabled }
			cp.voidMetamorphosisReadyEnabled = nil
		end
		if type(cp.collapsingStar) == "string" then
			cp.collapsingStar = { color = cp.collapsingStar }
		end
		if type(cp.collapsingStarReady) == "string" then
			local enabled = cp.collapsingStarReadyEnabled
			if enabled == nil then enabled = true end
			cp.collapsingStarReady = { color = cp.collapsingStarReady, enabled = enabled }
			cp.collapsingStarReadyEnabled = nil
		end
	end

	-- Evoker Devastation colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.devastation ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.evoker.devastation.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.dragonrage) == "string" then
			local enabled = bar.dragonrageEnabled
			if enabled == nil then enabled = true end
			bar.dragonrage = { color = bar.dragonrage, enabled = enabled }
			bar.dragonrageEnabled = nil
		end
		if type(bar.dragonrageEnd) == "string" then
			bar.dragonrageEnd = { color = bar.dragonrageEnd }
		end
		if type(bar.essenceBurst) == "string" then
			local enabled = bar.essenceBurstEnabled
			if enabled == nil then enabled = true end
			bar.essenceBurst = { color = bar.essenceBurst, enabled = enabled }
			bar.essenceBurstEnabled = nil
		end
	end

	-- Evoker Devastation colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.devastation ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.evoker.devastation.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Evoker Preservation colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.preservation ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.evoker.preservation.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.innervate) == "string" then
			bar.innervate = { color = bar.innervate }
		end
		if type(bar.essenceBurst) == "string" then
			local enabled = bar.essenceBurstEnabled
			if enabled == nil then enabled = true end
			bar.essenceBurst = { color = bar.essenceBurst, enabled = enabled }
			bar.essenceBurstEnabled = nil
		end
	end

	-- Evoker Preservation colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.preservation ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.evoker.preservation.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Evoker Augmentation colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.evoker.augmentation.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.inEbonMight) == "string" then
			local enabled = bar.inEbonMightEnabled
			if enabled == nil then enabled = true end
			bar.inEbonMight = { color = bar.inEbonMight, enabled = enabled }
			bar.inEbonMightEnabled = nil
		end
		if type(bar.inEbonMight1GCD) == "string" then
			local enabled = bar.inEbonMight1GCDEnabled
			if enabled == nil then enabled = true end
			bar.inEbonMight1GCD = { color = bar.inEbonMight1GCD, enabled = enabled }
			bar.inEbonMight1GCDEnabled = nil
		end
		if type(bar.ebonMightDropDuringCast) == "string" then
			local enabled = bar.ebonMightDropDuringCastEnabled
			if enabled == nil then enabled = true end
			bar.ebonMightDropDuringCast = { color = bar.ebonMightDropDuringCast, enabled = enabled }
			bar.ebonMightDropDuringCastEnabled = nil
		end
		if type(bar.essenceBurst) == "string" then
			local enabled = bar.essenceBurstEnabled
			if enabled == nil then enabled = true end
			bar.essenceBurst = { color = bar.essenceBurst, enabled = enabled }
			bar.essenceBurstEnabled = nil
		end
	end

	-- Evoker Augmentation colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.evoker.augmentation.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Hunter Beast Mastery colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery.colors ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.hunter.beastMastery.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.beastCleave) == "string" then
			local enabled = bar.beastCleaveEnabled
			if enabled == nil then enabled = true end
			bar.beastCleave = { color = bar.beastCleave, enabled = enabled }
			bar.beastCleaveEnabled = nil
		end
		if type(bar.bestialWrath) == "string" then
			local enabled = bar.bestialWrathEnabled
			if enabled == nil then enabled = true end
			bar.bestialWrath = { color = bar.bestialWrath, enabled = enabled }
			bar.bestialWrathEnabled = nil
		end
		if type(bar.bestialWrathEnd) == "string" then
			bar.bestialWrathEnd = { color = bar.bestialWrathEnd }
		end
	end

	-- Hunter Marksmanship colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.colors ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.hunter.marksmanship.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.trueshot) == "string" then
			bar.trueshot = { color = bar.trueshot }
		end
		if type(bar.trueshotEnding) == "string" then
			bar.trueshotEnding = { color = bar.trueshotEnding }
		end
	end

	-- Hunter Survival colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.survival ~= nil and
		TwintopInsanityBarSettings.hunter.survival.colors ~= nil and
		TwintopInsanityBarSettings.hunter.survival.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.hunter.survival.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.takedown) == "string" then
			local enabled = bar.takedownEnabled
			if enabled == nil then enabled = true end
			bar.takedown = { color = bar.takedown, enabled = enabled }
			bar.takedownEnabled = nil
		end
		if type(bar.takedownEnd) == "string" then
			bar.takedownEnd = { color = bar.takedownEnd }
		end
	end

	-- Mage Arcane colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.mage ~= nil and
		TwintopInsanityBarSettings.mage.arcane ~= nil and
		TwintopInsanityBarSettings.mage.arcane.colors ~= nil and
		TwintopInsanityBarSettings.mage.arcane.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.mage.arcane.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Mage Arcane colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.mage ~= nil and
		TwintopInsanityBarSettings.mage.arcane ~= nil and
		TwintopInsanityBarSettings.mage.arcane.colors ~= nil and
		TwintopInsanityBarSettings.mage.arcane.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.mage.arcane.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Mage Fire colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.mage ~= nil and
		TwintopInsanityBarSettings.mage.fire ~= nil and
		TwintopInsanityBarSettings.mage.fire.colors ~= nil and
		TwintopInsanityBarSettings.mage.fire.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.mage.fire.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Mage Frost colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.mage ~= nil and
		TwintopInsanityBarSettings.mage.frost ~= nil and
		TwintopInsanityBarSettings.mage.frost.colors ~= nil and
		TwintopInsanityBarSettings.mage.frost.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.mage.frost.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Monk Brewmaster colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.monk ~= nil and
		TwintopInsanityBarSettings.monk.brewmaster ~= nil and
		TwintopInsanityBarSettings.monk.brewmaster.colors ~= nil and
		TwintopInsanityBarSettings.monk.brewmaster.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.monk.brewmaster.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.invokeNiuzao) == "string" then
			local enabled = bar.invokeNiuzaoEnabled
			if enabled == nil then enabled = true end
			bar.invokeNiuzao = { color = bar.invokeNiuzao, enabled = enabled }
			bar.invokeNiuzaoEnabled = nil
		end
		if type(bar.invokeNiuzaoEnd) == "string" then
			bar.invokeNiuzaoEnd = { color = bar.invokeNiuzaoEnd }
		end
	end

	-- Monk Mistweaver colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.monk ~= nil and
		TwintopInsanityBarSettings.monk.mistweaver ~= nil and
		TwintopInsanityBarSettings.monk.mistweaver.colors ~= nil and
		TwintopInsanityBarSettings.monk.mistweaver.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.monk.mistweaver.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.vivaciousVivification) == "string" then
			local enabled = bar.vivaciousVivificationEnabled
			if enabled == nil then enabled = true end
			bar.vivaciousVivification = { color = bar.vivaciousVivification, enabled = enabled }
			bar.vivaciousVivificationEnabled = nil
		end
		if type(bar.heartOfTheJadeSerpentReady) == "string" then
			local enabled = bar.heartOfTheJadeSerpentReadyEnabled
			if enabled == nil then enabled = true end
			bar.heartOfTheJadeSerpentReady = { color = bar.heartOfTheJadeSerpentReady, enabled = enabled }
			bar.heartOfTheJadeSerpentReadyEnabled = nil
		end
		if type(bar.heartOfTheJadeSerpent) == "string" then
			local enabled = bar.heartOfTheJadeSerpentEnabled
			if enabled == nil then enabled = true end
			bar.heartOfTheJadeSerpent = { color = bar.heartOfTheJadeSerpent, enabled = enabled }
			bar.heartOfTheJadeSerpentEnabled = nil
		end
	end

	-- Monk Windwalker colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.monk ~= nil and
		TwintopInsanityBarSettings.monk.windwalker ~= nil and
		TwintopInsanityBarSettings.monk.windwalker.colors ~= nil and
		TwintopInsanityBarSettings.monk.windwalker.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.monk.windwalker.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderChiJi) == "string" then
			bar.borderChiJi = { color = bar.borderChiJi }
		end
		if type(bar.heartOfTheJadeSerpentReady) == "string" then
			local enabled = bar.heartOfTheJadeSerpentReadyEnabled
			if enabled == nil then enabled = true end
			bar.heartOfTheJadeSerpentReady = { color = bar.heartOfTheJadeSerpentReady, enabled = enabled }
			bar.heartOfTheJadeSerpentReadyEnabled = nil
		end
		if type(bar.heartOfTheJadeSerpent) == "string" then
			local enabled = bar.heartOfTheJadeSerpentEnabled
			if enabled == nil then enabled = true end
			bar.heartOfTheJadeSerpent = { color = bar.heartOfTheJadeSerpent, enabled = enabled }
			bar.heartOfTheJadeSerpentEnabled = nil
		end
	end

	-- Monk Windwalker colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.monk ~= nil and
		TwintopInsanityBarSettings.monk.windwalker ~= nil and
		TwintopInsanityBarSettings.monk.windwalker.colors ~= nil and
		TwintopInsanityBarSettings.monk.windwalker.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.monk.windwalker.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Paladin Holy colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.holy ~= nil and
		TwintopInsanityBarSettings.paladin.holy.colors ~= nil and
		TwintopInsanityBarSettings.paladin.holy.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.paladin.holy.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.infusionOfLight) == "string" then
			local enabled = bar.infusionOfLightEnabled
			if enabled == nil then enabled = true end
			bar.infusionOfLight = { color = bar.infusionOfLight, enabled = enabled }
			bar.infusionOfLightEnabled = nil
		end
	end

	-- Paladin Holy colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.holy ~= nil and
		TwintopInsanityBarSettings.paladin.holy.colors ~= nil and
		TwintopInsanityBarSettings.paladin.holy.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.paladin.holy.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FFFCE58E" }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FFFFC800" }
		end
	end

	-- Paladin Protection colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.protection ~= nil and
		TwintopInsanityBarSettings.paladin.protection.colors ~= nil and
		TwintopInsanityBarSettings.paladin.protection.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.paladin.protection.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Paladin Protection colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.protection ~= nil and
		TwintopInsanityBarSettings.paladin.protection.colors ~= nil and
		TwintopInsanityBarSettings.paladin.protection.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.paladin.protection.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FFFCE58E" }
		end
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FFFCE58E" }
		end
	end

	-- Paladin Retribution colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.retribution ~= nil and
		TwintopInsanityBarSettings.paladin.retribution.colors ~= nil and
		TwintopInsanityBarSettings.paladin.retribution.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.paladin.retribution.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Paladin Retribution colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.paladin ~= nil and
		TwintopInsanityBarSettings.paladin.retribution ~= nil and
		TwintopInsanityBarSettings.paladin.retribution.colors ~= nil and
		TwintopInsanityBarSettings.paladin.retribution.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.paladin.retribution.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FFFCE58E" }
		end
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FFFCE58E" }
		end
	end

	-- Rogue Assassination colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.assassination ~= nil and
		TwintopInsanityBarSettings.rogue.assassination.colors ~= nil and
		TwintopInsanityBarSettings.rogue.assassination.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.rogue.assassination.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderStealth) == "string" then
			bar.borderStealth = { color = bar.borderStealth }
		end
	end

	-- Rogue Assassination colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.assassination ~= nil and
		TwintopInsanityBarSettings.rogue.assassination.colors ~= nil and
		TwintopInsanityBarSettings.rogue.assassination.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.rogue.assassination.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if type(cp.echoingReprimand) == "string" then
			cp.echoingReprimand = { color = cp.echoingReprimand }
		end
	end

	-- Rogue Outlaw colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.colors ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.rogue.outlaw.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderStealth) == "string" then
			bar.borderStealth = { color = bar.borderStealth }
		end
		if type(bar.borderRtbBad) == "string" then
			bar.borderRtbBad = { color = bar.borderRtbBad }
		end
		if type(bar.borderRtbGood) == "string" then
			bar.borderRtbGood = { color = bar.borderRtbGood }
		end
	end

	-- Rogue Outlaw colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.colors ~= nil and
		TwintopInsanityBarSettings.rogue.outlaw.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.rogue.outlaw.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if type(cp.echoingReprimand) == "string" then
			cp.echoingReprimand = { color = cp.echoingReprimand }
		end
	end

	-- Rogue Subtlety colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.colors ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.rogue.subtlety.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.borderStealth) == "string" then
			bar.borderStealth = { color = bar.borderStealth }
		end
		if type(bar.borderShadowcraft) == "string" then
			bar.borderShadowcraft = { color = bar.borderShadowcraft }
		end
	end

	-- Rogue Subtlety colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.colors ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.rogue.subtlety.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
		if type(cp.echoingReprimand) == "string" then
			cp.echoingReprimand = { color = cp.echoingReprimand }
		end
		if type(cp.shadowTechniques) == "string" then
			cp.shadowTechniques = { color = cp.shadowTechniques }
		end
	end

	-- Shaman Elemental colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.elemental ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.colors ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.shaman.elemental.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.earthShock) == "string" then
			bar.earthShock = { color = bar.earthShock }
		end
		if type(bar.inAscendance) == "string" then
			bar.inAscendance = { color = bar.inAscendance }
		end
		if type(bar.inAscendance1GCD) == "string" then
			bar.inAscendance1GCD = { color = bar.inAscendance1GCD }
		end
	end

	-- Shaman Enhancement colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.colors ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.shaman.enhancement.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.inAscendance) == "string" then
			bar.inAscendance = { color = bar.inAscendance }
		end
		if type(bar.inAscendance1GCD) == "string" then
			bar.inAscendance1GCD = { color = bar.inAscendance1GCD }
		end
	end

	-- Shaman Enhancement colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.colors ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.shaman.enhancement.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.overflowBase) == "string" then
			cp.overflowBase = { color = cp.overflowBase }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Shaman Restoration colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.restoration ~= nil and
		TwintopInsanityBarSettings.shaman.restoration.colors ~= nil and
		TwintopInsanityBarSettings.shaman.restoration.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.shaman.restoration.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.inAscendance) == "string" then
			bar.inAscendance = { color = bar.inAscendance }
		end
		if type(bar.inAscendance1GCD) == "string" then
			bar.inAscendance1GCD = { color = bar.inAscendance1GCD }
		end
	end

	-- Warlock Affliction colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.affliction ~= nil and
		TwintopInsanityBarSettings.warlock.affliction.colors ~= nil and
		TwintopInsanityBarSettings.warlock.affliction.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warlock.affliction.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Warlock Affliction colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.affliction ~= nil and
		TwintopInsanityBarSettings.warlock.affliction.colors ~= nil and
		TwintopInsanityBarSettings.warlock.affliction.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.warlock.affliction.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Warlock Demonology colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.demonology ~= nil and
		TwintopInsanityBarSettings.warlock.demonology.colors ~= nil and
		TwintopInsanityBarSettings.warlock.demonology.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warlock.demonology.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Warlock Demonology colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.demonology ~= nil and
		TwintopInsanityBarSettings.warlock.demonology.colors ~= nil and
		TwintopInsanityBarSettings.warlock.demonology.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.warlock.demonology.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Warlock Destruction colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.destruction ~= nil and
		TwintopInsanityBarSettings.warlock.destruction.colors ~= nil and
		TwintopInsanityBarSettings.warlock.destruction.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warlock.destruction.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
	end

	-- Warlock Destruction colors.comboPoints migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warlock ~= nil and
		TwintopInsanityBarSettings.warlock.destruction ~= nil and
		TwintopInsanityBarSettings.warlock.destruction.colors ~= nil and
		TwintopInsanityBarSettings.warlock.destruction.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.warlock.destruction.colors.comboPoints
		if type(cp.base) == "string" then
			cp.base = { color = cp.base }
		end
		if type(cp.border) == "string" then
			cp.border = { color = cp.border }
		end
		if type(cp.background) == "string" then
			cp.background = { color = cp.background }
		end
		if type(cp.penultimate) == "string" then
			cp.penultimate = { color = cp.penultimate }
		end
		if type(cp.final) == "string" then
			cp.final = { color = cp.final }
		end
	end

	-- Warrior Arms colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.arms ~= nil and
		TwintopInsanityBarSettings.warrior.arms.colors ~= nil and
		TwintopInsanityBarSettings.warrior.arms.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warrior.arms.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
	end

	-- Warrior Fury colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warrior.fury.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
		if type(bar.enrage) == "string" then
			bar.enrage = { color = bar.enrage }
		end
	end

	-- Warrior Fury comboPoints migration: split base into base (1 stack) and secondary (2 stacks), add zeroStackBackground
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.warrior.fury.colors.comboPoints
		if cp.secondary == nil and cp.base ~= nil then
			cp.secondary = { color = cp.base.color }
		end
		if cp.zeroStackBackground == nil then
			cp.zeroStackBackground = { color = "66333333", enabled = false }
		end
	end

	-- Warrior Protection colors.bar migration from flat string to table format
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.protection ~= nil and
		TwintopInsanityBarSettings.warrior.protection.colors ~= nil and
		TwintopInsanityBarSettings.warrior.protection.colors.bar ~= nil then
		local bar = TwintopInsanityBarSettings.warrior.protection.colors.bar
		if type(bar.base) == "string" then
			bar.base = { color = bar.base }
		end
		if type(bar.border) == "string" then
			bar.border = { color = bar.border }
		end
		if type(bar.background) == "string" then
			bar.background = { color = bar.background }
		end
		if type(bar.borderOvercap) == "string" then
			local enabled = bar.overcapEnabled or bar.borderOvercapEnabled
			if enabled == nil then enabled = true end
			bar.borderOvercap = { color = bar.borderOvercap, enabled = enabled }
			bar.overcapEnabled = nil
			bar.borderOvercapEnabled = nil
		end
	end

	-- Port forward endOfMetamorphosis to endOf.metamorphosis for Demon Hunter Havoc
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.endOf == nil then

		TwintopInsanityBarSettings.demonhunter.havoc.endOf = {
			metamorphosis = TwintopInsanityBarSettings.demonhunter.havoc.endOfMetamorphosis
		}
		TwintopInsanityBarSettings.demonhunter.havoc.endOfMetamorphosis = nil

		-- Migrate color key: metamorphosisEnding -> metamorphosisEnd
		if TwintopInsanityBarSettings.demonhunter.havoc.colors and
			TwintopInsanityBarSettings.demonhunter.havoc.colors.bar and
			TwintopInsanityBarSettings.demonhunter.havoc.colors.bar.metamorphosisEnding ~= nil then
			TwintopInsanityBarSettings.demonhunter.havoc.colors.bar.metamorphosisEnd =
				TwintopInsanityBarSettings.demonhunter.havoc.colors.bar.metamorphosisEnding
			TwintopInsanityBarSettings.demonhunter.havoc.colors.bar.metamorphosisEnding = nil
		end
	end

	-- Port forward endOfMetamorphosis to endOf.metamorphosis for Demon Hunter Vengeance
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.endOf == nil then

		TwintopInsanityBarSettings.demonhunter.vengeance.endOf = {
			metamorphosis = TwintopInsanityBarSettings.demonhunter.vengeance.endOfMetamorphosis
		}
		TwintopInsanityBarSettings.demonhunter.vengeance.endOfMetamorphosis = nil

		-- Migrate color key: metamorphosisEnding -> metamorphosisEnd
		if TwintopInsanityBarSettings.demonhunter.vengeance.colors and
			TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar and
			TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar.metamorphosisEnding ~= nil then
			TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar.metamorphosisEnd =
				TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar.metamorphosisEnding
			TwintopInsanityBarSettings.demonhunter.vengeance.colors.bar.metamorphosisEnding = nil
		end
	end

	-- Cleanup: Remove orphaned endOfMetamorphosis if endOf already exists (Havoc)
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.endOf ~= nil then
		TwintopInsanityBarSettings.demonhunter.havoc.endOfMetamorphosis = nil
	end

	-- Cleanup: Remove orphaned endOfMetamorphosis if endOf already exists (Vengeance)
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.vengeance.endOf ~= nil then
		TwintopInsanityBarSettings.demonhunter.vengeance.endOfMetamorphosis = nil
	end

	-- Port forward endOfMetamorphosis to endOf.metamorphosis for Demon Hunter Devourer
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.endOf == nil then

		TwintopInsanityBarSettings.demonhunter.devourer.endOf = {
			metamorphosis = TwintopInsanityBarSettings.demonhunter.devourer.endOfMetamorphosis
		}
		TwintopInsanityBarSettings.demonhunter.devourer.endOfMetamorphosis = nil
	end

	-- Cleanup: Remove orphaned endOfMetamorphosis if endOf already exists (Devourer)
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.endOfMetamorphosis ~= nil and
		TwintopInsanityBarSettings.demonhunter.devourer.endOf ~= nil then
		TwintopInsanityBarSettings.demonhunter.devourer.endOfMetamorphosis = nil
	end

	-- Port forward endOfBestialWrath to endOf.bestialWrath for Hunter Beast Mastery
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery.endOfBestialWrath ~= nil and
		TwintopInsanityBarSettings.hunter.beastMastery.endOf == nil then

		TwintopInsanityBarSettings.hunter.beastMastery.endOf = {
			bestialWrath = TwintopInsanityBarSettings.hunter.beastMastery.endOfBestialWrath
		}
		TwintopInsanityBarSettings.hunter.beastMastery.endOfBestialWrath = nil
		-- Note: bestialWrathEnd already uses correct naming convention
	end

	-- Port forward endOfTrueshot to endOf.trueshot for Hunter Marksmanship
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.endOfTrueshot ~= nil and
		TwintopInsanityBarSettings.hunter.marksmanship.endOf == nil then

		TwintopInsanityBarSettings.hunter.marksmanship.endOf = {
			trueshot = TwintopInsanityBarSettings.hunter.marksmanship.endOfTrueshot
		}
		TwintopInsanityBarSettings.hunter.marksmanship.endOfTrueshot = nil

		-- Migrate color key: trueshotEnding -> trueshotEnd
		if TwintopInsanityBarSettings.hunter.marksmanship.colors and
			TwintopInsanityBarSettings.hunter.marksmanship.colors.bar and
			TwintopInsanityBarSettings.hunter.marksmanship.colors.bar.trueshotEnding ~= nil then
			TwintopInsanityBarSettings.hunter.marksmanship.colors.bar.trueshotEnd =
				TwintopInsanityBarSettings.hunter.marksmanship.colors.bar.trueshotEnding
			TwintopInsanityBarSettings.hunter.marksmanship.colors.bar.trueshotEnding = nil
		end
	end

	-- Port forward endOfTakedown to endOf.takedown for Hunter Survival
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.hunter ~= nil and
		TwintopInsanityBarSettings.hunter.survival ~= nil and
		TwintopInsanityBarSettings.hunter.survival.endOfTakedown ~= nil and
		TwintopInsanityBarSettings.hunter.survival.endOf == nil then

		TwintopInsanityBarSettings.hunter.survival.endOf = {
			takedown = TwintopInsanityBarSettings.hunter.survival.endOfTakedown
		}
		TwintopInsanityBarSettings.hunter.survival.endOfTakedown = nil
		-- Note: takedownEnd already uses correct naming convention
	end

	-- Port forward endOfAscendance to endOf.ascendance for Shaman Elemental
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.elemental ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.endOfAscendance ~= nil and
		TwintopInsanityBarSettings.shaman.elemental.endOf == nil then

		TwintopInsanityBarSettings.shaman.elemental.endOf = {
			ascendance = TwintopInsanityBarSettings.shaman.elemental.endOfAscendance
		}
		TwintopInsanityBarSettings.shaman.elemental.endOfAscendance = nil

		-- Migrate color keys: inAscendance -> ascendance, inAscendance1GCD -> ascendanceEnd
		if TwintopInsanityBarSettings.shaman.elemental.colors and
			TwintopInsanityBarSettings.shaman.elemental.colors.bar then
			local bar = TwintopInsanityBarSettings.shaman.elemental.colors.bar
			if bar.inAscendance ~= nil then
				bar.ascendance = bar.inAscendance
				bar.inAscendance = nil
			end
			if bar.inAscendance1GCD ~= nil then
				bar.ascendanceEnd = bar.inAscendance1GCD
				bar.inAscendance1GCD = nil
			end
		end
	end

	-- Port forward endOfAscendance to endOf.ascendance for Shaman Enhancement
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.endOfAscendance ~= nil and
		TwintopInsanityBarSettings.shaman.enhancement.endOf == nil then

		TwintopInsanityBarSettings.shaman.enhancement.endOf = {
			ascendance = TwintopInsanityBarSettings.shaman.enhancement.endOfAscendance
		}
		TwintopInsanityBarSettings.shaman.enhancement.endOfAscendance = nil

		-- Migrate color keys: inAscendance -> ascendance, inAscendance1GCD -> ascendanceEnd
		if TwintopInsanityBarSettings.shaman.enhancement.colors and
			TwintopInsanityBarSettings.shaman.enhancement.colors.bar then
			local bar = TwintopInsanityBarSettings.shaman.enhancement.colors.bar
			if bar.inAscendance ~= nil then
				bar.ascendance = bar.inAscendance
				bar.inAscendance = nil
			end
			if bar.inAscendance1GCD ~= nil then
				bar.ascendanceEnd = bar.inAscendance1GCD
				bar.inAscendance1GCD = nil
			end
		end
	end

	-- Port forward endOfAscendance to endOf.ascendance for Shaman Restoration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.shaman ~= nil and
		TwintopInsanityBarSettings.shaman.restoration ~= nil and
		TwintopInsanityBarSettings.shaman.restoration.endOfAscendance ~= nil and
		TwintopInsanityBarSettings.shaman.restoration.endOf == nil then

		TwintopInsanityBarSettings.shaman.restoration.endOf = {
			ascendance = TwintopInsanityBarSettings.shaman.restoration.endOfAscendance
		}
		TwintopInsanityBarSettings.shaman.restoration.endOfAscendance = nil

		-- Migrate color keys: inAscendance -> ascendance, inAscendance1GCD -> ascendanceEnd
		if TwintopInsanityBarSettings.shaman.restoration.colors and
			TwintopInsanityBarSettings.shaman.restoration.colors.bar then
			local bar = TwintopInsanityBarSettings.shaman.restoration.colors.bar
			if bar.inAscendance ~= nil then
				bar.ascendance = bar.inAscendance
				bar.inAscendance = nil
			end
			if bar.inAscendance1GCD ~= nil then
				bar.ascendanceEnd = bar.inAscendance1GCD
				bar.inAscendance1GCD = nil
			end
		end
	end

	-- Port forward endOfApotheosis to endOf.apotheosis for Priest Holy
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.holy ~= nil and
		TwintopInsanityBarSettings.priest.holy.endOfApotheosis ~= nil and
		TwintopInsanityBarSettings.priest.holy.endOf == nil then

		TwintopInsanityBarSettings.priest.holy.endOf = {
			apotheosis = TwintopInsanityBarSettings.priest.holy.endOfApotheosis
		}
		TwintopInsanityBarSettings.priest.holy.endOfApotheosis = nil
		-- Note: apotheosisEnd already uses correct naming convention
	end

	-- Cleanup: Remove orphaned endOfApotheosis if endOf already exists
	-- This handles the case where both old and new keys exist from prior faulty migration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.holy ~= nil and
		TwintopInsanityBarSettings.priest.holy.endOfApotheosis ~= nil and
		TwintopInsanityBarSettings.priest.holy.endOf ~= nil then
		TwintopInsanityBarSettings.priest.holy.endOfApotheosis = nil
	end

	-- Port forward endOfVoidform to endOf.voidform for Priest Shadow
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.shadow ~= nil and
		TwintopInsanityBarSettings.priest.shadow.endOfVoidform ~= nil and
		TwintopInsanityBarSettings.priest.shadow.endOf == nil then

		TwintopInsanityBarSettings.priest.shadow.endOf = {
			voidform = TwintopInsanityBarSettings.priest.shadow.endOfVoidform
		}
		TwintopInsanityBarSettings.priest.shadow.endOfVoidform = nil

		-- Migrate color keys: inVoidform -> voidform, inVoidform1GCD -> voidformEnd
		if TwintopInsanityBarSettings.priest.shadow.colors and
			TwintopInsanityBarSettings.priest.shadow.colors.bar then
			local bar = TwintopInsanityBarSettings.priest.shadow.colors.bar
			if bar.inVoidform ~= nil then
				bar.voidform = bar.inVoidform
				bar.inVoidform = nil
			end
			if bar.inVoidform1GCD ~= nil then
				bar.voidformEnd = bar.inVoidform1GCD
				bar.inVoidform1GCD = nil
			end
		end
	end

	-- Port forward endOfEclipse to endOf.eclipse for Druid Balance
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.balance ~= nil and
		TwintopInsanityBarSettings.druid.balance.endOfEclipse ~= nil and
		TwintopInsanityBarSettings.druid.balance.endOf == nil then

		-- Preserve celestialAlignmentOnly inside the new structure
		TwintopInsanityBarSettings.druid.balance.endOf = {
			eclipse = TwintopInsanityBarSettings.druid.balance.endOfEclipse
		}
		TwintopInsanityBarSettings.druid.balance.endOfEclipse = nil

		-- Migrate color key: eclipse1GCD -> eclipseEnd
		if TwintopInsanityBarSettings.druid.balance.colors and
			TwintopInsanityBarSettings.druid.balance.colors.bar and
			TwintopInsanityBarSettings.druid.balance.colors.bar.eclipse1GCD ~= nil then
			TwintopInsanityBarSettings.druid.balance.colors.bar.eclipseEnd =
				TwintopInsanityBarSettings.druid.balance.colors.bar.eclipse1GCD
			TwintopInsanityBarSettings.druid.balance.colors.bar.eclipse1GCD = nil
		end
	end

	-- Port forward endOfBerserk to endOf.berserk for Druid Guardian
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.guardian ~= nil and
		TwintopInsanityBarSettings.druid.guardian.endOfBerserk ~= nil and
		TwintopInsanityBarSettings.druid.guardian.endOf == nil then

		TwintopInsanityBarSettings.druid.guardian.endOf = {
			berserk = TwintopInsanityBarSettings.druid.guardian.endOfBerserk
		}
		TwintopInsanityBarSettings.druid.guardian.endOfBerserk = nil
		-- Note: berserkEnd already uses correct naming convention
	end

	-- Port forward endOfIncarnation to endOf.incarnation for Druid Restoration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.restoration ~= nil and
		TwintopInsanityBarSettings.druid.restoration.endOfIncarnation ~= nil and
		TwintopInsanityBarSettings.druid.restoration.endOf == nil then

		TwintopInsanityBarSettings.druid.restoration.endOf = {
			incarnation = TwintopInsanityBarSettings.druid.restoration.endOfIncarnation
		}
		TwintopInsanityBarSettings.druid.restoration.endOfIncarnation = nil
		-- Note: incarnationEnd already uses correct naming convention
	end

	-- Port forward endOfEbonMight to endOf.ebonMight for Evoker Augmentation
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.endOfEbonMight ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.endOf == nil then

		TwintopInsanityBarSettings.evoker.augmentation.endOf = {
			ebonMight = TwintopInsanityBarSettings.evoker.augmentation.endOfEbonMight
		}
		TwintopInsanityBarSettings.evoker.augmentation.endOfEbonMight = nil

		-- Migrate color keys: inEbonMight -> ebonMight, inEbonMight1GCD -> ebonMightEnd
		if TwintopInsanityBarSettings.evoker.augmentation.colors and
			TwintopInsanityBarSettings.evoker.augmentation.colors.bar then
			local bar = TwintopInsanityBarSettings.evoker.augmentation.colors.bar
			if bar.inEbonMight ~= nil then
				bar.ebonMight = bar.inEbonMight
				bar.inEbonMight = nil
			end
			if bar.inEbonMight1GCD ~= nil then
				bar.ebonMightEnd = bar.inEbonMight1GCD
				bar.inEbonMight1GCD = nil
			end
		end
	end

	-- Migrate displayBar values from string format to table format { visibility = string, smooth = bool }
	-- Also migrate core.displayBar the same way
	-- Then seed smooth defaults from the old core.smoothBarValueUpdates global setting
	do
		local oldSmoothSetting = nil
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core then
			oldSmoothSetting = TwintopInsanityBarSettings.core.smoothBarValueUpdates
		end

		-- Keys within displayBar that should be converted from string to table
		local displayBarVisibilityKeys = { "primary", "secondary", "health", "mana", "stagger", "defensives", "utility" }

		-- Determine if the secondary bar should default to smooth for a given class/spec
		-- Only DH Vengeance (specId 2) and Devourer (specId 3) have continuous secondary bars (Soul Fragments)
		local function IsSecondarySmoothByDefault(className, specName)
			if className == "demonhunter" and (specName == "vengeance" or specName == "devourer") then
				return true
			end
			return false
		end

		-- Determine the smooth default for a given displayBar key
		local function GetSmoothDefault(key, className, specName, oldSmooth)
			local baseSmooth = (oldSmooth ~= nil) and oldSmooth or true
			if key == "primary" or key == "health" or key == "mana" or key == "stagger" or key == "defensives" or key == "utility" then
				return baseSmooth
			elseif key == "secondary" then
				if IsSecondarySmoothByDefault(className, specName) then
					return baseSmooth
				end
				return false
			end
			return false
		end

		local function MigrateDisplayBarToTable(displayBar, className, specName)
			if displayBar == nil then
				return
			end
			for _, key in ipairs(displayBarVisibilityKeys) do
				local val = displayBar[key]
				if val ~= nil and type(val) == "string" then
					-- Convert string value to table format
					displayBar[key] = {
						visibility = val,
						smooth = GetSmoothDefault(key, className, specName, oldSmoothSetting)
					}
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateDisplayBarToTable(TwintopInsanityBarSettings.core.displayBar, "core", "core")

			-- Seed utility visibility if missing in existing profiles.
			if TwintopInsanityBarSettings.core.displayBar.utility == nil then
				TwintopInsanityBarSettings.core.displayBar.utility = {
					visibility = "never",
					smooth = true
				}
			end
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateDisplayBarToTable(specSettings.displayBar, className, specName)
					end
				end
			end
		end

		-- NOTE: Do NOT remove smoothBarValueUpdates here. It's still needed as a guard for an older
		-- migration (line ~1365) that resets core.bar/core.comboPoints. Without the guard, that
		-- migration would run on every reload and reset the user's bar dimension settings.
	end

	-- Migrate displayBar entries from legacy { visibility = "...", smooth = X } to
	-- new conditions-based format { neverShow = bool, conditions = {}, smooth = X }.
	-- Also strip the deprecated "dragonriding" key from displayBar.
	do
		local function MigrateVisibilityToConditions(displayBar)
			if displayBar == nil then
				return
			end
			-- Strip deprecated dragonriding key
			displayBar.dragonriding = nil

			for key, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.visibility ~= nil and entry.conditions == nil then
					local vis = entry.visibility
					if vis == "never" then
						entry.neverShow = true
						entry.conditions = {}
					elseif vis == "combat" then
						entry.neverShow = false
						entry.conditions = {
							inCombat = true,
							inVehicle = true,
						}
					else
						-- "always" or any unknown value
						entry.neverShow = false
						entry.conditions = {}
					end
					entry.visibility = nil
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateVisibilityToConditions(TwintopInsanityBarSettings.core.displayBar)
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateVisibilityToConditions(specSettings.displayBar)
					end
				end
			end
		end
	end

	-- Migrate Phase 1 conditions-based entries (have conditions but no alwaysShow) to Phase 2.
	-- Phase 1 used empty conditions = {} for "always show". Phase 2 uses explicit alwaysShow flag.
	-- Conditions are left untouched — alwaysShow is a standalone override independent of conditions.
	do
		local function MigrateAlwaysShow(displayBar)
			if displayBar == nil then
				return
			end
			for _, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.conditions ~= nil and entry.alwaysShow == nil then
					-- Check if conditions table is empty (Phase 1 "always")
					local hasAny = false
					for _, v in pairs(entry.conditions) do
						if v == true then
							hasAny = true
							break
						end
					end
					if not hasAny and not entry.neverShow then
						-- Empty conditions = was "always" → set alwaysShow
						entry.alwaysShow = true
					else
						entry.alwaysShow = false
					end
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateAlwaysShow(TwintopInsanityBarSettings.core.displayBar)
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateAlwaysShow(specSettings.displayBar)
					end
				end
			end
		end
	end

	-- Phase 2: Rename isMounted → isMountedAny and backfill new condition keys.
	-- Existing users who had isMounted enabled should get isMountedAny instead.
	-- New Phase 2 conditions default to false (unchecked).
	do
		local phase2NewKeys = { "isMountedGround", "isSkyriding", "isSteadyFlight", "inGroup", "inRaid", "inInstance", "inDungeon", "inRaidInstance", "inBattleground", "inArena", "inDelve", "isPvpFlagged", "isWarMode" }

		local function MigrateRenamedConditions(displayBar)
			if displayBar == nil then
				return
			end
			for _, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.conditions ~= nil then
					-- Rename isMounted → isMountedAny
					if entry.conditions.isMounted ~= nil then
						entry.conditions.isMountedAny = entry.conditions.isMounted
						entry.conditions.isMounted = nil
					end

					-- Backfill new Phase 2 keys: default to false (unchecked)
					for _, key in ipairs(phase2NewKeys) do
						if entry.conditions[key] == nil then
							entry.conditions[key] = false
						end
					end
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateRenamedConditions(TwintopInsanityBarSettings.core.displayBar)
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateRenamedConditions(specSettings.displayBar)
					end
				end
			end
		end
	end

	-- Phase 3a: Backfill activeAlpha, inactiveAlpha, and fadeDuration for existing settings.
	-- Existing users get matching-current-behavior defaults: active=100%, inactive=0%, fade=0s (instant).
	do
		local function MigrateAlphaSettings(displayBar)
			if displayBar == nil then
				return
			end
			for _, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.conditions ~= nil then
					if entry.activeAlpha == nil then
						entry.activeAlpha = 100
					end
					if entry.inactiveAlpha == nil then
						entry.inactiveAlpha = 0
					end
					if entry.fadeDuration == nil then
						entry.fadeDuration = 0
					end
					if entry.fadeDelay == nil then
						entry.fadeDelay = 0
					end
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateAlphaSettings(TwintopInsanityBarSettings.core.displayBar)
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateAlphaSettings(specSettings.displayBar)
					end
				end
			end
		end
	end

	-- Migrate bar anchor settings from legacy relativeTo/xPos/yPos/fullWidth to new anchor block system.
	-- Populate anchor blocks alongside legacy fields. Legacy fields are kept for backward compatibility.
	do
		local anchorMap = TRB.Data.constants.relativeToAnchorMap

		--- Populates an anchor block on a bar settings table if it has legacy relativeTo but no anchor.
		---@param barSettings table? # A bar dimensions table (e.g., specSettings.comboPoints, specSettings.healthBar)
		local function MigrateBarAnchor(barSettings)
			if barSettings == nil then
				return
			end
			-- Skip if already migrated
			if barSettings.anchor ~= nil then
				return
			end
			-- Migrate from legacy relativeTo → anchor block
			if barSettings.relativeTo then
				local mapping = anchorMap[barSettings.relativeTo]
				if mapping then
					barSettings.anchor = {
						barKey = "primary",
						anchorPoint = mapping.anchorPoint,
						attachPoint = mapping.attachPoint,
						xOffset = barSettings.xPos or 0,
						yOffset = barSettings.yPos or 0,
						matchWidth = barSettings.fullWidth or false,
					}
				end
			elseif barSettings.xPos ~= nil and barSettings.yPos ~= nil and barSettings.relativeTo == nil then
				-- Primary bar (has xPos/yPos but no relativeTo) → screen anchor
				barSettings.anchor = {
					barKey = "screen",
					anchorPoint = "CENTER",
					attachPoint = "CENTER",
					xOffset = barSettings.xPos or 0,
					yOffset = barSettings.yPos or -200,
					matchWidth = false,
				}
			end
		end

		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if type(specSettings) == "table" then
						MigrateBarAnchor(specSettings.bar)

						-- Migrate secondary bar (combo points)
						MigrateBarAnchor(specSettings.comboPoints)

						-- Migrate health bar
						MigrateBarAnchor(specSettings.healthBar)

						-- Migrate custom bars (stagger, mana, defensives, etc.)
						if specSettings.bars then
							for barKey, barDimSettings in pairs(specSettings.bars) do
								if type(barDimSettings) == "table" then
									MigrateBarAnchor(barDimSettings)
								end
							end
						end

					end
				end
			end
		end
	end

	-- Migrate health bar overlay settings from displayBar.health to colors.healthBar
	-- Previously: displayBar.health.showAbsorb, .absorbMode, .showIncomingHeal, .incomingHealMode
	-- Now:        colors.healthBar.absorb.enabled, .mode; colors.healthBar.incomingHeal.enabled, .mode
	do
		local function MigrateHealthBarOverlays(settings)
			if settings == nil then
				return
			end
			local dh = settings.displayBar and settings.displayBar.health
			if dh == nil then
				return
			end

			-- Ensure colors.healthBar.absorb and .incomingHeal exist as tables
			if settings.colors == nil then settings.colors = {} end
			if settings.colors.healthBar == nil then settings.colors.healthBar = {} end
			if settings.colors.healthBar.absorb == nil then settings.colors.healthBar.absorb = {} end
			if settings.colors.healthBar.incomingHeal == nil then settings.colors.healthBar.incomingHeal = {} end

			-- Migrate absorb overlay
			if dh.showAbsorb ~= nil then
				if settings.colors.healthBar.absorb.enabled == nil then
					settings.colors.healthBar.absorb.enabled = dh.showAbsorb
				end
				dh.showAbsorb = nil
			end
			if dh.absorbMode ~= nil then
				if settings.colors.healthBar.absorb.mode == nil then
					settings.colors.healthBar.absorb.mode = dh.absorbMode
				end
				dh.absorbMode = nil
			end

			-- Migrate incoming heal overlay
			if dh.showIncomingHeal ~= nil then
				if settings.colors.healthBar.incomingHeal.enabled == nil then
					settings.colors.healthBar.incomingHeal.enabled = dh.showIncomingHeal
				end
				dh.showIncomingHeal = nil
			end
			if dh.incomingHealMode ~= nil then
				if settings.colors.healthBar.incomingHeal.mode == nil then
					settings.colors.healthBar.incomingHeal.mode = dh.incomingHealMode
				end
				dh.incomingHealMode = nil
			end
		end

		-- Migrate core settings
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core then
			MigrateHealthBarOverlays(TwintopInsanityBarSettings.core)
		end

		-- Migrate all class/spec settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if type(specSettings) == "table" then
						MigrateHealthBarOverlays(specSettings)
					end
				end
			end
		end
	end

	-- Abyssal Gaze for Havoc Demon Hunters
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.thresholds ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.thresholds.thresholdDictionary ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.thresholds.thresholdDictionary.abyssalGaze == nil then

		TwintopInsanityBarSettings.demonhunter.havoc.thresholds.thresholdDictionary.abyssalGaze = {
			enabled = TwintopInsanityBarSettings.demonhunter.havoc.thresholds.thresholdDictionary.eyeBeam.enabled
		}
	end

	-- Ensure core.displayText has barText and migrations tables for global bar text feature
	if TwintopInsanityBarSettings ~= nil and TwintopInsanityBarSettings.core ~= nil then
		if TwintopInsanityBarSettings.core.displayText == nil then
			TwintopInsanityBarSettings.core.displayText = {
				default = {
					fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
					fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
					fontJustifyHorizontal = "LEFT",
					fontJustifyHorizontalName = L["PositionLeft"],
					fontSize = 18,
					color = {
						color = "FFFFFFFF"
					},
				},
				barText = {},
				migrations = {}
			}
		else
			if TwintopInsanityBarSettings.core.displayText.barText == nil then
				TwintopInsanityBarSettings.core.displayText.barText = {}
			end
			if TwintopInsanityBarSettings.core.displayText.migrations == nil then
				TwintopInsanityBarSettings.core.displayText.migrations = {}
			end
		end

		-- Ensure globalBarText exists in all per-spec global toggle tables
		if TwintopInsanityBarSettings.core.global ~= nil then
			for className, classGlobals in pairs(TwintopInsanityBarSettings.core.global) do
				if type(classGlobals) == "table" and className ~= "globalEnable" then
					for specName, specGlobals in pairs(classGlobals) do
						if type(specGlobals) == "table" and specGlobals.globalBarText == nil then
							specGlobals.globalBarText = true
						end
					end
				end
			end
		end
	end

	-- Health bar text migration: extract common health bar text entries to global bar text
	-- This runs once per user. After migration, specs that shared the most common health bar text
	-- configuration get globalBarText enabled and their per-spec health entries removed.
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.core ~= nil and
		TwintopInsanityBarSettings.core.displayText ~= nil and
		TwintopInsanityBarSettings.core.displayText.migrations ~= nil and
		not TwintopInsanityBarSettings.core.displayText.migrations.healthBarText then

		local specsByClass = {
			deathknight = {"blood", "frost", "unholy"},
			demonhunter = {"havoc", "vengeance", "devourer"},
			druid = {"balance", "feral", "guardian", "restoration"},
			evoker = {"devastation", "preservation", "augmentation"},
			hunter = {"beastMastery", "marksmanship", "survival"},
			mage = {"arcane", "fire", "frost"},
			monk = {"brewmaster", "mistweaver", "windwalker"},
			paladin = {"holy", "protection", "retribution"},
			priest = {"discipline", "holy", "shadow"},
			rogue = {"assassination", "outlaw", "subtlety"},
			shaman = {"elemental", "enhancement", "restoration"},
			warlock = {"affliction", "demonology", "destruction"},
			warrior = {"arms", "fury", "protection"}
		}

		--- Serialize a bar text entry to a fingerprint string (excluding guid and display-only name fields)
		local function SerializeEntry(entry)
			local parts = {}
			parts[#parts+1] = "t=" .. tostring(entry.text or "")
			parts[#parts+1] = "e=" .. tostring(entry.enabled)
			parts[#parts+1] = "fs=" .. tostring(entry.fontSize or 0)
			parts[#parts+1] = "ff=" .. tostring(entry.fontFace or "")
			parts[#parts+1] = "jh=" .. tostring(entry.fontJustifyHorizontal or "")
			parts[#parts+1] = "dfc=" .. tostring(entry.useDefaultFontColor)
			parts[#parts+1] = "dff=" .. tostring(entry.useDefaultFontFace)
			parts[#parts+1] = "dfs=" .. tostring(entry.useDefaultFontSize)
			if entry.color and entry.color.color then
				parts[#parts+1] = "c=" .. entry.color.color
			end
			if entry.position then
				parts[#parts+1] = "px=" .. tostring(entry.position.xPos or 0)
				parts[#parts+1] = "py=" .. tostring(entry.position.yPos or 0)
				parts[#parts+1] = "rt=" .. tostring(entry.position.relativeTo or "")
				parts[#parts+1] = "rf=" .. tostring(entry.position.relativeToFrame or "")
			end
			return table.concat(parts, "|")
		end

		--- Fingerprint an ordered set of health bar text entries
		local function FingerprintEntries(entries)
			local serialized = {}
			for _, entry in ipairs(entries) do
				serialized[#serialized+1] = SerializeEntry(entry)
			end
			return table.concat(serialized, ";;")
		end

		local fingerprintCounts = {}  -- fingerprint -> count
		local fingerprintEntries = {} -- fingerprint -> entries (first occurrence)
		local specFingerprints = {}   -- "className.specName" -> fingerprint

		for className, specs in pairs(specsByClass) do
			for _, specName in ipairs(specs) do
				local specSettings = TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
				if specSettings and specSettings.displayText and specSettings.displayText.barText then
					local healthEntries = {}
					for _, entry in ipairs(specSettings.displayText.barText) do
						if entry.position and entry.position.relativeToFrame == "HealthBar" then
							healthEntries[#healthEntries+1] = entry
						end
					end

					if #healthEntries > 0 then
						local fp = FingerprintEntries(healthEntries)
						local key = className .. "." .. specName
						specFingerprints[key] = fp
						fingerprintCounts[fp] = (fingerprintCounts[fp] or 0) + 1
						if not fingerprintEntries[fp] then
							fingerprintEntries[fp] = healthEntries
						end
					end
				end
			end
		end

		-- Find the most common fingerprint
		local bestFp = nil
		local bestCount = 0
		for fp, count in pairs(fingerprintCounts) do
			if count > bestCount then
				bestFp = fp
				bestCount = count
			end
		end

		-- Only migrate if at least 2 specs share the same health bar text
		if bestFp and bestCount >= 2 then
			-- Copy winning entries to global bar text with new GUIDs
			local sourceEntries = fingerprintEntries[bestFp]
			for _, entry in ipairs(sourceEntries) do
				local globalEntry = {
					useDefaultFontColor = entry.useDefaultFontColor,
					useDefaultFontFace = entry.useDefaultFontFace,
					useDefaultFontSize = entry.useDefaultFontSize,
					enabled = entry.enabled,
					name = entry.name,
					guid = TRB.Functions.String:Guid(),
					text = entry.text,
					fontFace = entry.fontFace,
					fontFaceName = entry.fontFaceName,
					fontJustifyHorizontal = entry.fontJustifyHorizontal,
					fontJustifyHorizontalName = entry.fontJustifyHorizontalName,
					fontSize = entry.fontSize,
					color = { color = entry.color and entry.color.color or "FFFFFFFF" },
					position = {
						xPos = entry.position.xPos,
						yPos = entry.position.yPos,
						relativeTo = entry.position.relativeTo,
						relativeToName = entry.position.relativeToName,
						relativeToFrame = entry.position.relativeToFrame,
						relativeToFrameName = entry.position.relativeToFrameName
					}
				}
				table.insert(TwintopInsanityBarSettings.core.displayText.barText, globalEntry)
			end

			-- Enable globalBarText and remove migrated entries for matching specs;
			-- disable globalBarText for non-matching specs so they keep their unique per-spec entries
			for key, fp in pairs(specFingerprints) do
				local className, specName = key:match("^(.+)%.(.+)$")
				if className and specName then
					if fp == bestFp then
						-- Enable global bar text for this spec
						if TwintopInsanityBarSettings.core.global and
							TwintopInsanityBarSettings.core.global[className] and
							TwintopInsanityBarSettings.core.global[className][specName] then
							TwintopInsanityBarSettings.core.global[className][specName].globalBarText = true
						end

						-- Remove health bar entries from per-spec list (iterate backwards to preserve indices)
						local barText = TwintopInsanityBarSettings[className][specName].displayText.barText
						for i = #barText, 1, -1 do
							if barText[i].position and barText[i].position.relativeToFrame == "HealthBar" then
								table.remove(barText, i)
							end
						end
					else
						-- Spec has health bar text entries that differ from the winning fingerprint.
						-- Disable globalBarText so they keep their own per-spec entries without also
						-- showing the global ones (which would cause double health text).
						if TwintopInsanityBarSettings.core.global and
							TwintopInsanityBarSettings.core.global[className] and
							TwintopInsanityBarSettings.core.global[className][specName] then
							TwintopInsanityBarSettings.core.global[className][specName].globalBarText = false
						end
					end
				end
			end
		end

		TwintopInsanityBarSettings.core.displayText.migrations.healthBarText = true
	end

	-- Migrate collapseBorderWidth for all specs
	-- If spacing was 0 (or nil), enable collapse by default (the new behavior).
	-- If spacing was > 0, preserve the user's explicit spacing and disable collapse.
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if type(specSettings) == "table" then
					-- Migrate comboPoints (secondary bar)
					if specSettings.comboPoints and specSettings.comboPoints.collapseBorderWidth == nil then
						specSettings.comboPoints.collapseBorderWidth = (specSettings.comboPoints.spacing or 0) == 0
					end

					-- Migrate custom bars (bars.<key>)
					if specSettings.bars then
						for barKey, barSettings in pairs(specSettings.bars) do
							if type(barSettings) == "table" and barSettings.collapseBorderWidth == nil and barSettings.spacing ~= nil then
								barSettings.collapseBorderWidth = (barSettings.spacing or 0) == 0
							end
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
			if  k == "manualUpdateChecks" or
				k == "core" or
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
		anchor = {
			barKey = "screen",
			anchorPoint = "CENTER",
			attachPoint = "CENTER",
			xOffset = 0,
			yOffset = -200,
			matchWidth = false,
		},
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
		anchor = {
			barKey = "primary",
			anchorPoint = "BOTTOM",
			attachPoint = "TOP",
			xOffset = 0,
			yOffset = yPos,
			matchWidth = true,
		},
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
			collapseBorderWidth = false,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "primary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
			},
		}
	end

	return {
		width = 60,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		relativeTo ="TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
		},
	}
end

function TRB.Functions.Settings:DefaultHealthBarColors()
	return {
		border = { color = "FF008800" },
		background = { color = "66000000" },
		absorb = { color = "CCFFFFB9", enabled = true, mode = "appended" },
		incomingHeal = { color = "CC80b980", enabled = true, mode = "appended" },
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
			collapseBorderWidth = true,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "primary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
		},
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
			collapseBorderWidth = true,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "primary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
		},
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
			collapseBorderWidth = false,
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "primary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "primary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
		},
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

---Gets default Utility bar dimensions (anchored below health bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultUtilityBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			relativeTo = "BOTTOM",
			relativeToName = L["PositionBelowMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "health",
				anchorPoint = "BOTTOM",
				attachPoint = "TOP",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
			},
		}
	end

	return {
		width = 30,
		height = 20,
		xPos = 0,
		yPos = 0,
		border = 2,
		spacing = 0,
		collapseBorderWidth = true,
		relativeTo = "BOTTOM",
		relativeToName = L["PositionBelowMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "health",
			anchorPoint = "BOTTOM",
			attachPoint = "TOP",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
		},
	}
end

---Gets default Utility bar colors (generic; class modules should override via BarTypeRegistry)
---@return table
function TRB.Functions.Settings:DefaultUtilityBarColors()
	return {
		border = { color = "FF888888" },
		background = { color = "66000000" },
		nodeColors = {
			charge1 = { color = "FFAAAAAA", enabled = true },
			charge2 = { color = "FFAAAAAA", enabled = true },
			charge3 = { color = "FFAAAAAA", enabled = true }
		}
	}
end


---Migrates anchor blocks for all bar settings in the provided settings table.
---Synthesizes anchor blocks from legacy relativeTo/xPos/yPos/fullWidth fields.
---@param settingsTable table # The top-level settings table (e.g., TRB.Data.settings)
---@param forceResync boolean? # If true, re-synthesize all anchor blocks even if they already exist
function TRB.Functions.Settings:MigrateBarAnchors(settingsTable, forceResync)
	if not settingsTable then
		return
	end

	local anchorMap = TRB.Data.constants.relativeToAnchorMap

	local function MigrateOne(barSettings)
		if barSettings == nil then return end
		if barSettings.anchor ~= nil and not forceResync then return end
		if barSettings.relativeTo then
			local mapping = anchorMap[barSettings.relativeTo]
			if mapping then
				barSettings.anchor = {
					barKey = "primary",
					anchorPoint = mapping.anchorPoint,
					attachPoint = mapping.attachPoint,
					xOffset = barSettings.xPos or 0,
					yOffset = barSettings.yPos or 0,
					matchWidth = barSettings.fullWidth or false,
				}
			end
		elseif barSettings.xPos ~= nil and barSettings.yPos ~= nil and barSettings.relativeTo == nil then
			-- Primary bar (has xPos/yPos but no relativeTo) → screen anchor
			barSettings.anchor = {
				barKey = "screen",
				anchorPoint = "CENTER",
				attachPoint = "CENTER",
				xOffset = barSettings.xPos or 0,
				yOffset = barSettings.yPos or -200,
				matchWidth = false,
			}
		end
	end

	local classes = {
		"deathknight", "demonhunter", "druid", "evoker", "hunter",
		"mage", "monk", "paladin", "priest", "rogue",
		"shaman", "warlock", "warrior"
	}

	for _, className in ipairs(classes) do
		if settingsTable[className] then
			for specName, specSettings in pairs(settingsTable[className]) do
				if type(specSettings) == "table" then
					MigrateOne(specSettings.bar)
					MigrateOne(specSettings.comboPoints)
					MigrateOne(specSettings.healthBar)
					if specSettings.bars then
						for _, barDimSettings in pairs(specSettings.bars) do
							if type(barDimSettings) == "table" then
								MigrateOne(barDimSettings)
							end
						end
					end
				end
			end
		end
	end
end

---Gets the default textures for bars
---@param includeComboPoints boolean?
---@param includeManaBar boolean?
---@param customBars TRB.Classes.BarTypeDefinition[]?
---@return table
function TRB.Functions.Settings:DefaultTextures(includeComboPoints, includeManaBar, customBars)
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
		absorbBar="Interface\\Buttons\\WHITE8X8",
		absorbBarName="Solid",
		incomingHealBar="Interface\\Buttons\\WHITE8X8",
		incomingHealBarName="Solid",
		castingBar="Interface\\Addons\\TwintopInsanityBar\\StatusBars\\smoother.tga",
		castingBarName=L["LSMStatusBarSmoother"],
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
	if customBars then
		for _, barTypeDef in ipairs(customBars) do
			local defaults = barTypeDef:GetDefaultTextures()
			local key = barTypeDef.key
			textures[key .. "Bar"] = defaults.bar
			textures[key .. "BarName"] = defaults.barName
			textures[key .. "Border"] = defaults.border
			textures[key .. "BorderName"] = defaults.borderName
			textures[key .. "Background"] = defaults.background
			textures[key .. "BackgroundName"] = defaults.backgroundName
		end
	end
	return textures
end

---Gets default settings for "End Of" buff tracking configuration
---@param mode "gcd"|"time" # Whether to use GCD count or time for the threshold
---@param gcdsMax number # Number of GCDs for the threshold (when mode is "gcd")
---@param timeMax number # Seconds for the threshold (when mode is "time")
---@param extraOptions table? # Optional table of additional options to merge into the result
---@return TRB.Classes.Settings.GenericTrackingOverX
function TRB.Functions.Settings:DefaultEndOfSettings(mode, gcdsMax, timeMax, extraOptions)
	local settings = {
		enabled = true,
		mode = mode or "gcd",
		gcdsMax = gcdsMax or 2,
		timeMax = timeMax or 3.0
	}

	if extraOptions then
		for k, v in pairs(extraOptions) do
			settings[k] = v
		end
	end

	return settings
end

---Creates a default bar text entry for buff time display with icon
---@param variable string # The bar text variable name without $ (e.g., "bestialWrathTime")
---@param icon string # The icon reference without # (e.g., "bestialWrath")
---@param classic boolean # Whether to use classic layout
---@param classicPosition "LEFT"|"CENTER"|"RIGHT"? # Position for classic layout (default: CENTER)
---@param regularPosition "LEFT"|"CENTER"|"RIGHT"? # Position for regular layout (default: RIGHT)
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:DefaultBuffTimeBarTextEntry(variable, icon, classic, classicPosition, regularPosition)
	classicPosition = classicPosition or "CENTER"
	regularPosition = regularPosition or "RIGHT"

	---@param position "LEFT"|"CENTER"|"RIGHT"
	---@return TRB.Classes.Settings.DisplayTextEntry
	local function BuildEntry(position)
		local xPos = 0
		local name = L["PositionMiddle"]
		local fontJustifyHorizontalName = L["PositionCenter"]

		if position == "LEFT" then
			xPos = 2
			name = L["PositionLeft"]
			fontJustifyHorizontalName = L["PositionLeft"]
		elseif position == "RIGHT" then
			xPos = -2
			name = L["PositionRight"]
			fontJustifyHorizontalName = L["PositionRight"]
		end

		return {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = name,
			guid = TRB.Functions.String:Guid(),
			text = "{$" .. variable .. "}[#" .. icon .. "$" .. variable .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = position,
			fontJustifyHorizontalName = fontJustifyHorizontalName,
			fontSize = 14,
			color = { color = "FFFFFFFF" },
			position = {
				xPos = xPos,
				yPos = 0,
				relativeTo = position,
				relativeToName = fontJustifyHorizontalName,
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	end

	if classic then
		return BuildEntry(classicPosition)
	else
		return BuildEntry(regularPosition)
	end
end

---Get the locale-specific default font constants
---@return {fontFace: string, fontFaceName: string}
function TRB.Functions.Settings:DefaultFontConstants()
	local locale = GetLocale()
	if locale == "ruRU" then
		return {
			fontFace = "Fonts\\FRIZQT___CYR.TTF",
			fontFaceName = "Friz Quadrata TT",
		}
	elseif locale == "koKR" then
		return {
			fontFace = "Fonts\\2002.TTF",
			fontFaceName = "기본 글꼴",
		}
	elseif locale == "zhCN" then
		return {
			fontFace = "Fonts\\ARKai_T.ttf",
			fontFaceName = "默认",
		}
	elseif locale == "zhTW" then
		return {
			fontFace = "Fonts\\bLEI00D.TTF",
			fontFaceName = "預設",
		}
	else
		return {
			fontFace = "Fonts\\FRIZQT__.TTF",
			fontFaceName = "Friz Quadrata TT"
		}
	end
end

TRB.Data.constants.defaultSettings.fonts = TRB.Functions.Settings:DefaultFontConstants()

---Gets the default settings for threshold icons
---@return table
function TRB.Functions.Settings:DefaultThresholdIconSettings()
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			color = { color = "FFFFFFFF" },
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
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


---Returns default global bar text
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultGlobalBarTextSettings(classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {
		{
			enabled = false,
			fontFace = "Fonts\\FRIZQT__.TTF",
			useDefaultFontFace = false,
			guid = TRB.Functions.String:Guid(),
			fontJustifyHorizontalName = "Center",
			text = "{$inCombatTime}[$inCombatTime]",
			useDefaultFontColor = false,
			fontFaceName = "Friz Quadrata TT",
			name = "Combat Time",
			position = {
				relativeToName = "Center",
				relativeTo = "CENTER",
				xPos = -400,
				relativeToFrameName = "Screen",
				yPos = -200,
				relativeToFrame = "UIParent",
			},
			fontJustifyHorizontal = "CENTER",
			useDefaultFontSize = false,
			color = {
				color = "fffe7878",
			},
			fontSize = 48,
		},
	}

	local extraTextSettings = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			color = { color = "FFFFFFFF" },
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
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
---| '"mana"' # $mana% left, $mana / $manaMax right on Resource Bar
---| '"manaBar"' # $mana% left, $mana right on Mana Bar

---Adds default bar text that is used globally
---@param includeResourceType trbIncludeResourceType?
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(includeResourceType, classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}

	local relativeToFrame = "Resource"
	local relativeToFrameName = L["MainResourceBar"]
	if includeResourceType == "manaBar" then
		relativeToFrame = "ManaBar"
		relativeToFrameName = L["ManaBar"]
	end

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
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=20,
				color = { color = "FFFFFFFF" },
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
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = L["PositionCenter"],
				fontSize=16,
				color = { color = "FFFFFFFF" },
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
	elseif includeResourceType == "mana" or includeResourceType == "manaBar" then
		if classic then
			table.insert(textSettings, {
				useDefaultFontColor = false,
				useDefaultFontFace = false,
				useDefaultFontSize = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]$mana/$manaMax $manaPercent%",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				color = { color = "FFFFFFFF" },
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = L["PositionRight"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
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
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=16,
				color = { color = "FFFFFFFF" },
				position = {
					xPos = 2,
					yPos = 0,
					relativeTo = "LEFT",
					relativeToName = L["PositionLeft"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
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
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				color = { color = "FFFFFFFF" },
				position = {
					xPos = -2,
					yPos = 0,
					relativeTo = "RIGHT",
					relativeToName = L["PositionRight"],
					relativeToFrame = relativeToFrame,
					relativeToFrameName = relativeToFrameName
				}
			})
		end
	end

	return textSettings
end

---Shows a message in chat informing the user that their bar text has been reset due to Midnight changes.
---@param className string
function TRB.Functions.Settings:ShowMidnightBarTextResetMessage(className)
	print(string.format(L["MidnightBarTextResetMessage"], className))
end