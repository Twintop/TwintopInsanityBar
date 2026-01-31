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
				icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
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
					color = "FFFFFFFF",
				},
				barText = {}
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
									color = "FFFFFFFF"
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
											color = "ffffffff",
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{($predatorRevealedNextCp=($comboPoints+1)&$comboPoints=1)||($predatorRevealedNextCp=($comboPoints+2)&$comboPoints=0)}[$predatorRevealedTickTime]{($incarnationNextCp=($comboPoints+1)&$comboPoints=1)||($incarnationNextCp=($comboPoints+2)&$comboPoints=0)}[$incarnationTickTime]",
											color = "ffffffff",
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
											color = "ffffffff",
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
											color = "ffffffff",
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
											color = "ffffffff",
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
											color = "ffffffff",
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
											color = "FFFFFFFF",
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
											color = "FFFFFFFF",
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
											color = "FFFFFFFF",
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
											color = "FFFFFFFF",
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
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.core ~= nil and
	TwintopInsanityBarSettings.core.smoothBarValueUpdates == nil then
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
		dragAndDrop = false
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

---Gets default settings for "End Of" buff tracking configuration
---@param mode "gcd"|"time" # Whether to use GCD count or time for the threshold
---@param gcdsMax number # Number of GCDs for the threshold (when mode is "gcd")
---@param timeMax number # Seconds for the threshold (when mode is "time")
---@return TRB.Classes.Settings.GenericTrackingOverX
function TRB.Functions.Settings:DefaultEndOfSettings(mode, gcdsMax, timeMax)
	return {
		enabled = true,
		mode = mode or "gcd",
		gcdsMax = gcdsMax or 2,
		timeMax = timeMax or 3.0
	}
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
			color = "FFFFFFFF",
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
	print("Locale detected:", locale)
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
---| '"mana"' # $mana% left, $mana / $manaMax right on Resource Bar
---| '"manaBar"' # $mana% left, $mana right on Mana Bar

---Adds default bar text that is used globally
---@param includeResourceType trbIncludeResourceType?
---@param classic boolean?
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:GlobalLoadDefaultBarTextSettings(includeResourceType, classic)
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)

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
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
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
				color = "FFFFFFFF",
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
				color = "FFFFFFFF",
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
				color = "FFFFFFFF",
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