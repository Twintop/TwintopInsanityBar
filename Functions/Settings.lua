local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

local VISIBILITY_MANA_MAX = 275625 -- 250k base, enchant or Gnome * 1.05, both is another * 1.05

---Creates spec-level threshold definitions for secondary Mana Bar visibility options.
---@return table<string, table>
function TRB.Functions.Settings:LoadDefaultManaBarVisibilityThresholds()
	return {
		manaPercent = {
			valueType = "percent",
			powerType = Enum.PowerType.Mana,
		},
		manaValue = {
			valueType = "value",
			powerType = Enum.PowerType.Mana,
			maxValue = VISIBILITY_MANA_MAX,
		},
	}
end

---Creates a new independent copy of the default hard-hide visibility conditions.
---@return trbBarVisibilityHideConditions
function TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()
	return {
		isMountedAny = false,
		isMountedGround = false,
		isMountedFlying = false,
		isSteadyFlightFlying = false,
		isSkyriding = false,
		isSkyridingFlying = false,
		isDruidHumanoidForm = false,
		isDruidTravelFormAny = false,
		isDruidStagForm = false,
		isDruidFlightForm = false,
		isDruidSwiftFlightForm = false,
		isDruidAquaticForm = false,
		isDruidCatForm = false,
		isDruidBearForm = false,
		isDruidMoonkinForm = false,
		inVehicle = false,
		inPetBattle = true,
		onTaxi = true,
	}
end

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
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				secondary = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = false,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				health = {
					neverShow = false,
					alwaysShow = true,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
				},
				utility = {
					neverShow = true,
					alwaysShow = false,
					conditions = {},
					hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
					smooth = true,
					activeAlpha = 100,
					inactiveAlpha = 0,
					fadeDuration = 0,
					fadeDelay = 0,
					resourceConditionType = "none",
					resourceConditionOperator = ">=",
					resourceConditionValue = 0
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
					fontOutline = "OUTLINE",
					fontOutlineName = L["FontOutlineOutline"],
					fontShadow = {
						enabled = false,
						color = "FF000000",
						xOffset = 1,
						yOffset = -1,
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

---Per-profile port-forward hook. Calls PortForwardSettings against the given
---profile subtable. Use for migrating individual profiles in the profiles.list
---structure. The `profile` parameter should be shaped like a top-level settings
---table (i.e. has optional `core` and class/spec keys), which is exactly how
---profiles are stored.
---@param profile table?
function TRB.Functions.Settings:PortForwardProfile(profile)
	if profile == nil then
		return
	end
	self:PortForwardSettings(profile)
end

---Migrates legacy and outdated TwintopInsanityBar saved-variable structures to the current settings format, handling renames, restructures, threshold refactors, bar text format changes, color standardizations, and displayBar enum conversions across all classes and specs.
---
---Accepts any table shaped like the top-level saved-variables (i.e. with `core`,
---`<className>.<specName>`, etc.). The global `TwintopInsanityBarSettings` is
---used as the default when no argument is passed, so existing callers continue
---to work. Inside this function, `TwintopInsanityBarSettings` is aliased to the
---argument via lexical scoping — every `TwintopInsanityBarSettings.x` reference
---in the body refers to the passed-in table, not the global.
---@param settings table?
function TRB.Functions.Settings:PortForwardSettings(settings)
	---@diagnostic disable-next-line: unused-local
	local TwintopInsanityBarSettings = settings or _G.TwintopInsanityBarSettings
	if TwintopInsanityBarSettings == nil then
		return
	end

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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
---@diagnostic disable-next-line: missing-fields
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
	---Migrates a displayBar settings table from the old boolean format (alwaysShow/neverShow) to the new enum format ("always"/"never"/"combat")
	---@param displayBar table? The displayBar settings table to migrate in-place; does nothing if nil or already migrated
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

					-- Add Fire Mage default Fire Blast charge node timer text to existing profiles.
					if className == "mage" and specName == "fire" and specSettings.displayText then
						specSettings.displayText.barText = specSettings.displayText.barText or {}
						specSettings.displayText.migrations = specSettings.displayText.migrations or {}
						if not specSettings.displayText.migrations.fireBlastChargeNodeTimers then
							local existingDefaultEntries = {}
							for _, entry in ipairs(specSettings.displayText.barText) do
								if entry.position and entry.position.relativeToFrame and entry.text then
									existingDefaultEntries[entry.position.relativeToFrame .. "::" .. entry.text] = true
								end
							end

							local fireBlastChargeText = TRB.Functions.Settings:LoadDefaultFireBlastChargeBarTextSettings()
							for _, entry in ipairs(fireBlastChargeText) do
								local entryKey = entry.position.relativeToFrame .. "::" .. entry.text
								if not existingDefaultEntries[entryKey] then
									table.insert(specSettings.displayText.barText, entry)
								end
							end
							specSettings.displayText.migrations.fireBlastChargeNodeTimers = true
						end
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
								fillDirection = specSettings.comboPoints.fillDirection or "leftRight",
								growthDirection = specSettings.comboPoints.growthDirection or "leftRight",
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
								fillDirection = specSettings.comboPoints.fillDirection or "leftRight",
								growthDirection = specSettings.comboPoints.growthDirection or "leftRight",
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
							-- Backfill nodeOrder for users who migrated before this field existed
							if specSettings.colors.bars.defensives and not specSettings.colors.bars.defensives.nodeOrder then
								specSettings.colors.bars.defensives.nodeOrder = { "ignorePain", "shieldBlock" }
							end

							-- Add Ignore Pain (Absorb) node for existing users
							if specSettings.colors.bars.defensives and specSettings.colors.bars.defensives.nodeColors and not specSettings.colors.bars.defensives.nodeColors.ignorePainAbsorb then
								specSettings.colors.bars.defensives.nodeColors.ignorePainAbsorb = { color = "FFFF9800", enabled = true }
								-- Insert after ignorePain in nodeOrder
								local nodeOrder = specSettings.colors.bars.defensives.nodeOrder
								local inserted = false
								for i, key in ipairs(nodeOrder) do
									if key == "ignorePain" then
										table.insert(nodeOrder, i + 1, "ignorePainAbsorb")
										inserted = true
										break
									end
								end
								if not inserted then
									table.insert(nodeOrder, 1, "ignorePainAbsorb")
								end
								-- Add default bar text entry for the new node
								if specSettings.displayText and specSettings.displayText.barText then
									table.insert(specSettings.displayText.barText, {
										useDefaultFontColor = true,
										useDefaultFontOutline = true,
										useDefaultFontShadow = true,
										fontOutline = "OUTLINE",
										fontOutlineName = L["FontOutlineOutline"],
										fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
										fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
										useDefaultFontFace = true,
										guid = TRB.Functions.String:Guid(),
										fontJustifyHorizontalName = L["PositionCenter"],
										text = "$ignorePainAbsorb%",
										fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
										fontSize = 14,
										name = L["IgnorePainAbsorb"],
										position = {
											relativeToName = L["PositionCenter"],
											relativeTo = "CENTER",
											xPos = 0,
											relativeToFrameName = L["IgnorePainAbsorb"],
											yPos = 0,
											relativeToFrame = "IgnorePainAbsorb",
										},
										fontJustifyHorizontal = "CENTER",
										useDefaultFontSize = true,
										color = { color = "FFFFFFFF" },
										enabled = true,
									})
								end
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

					-- Migrate Holy Priest Holy Words bar from old comboPoints structure to new bars.holyWords structure
					if className == "priest" and specName == "holy" then
						-- Determine global toggle state BEFORE any migration so we can use the correct source.
						-- When globalHoly.comboPoints was true, runtime used core.comboPoints for dimensions.
						-- When globalHoly.displayBar was true, runtime used core.displayBar.secondary for visibility.
						-- Since bars.holyWords and displayBar.holyWords are always spec-specific (no global toggle),
						-- we must bake the active global values into the spec settings during migration.
						local globalHoly = nil
						local coreSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings.core
						if coreSettings and coreSettings.global and coreSettings.global.priest and coreSettings.global.priest.holy then
							globalHoly = coreSettings.global.priest.holy
						end
						local useGlobalComboPoints = globalHoly and globalHoly.comboPoints == true
						local useGlobalDisplayBar = globalHoly and globalHoly.displayBar == true

						-- Select dimension source: global core.comboPoints if the toggle was on, else spec.comboPoints
						local dimSource = nil
						if useGlobalComboPoints and coreSettings and coreSettings.comboPoints then
							dimSource = coreSettings.comboPoints
						elseif specSettings.comboPoints then
							dimSource = specSettings.comboPoints
						end

						-- Migrate dimensions: comboPoints -> bars.holyWords
						if dimSource then
							if not specSettings.bars then
								specSettings.bars = {}
							end
							if not specSettings.bars.holyWords then
								specSettings.bars.holyWords = {
									width = dimSource.width or 30,
									height = dimSource.height or 20,
									xPos = dimSource.xPos or 0,
									yPos = dimSource.yPos or 0,
									border = dimSource.border or 2,
									spacing = dimSource.spacing or 0,
									fillDirection = dimSource.fillDirection or "leftRight",
									growthDirection = dimSource.growthDirection or "leftRight",
									relativeTo = dimSource.relativeTo or "TOP",
									relativeToName = dimSource.relativeToName or L["PositionAboveMiddle"],
									fullWidth = dimSource.fullWidth
								}
								-- Backfill anchor if missing
								if not specSettings.bars.holyWords.anchor then
									specSettings.bars.holyWords.anchor = {
										barKey = "primary",
										anchorPoint = "TOP",
										attachPoint = "BOTTOM",
										xOffset = 0,
										yOffset = 0,
										matchWidth = true,
										matchHeight = false,
									}
								end
							end
						end
						-- Always clean up old spec-level comboPoints after migration
						specSettings.comboPoints = nil

						-- Migrate colors: colors.comboPoints.holyWord* -> colors.bars.holyWords.nodeColors
						if specSettings.colors and specSettings.colors.comboPoints then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.holyWords then
								local oldColors = specSettings.colors.comboPoints
								specSettings.colors.bars.holyWords = {
									border = { color = (oldColors.border and oldColors.border.color) or "FF000099" },
									background = { color = (oldColors.background and oldColors.background.color) or "66000000" },
									nodeOrder = { "holyWordSerenity", "holyWordSanctify", "holyWordChastise" },
									nodeColors = {
										holyWordSerenity = {
											color = (oldColors.holyWordSerenity and oldColors.holyWordSerenity.color) or "FF00DDDD",
											enabled = oldColors.holyWordSerenity and oldColors.holyWordSerenity.enabled ~= false
										},
										holyWordSanctify = {
											color = (oldColors.holyWordSanctify and oldColors.holyWordSanctify.color) or "FFFFDD22",
											enabled = oldColors.holyWordSanctify and oldColors.holyWordSanctify.enabled ~= false
										},
										holyWordChastise = {
											color = (oldColors.holyWordChastise and oldColors.holyWordChastise.color) or "FFFF8080",
											enabled = oldColors.holyWordChastise and oldColors.holyWordChastise.enabled ~= false
										}
									},
									completeCooldown = {
										color = (oldColors.completeCooldown and oldColors.completeCooldown.color) or "FF00B500",
										enabled = oldColors.completeCooldown and oldColors.completeCooldown.enabled ~= false
									}
								}
								specSettings.colors.comboPoints = nil -- Remove old colors after migration
							end
						end

						-- Migrate textures: textures.comboPointsBar/etc -> flat holyWords texture keys
						if specSettings.textures then
							if not specSettings.textures.holyWordsBar then
								specSettings.textures.holyWordsBar = specSettings.textures.comboPointsBar or specSettings.textures.resourceBar
								specSettings.textures.holyWordsBarName = specSettings.textures.comboPointsBarName or specSettings.textures.resourceBarName
								specSettings.textures.holyWordsBorder = specSettings.textures.comboPointsBorder or specSettings.textures.border
								specSettings.textures.holyWordsBorderName = specSettings.textures.comboPointsBorderName or specSettings.textures.borderName
								specSettings.textures.holyWordsBackground = specSettings.textures.comboPointsBackground or specSettings.textures.background
								specSettings.textures.holyWordsBackgroundName = specSettings.textures.comboPointsBackgroundName or specSettings.textures.backgroundName

								specSettings.textures.comboPointsBar = nil
								specSettings.textures.comboPointsBarName = nil
								specSettings.textures.comboPointsBorder = nil
								specSettings.textures.comboPointsBorderName = nil
								specSettings.textures.comboPointsBackground = nil
								specSettings.textures.comboPointsBackgroundName = nil
							end
						end

						-- Migrate displayBar: secondary -> holyWords (BarVisibility format)
						-- When global displayBar was active, the effective secondary visibility came from
						-- core.displayBar.secondary, not spec.displayBar.secondary. Bake the global value.
						if specSettings.displayBar and not specSettings.displayBar.holyWords then
							local visSource = nil
							if useGlobalDisplayBar and coreSettings and coreSettings.displayBar and coreSettings.displayBar.secondary then
								-- Deep copy from global so we don't alias the shared core table
								local gs = coreSettings.displayBar.secondary
								visSource = {
									neverShow = gs.neverShow,
									alwaysShow = gs.alwaysShow,
									smooth = gs.smooth,
									activeAlpha = gs.activeAlpha,
									inactiveAlpha = gs.inactiveAlpha,
									fadeDuration = gs.fadeDuration,
									fadeDelay = gs.fadeDelay,
									hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
								}
								-- Deep copy conditions table if present
								if gs.conditions then
									visSource.conditions = {}
									for ck, cv in pairs(gs.conditions) do
										visSource.conditions[ck] = cv
									end
								else
									visSource.conditions = {}
								end
								if gs.hideConditions then
									for ck, cv in pairs(gs.hideConditions) do
										visSource.hideConditions[ck] = cv
									end
								end
							elseif specSettings.displayBar.secondary then
								visSource = specSettings.displayBar.secondary
							end

							if visSource then
								specSettings.displayBar.holyWords = visSource
								specSettings.displayBar.secondary = nil
							else
								specSettings.displayBar.holyWords = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 }
							end
						end

						-- Ensure bars.holyWords exists (fallback if no migration source)
						if not specSettings.bars then
							specSettings.bars = {}
						end
						if not specSettings.bars.holyWords then
							specSettings.bars.holyWords = TRB.Functions.Settings:DefaultHolyWordsBarDimensions()
						end

						-- Ensure colors.bars.holyWords exists (fallback if no migration source)
						if specSettings.colors then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.holyWords then
								specSettings.colors.bars.holyWords = TRB.Functions.Settings:DefaultHolyWordsBarColors()
							end
							-- Backfill nodeOrder for users who migrated before this field existed
							if specSettings.colors.bars.holyWords and not specSettings.colors.bars.holyWords.nodeOrder then
								specSettings.colors.bars.holyWords.nodeOrder = { "holyWordSerenity", "holyWordSanctify", "holyWordChastise" }
							end
						end

						-- Ensure textures exist (fallback if no migration source)
						if specSettings.textures and not specSettings.textures.holyWordsBar then
							specSettings.textures.holyWordsBar = specSettings.textures.resourceBar
							specSettings.textures.holyWordsBarName = specSettings.textures.resourceBarName
							specSettings.textures.holyWordsBorder = specSettings.textures.border
							specSettings.textures.holyWordsBorderName = specSettings.textures.borderName
							specSettings.textures.holyWordsBackground = specSettings.textures.background
							specSettings.textures.holyWordsBackgroundName = specSettings.textures.backgroundName
						end

						-- Clean up the obsolete global comboPoints toggle (no longer applicable to custom bar types)
						if globalHoly and globalHoly.comboPoints ~= nil then
							globalHoly.comboPoints = nil
						end
					end

					-- Migrate Blood Death Knight: add Bone Shield bar settings and default bar text
					if className == "deathknight" and specName == "blood" then
						if not specSettings.bars then
							specSettings.bars = {}
						end
						if not specSettings.bars.boneShield then
							specSettings.bars.boneShield = TRB.Functions.Settings:DefaultBoneShieldBarDimensions()
						end

						if specSettings.colors then
							specSettings.colors.bars = specSettings.colors.bars or {}
							if not specSettings.colors.bars.boneShield then
								specSettings.colors.bars.boneShield = TRB.Functions.Settings:DefaultBoneShieldBarColors()
							else
								local defaultBoneShieldColors = TRB.Functions.Settings:DefaultBoneShieldBarColors()
								specSettings.colors.bars.boneShield.bar = specSettings.colors.bars.boneShield.bar or defaultBoneShieldColors.bar
								specSettings.colors.bars.boneShield.border = specSettings.colors.bars.boneShield.border or defaultBoneShieldColors.border
								specSettings.colors.bars.boneShield.background = specSettings.colors.bars.boneShield.background or defaultBoneShieldColors.background
								specSettings.colors.bars.boneShield.ossuary = specSettings.colors.bars.boneShield.ossuary or defaultBoneShieldColors.ossuary
								specSettings.colors.bars.boneShield.ossuaryThreshold = specSettings.colors.bars.boneShield.ossuaryThreshold or defaultBoneShieldColors.ossuaryThreshold
							end
						end

						if specSettings.textures and not specSettings.textures.boneShieldBar then
							local boneShieldTextures = TRB.Functions.Settings:DefaultCustomBarTextures()
							specSettings.textures.boneShieldBar = boneShieldTextures.bar
							specSettings.textures.boneShieldBarName = boneShieldTextures.barName
							specSettings.textures.boneShieldBorder = boneShieldTextures.border
							specSettings.textures.boneShieldBorderName = boneShieldTextures.borderName
							specSettings.textures.boneShieldBackground = boneShieldTextures.background
							specSettings.textures.boneShieldBackgroundName = boneShieldTextures.backgroundName
						end

						if not specSettings.displayBar then
							specSettings.displayBar = {}
						end
						if not specSettings.displayBar.boneShield then
							specSettings.displayBar.boneShield = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = false, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 }
						end

						if specSettings.displayText and specSettings.displayText.barText then
							local hasBoneShieldText = false
							for _, entry in ipairs(specSettings.displayText.barText) do
								if entry.position and entry.position.relativeToFrame == "Container::boneShield" then
									hasBoneShieldText = true
									break
								end
							end
							if not hasBoneShieldText then
								table.insert(specSettings.displayText.barText, {
									useDefaultFontColor = true,
									useDefaultFontOutline = true,
									useDefaultFontShadow = true,
									fontOutline = "OUTLINE",
									fontOutlineName = L["FontOutlineOutline"],
									fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
									fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
									useDefaultFontFace = true,
									guid = TRB.Functions.String:Guid(),
									fontJustifyHorizontalName = L["PositionCenter"],
									text = "$boneShieldStacks",
									fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
									fontSize = 14,
									name = L["ResourceBoneShield"],
									position = {
										relativeToName = L["PositionCenter"],
										relativeTo = "CENTER",
										xPos = 0,
										relativeToFrameName = L["BoneShieldContainer"],
										yPos = 0,
										relativeToFrame = "Container::boneShield",
									},
									fontJustifyHorizontal = "CENTER",
									useDefaultFontSize = true,
									color = { color = "FFFFFFFF" },
									enabled = true,
								})
							end
						end
					end

					-- Migrate Evoker Augmentation: add Ebon Might bar settings and default bar text
					if className == "evoker" and specName == "augmentation" then
						if not specSettings.bars then
							specSettings.bars = {}
						end
						if not specSettings.bars.ebonMight then
							specSettings.bars.ebonMight = TRB.Functions.Settings:DefaultEbonMightBarDimensions()
						end

						if specSettings.colors then
							specSettings.colors.bars = specSettings.colors.bars or {}

							-- Migrate mana-bar Ebon Might colors into the new ebonMight bar colors BEFORE
							-- applying defaults, so user customizations are preserved and defaults only
							-- fill in what the migration didn't provide.
							local manaBarColors = specSettings.colors.bar
							if not specSettings.colors.bars.ebonMight then
								specSettings.colors.bars.ebonMight = {}
							end
							local ebonMightBarColors = specSettings.colors.bars.ebonMight

							if manaBarColors then
								if not ebonMightBarColors.endingSoon and manaBarColors.ebonMightEnd then
									local endingSoonEnabled = manaBarColors.ebonMightEnd.enabled
									if endingSoonEnabled == nil then endingSoonEnabled = true end
									ebonMightBarColors.endingSoon = { color = manaBarColors.ebonMightEnd.color, enabled = endingSoonEnabled }
								end
								if not ebonMightBarColors.wontExtend and manaBarColors.ebonMightDropDuringCast then
									local wontExtendEnabled = manaBarColors.ebonMightDropDuringCast.enabled
									if wontExtendEnabled == nil then wontExtendEnabled = true end
									ebonMightBarColors.wontExtend = { color = manaBarColors.ebonMightDropDuringCast.color, enabled = wontExtendEnabled }
								end
								if not ebonMightBarColors.bar and manaBarColors.ebonMight then
									ebonMightBarColors.bar = { color = manaBarColors.ebonMight.color }
								end
							end

							-- Backfill any keys the migration didn't cover with defaults
							local defaults = TRB.Functions.Settings:DefaultEbonMightBarColors()
							for k, v in pairs(defaults) do
								if ebonMightBarColors[k] == nil then
									ebonMightBarColors[k] = v
								end
							end
						end

						if specSettings.textures and not specSettings.textures.ebonMightBar then
							local ebonMightTextures = TRB.Functions.Settings:DefaultCustomBarTextures()
							specSettings.textures.ebonMightBar = ebonMightTextures.bar
							specSettings.textures.ebonMightBarName = ebonMightTextures.barName
							specSettings.textures.ebonMightBorder = ebonMightTextures.border
							specSettings.textures.ebonMightBorderName = ebonMightTextures.borderName
							specSettings.textures.ebonMightBackground = ebonMightTextures.background
							specSettings.textures.ebonMightBackgroundName = ebonMightTextures.backgroundName
						end

						if not specSettings.displayBar then
							specSettings.displayBar = {}
						end
						if not specSettings.displayBar.ebonMight then
							local visSource = nil
							local coreSettings = TwintopInsanityBarSettings.core
							local globalAug = coreSettings and coreSettings.global and coreSettings.global.evoker and coreSettings.global.evoker.augmentation
							if globalAug and globalAug.displayBar == true and coreSettings.displayBar and coreSettings.displayBar.secondary then
								local gs = coreSettings.displayBar.secondary
								visSource = {
									neverShow = gs.neverShow,
									alwaysShow = gs.alwaysShow,
									smooth = true,
									activeAlpha = gs.activeAlpha,
									inactiveAlpha = gs.inactiveAlpha,
									fadeDuration = gs.fadeDuration,
									fadeDelay = gs.fadeDelay,
									conditions = {},
									hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(),
								}
								if gs.conditions then
									for ck, cv in pairs(gs.conditions) do
										visSource.conditions[ck] = cv
									end
								end
								if gs.hideConditions then
									for ck, cv in pairs(gs.hideConditions) do
										visSource.hideConditions[ck] = cv
									end
								end
							elseif specSettings.displayBar.secondary then
								visSource = TRB.Functions.Table:Merge({}, specSettings.displayBar.secondary)
								visSource.smooth = true
							end

							if visSource then
								specSettings.displayBar.ebonMight = visSource
							else
								specSettings.displayBar.ebonMight = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions(), smooth = true, activeAlpha = 100, inactiveAlpha = 0, fadeDuration = 0, fadeDelay = 0 }
							end
						end

						if specSettings.colors and specSettings.colors.bar and specSettings.colors.bar.ebonMightEnd and specSettings.colors.bar.ebonMightEnd.enabled == nil then
							local endOfEnabled = specSettings.endOf and specSettings.endOf.ebonMight and specSettings.endOf.ebonMight.enabled
							if endOfEnabled == nil then endOfEnabled = true end
							specSettings.colors.bar.ebonMightEnd.enabled = endOfEnabled
						end

						if specSettings.displayText and specSettings.displayText.barText then
							local hasEbonMightBarText = false
							for _, entry in ipairs(specSettings.displayText.barText) do
								if entry.position and entry.position.relativeToFrame == "EbonMightBar" then
									hasEbonMightBarText = true
									break
								end
							end
							if not hasEbonMightBarText then
								table.insert(specSettings.displayText.barText, {
									useDefaultFontColor = false,
									useDefaultFontOutline = false,
									useDefaultFontShadow = false,
									fontOutline = "OUTLINE",
									fontOutlineName = L["FontOutlineOutline"],
									fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
									useDefaultFontFace = false,
									useDefaultFontSize = false,
									enabled = true,
									name = L["PositionMiddle"],
									guid = TRB.Functions.String:Guid(),
									text = "{$ebonMightTime}[$ebonMightTime]",
									fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
									fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
									fontJustifyHorizontal = "CENTER",
									fontJustifyHorizontalName = L["PositionCenter"],
									fontSize = 14,
									color = { color = "FFFFFFFF" },
									position = {
										xPos = 0,
										yPos = 0,
										relativeTo = "CENTER",
										relativeToName = L["PositionCenter"],
										relativeToFrame = "EbonMightBar",
										relativeToFrameName = L["EbonMightBar"],
									},
								})
							end
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

	-- Evoker Devastation essenceBurst.targets migration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.devastation ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors.bar ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors.bar.essenceBurst ~= nil and
		TwintopInsanityBarSettings.evoker.devastation.colors.bar.essenceBurst.targets == nil then
		local eb = TwintopInsanityBarSettings.evoker.devastation.colors.bar.essenceBurst
		local enabled = eb.enabled
		if enabled == nil then enabled = true end
		eb.targets = {
			manaBar = { border = enabled },
			essences = { border = false },
		}
	end

	-- Evoker Preservation essenceBurst.targets migration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.preservation ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors.bar ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors.bar.essenceBurst ~= nil and
		TwintopInsanityBarSettings.evoker.preservation.colors.bar.essenceBurst.targets == nil then
		local eb = TwintopInsanityBarSettings.evoker.preservation.colors.bar.essenceBurst
		local enabled = eb.enabled
		if enabled == nil then enabled = true end
		eb.targets = {
			manaBar = { border = enabled },
			essences = { border = false },
		}
	end

	-- Evoker Augmentation essenceBurst.targets migration
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.evoker ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors.bar ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors.bar.essenceBurst ~= nil and
		TwintopInsanityBarSettings.evoker.augmentation.colors.bar.essenceBurst.targets == nil then
		local eb = TwintopInsanityBarSettings.evoker.augmentation.colors.bar.essenceBurst
		local enabled = eb.enabled
		if enabled == nil then enabled = true end
		eb.targets = {
			manaBar = { border = enabled },
			essences = { border = false },
			ebonMight = { border = false },
		}
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
		if type(bar.infusionOfLight) == "string" then
			local enabled = bar.infusionOfLightEnabled
			if enabled == nil then enabled = true end
			bar.infusionOfLight = { color = bar.infusionOfLight, enabled = enabled }
			bar.infusionOfLightEnabled = nil
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
		if cp.fiveStack == nil then
			cp.fiveStack = { color = "FF00B400" }
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
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
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
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
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
		if cp.second == nil then
			cp.second = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
		end
		if cp.third == nil then
			cp.third = { color = (type(cp.base) == "table" and cp.base.color) or "FF8788EE" }
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

	-- Warrior Fury comboPoints migration: normalize old format, then migrate to colors.bars.whirlwind
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors ~= nil and
		TwintopInsanityBarSettings.warrior.fury.colors.comboPoints ~= nil then
		local cp = TwintopInsanityBarSettings.warrior.fury.colors.comboPoints
		-- Normalize: ensure secondary and zeroStackBackground exist (old->intermediate format)
		if cp.secondary == nil and cp.base ~= nil then
			cp.secondary = { color = cp.base.color }
		end
		if cp.zeroStackBackground == nil then
			cp.zeroStackBackground = { color = "B3FF5E5E", enabled = true }
		end

		-- Migrate colors.comboPoints -> colors.bars.whirlwind
		local furySettings = TwintopInsanityBarSettings.warrior.fury
		furySettings.colors.bars = furySettings.colors.bars or {}
		if not furySettings.colors.bars.whirlwind then
			-- Pull sameColor from the dimensions table (comboPoints.sameColor)
			local sameColor = false
			if furySettings.comboPoints and furySettings.comboPoints.sameColor ~= nil then
				sameColor = furySettings.comboPoints.sameColor
			end

			furySettings.colors.bars.whirlwind = {
				border = cp.border or { color = "FFFFD300" },
				background = cp.background or { color = "66000000" },
				sameColor = sameColor,
				nodeColors = {
					charge1 = { color = cp.base and cp.base.color or "FFFFFFAA" },
					charge2 = { color = cp.secondary and cp.secondary.color or "FFFFFF00" },
					charge3 = { color = cp.penultimate and cp.penultimate.color or "FFFF9900" },
					charge4 = { color = cp.final and cp.final.color or "FFFF0000" },
				},
				zeroStackBackground = cp.zeroStackBackground or { color = "B3FF5E5E", enabled = true },
			}
			furySettings.colors.comboPoints = nil
		end

		-- Remove sameColor from comboPoints dimensions (now lives in colors.bars.whirlwind)
		if furySettings.comboPoints then
			furySettings.comboPoints.sameColor = nil
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

		--- Determines if the secondary bar should default to smooth animation for a given class/spec.
		--- Only Demon Hunter Vengeance and Devourer have continuous secondary bars (Soul Fragments).
		---@param className string # The lowercase class name (e.g., "demonhunter")
		---@param specName string # The lowercase spec name (e.g., "vengeance")
		---@return boolean # True if the secondary bar should use smooth animation by default
		local function IsSecondarySmoothByDefault(className, specName)
			if className == "demonhunter" and (specName == "vengeance" or specName == "devourer") then
				return true
			end
			return false
		end

		--- Determines the smooth animation default for a given displayBar visibility key.
		--- Primary, health, mana, stagger, defensives, and utility bars inherit the global smooth setting;
		--- secondary bars default to false unless the spec uses a continuous secondary bar.
		---@param key string # The displayBar key (e.g., "primary", "secondary", "health")
		---@param className string # The lowercase class name
		---@param specName string # The lowercase spec name
		---@param oldSmooth boolean? # The legacy global smoothBarValueUpdates setting
		---@return boolean # Whether smooth animation should be enabled for this bar key
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

		--- Migrates displayBar entries from plain string visibility values to table format { visibility, smooth }.
		---@param displayBar table? # The displayBar settings table to migrate in-place
		---@param className string # The lowercase class name (used for smooth defaults)
		---@param specName string # The lowercase spec name (used for smooth defaults)
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
		--- Migrates displayBar entries from { visibility, smooth } format to conditions-based format
		--- ({ neverShow, conditions = {}, smooth }). Also strips the deprecated "dragonriding" key.
		---@param displayBar table? # The displayBar settings table to migrate in-place
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
		--- Migrates Phase 1 conditions-based displayBar entries to Phase 2 by adding an explicit alwaysShow flag.
		--- Entries with empty conditions and neverShow=false are treated as "always show".
		---@param displayBar table? # The displayBar settings table to migrate in-place
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

		--- Renames isMounted to isMountedAny and backfills new Phase 2 condition keys with false defaults.
		---@param displayBar table? # The displayBar settings table to migrate in-place
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
		--- Backfills activeAlpha, inactiveAlpha, fadeDuration, and fadeDelay for existing displayBar entries.
		--- Defaults preserve current behavior: active=100%, inactive=0%, fade=0s (instant), delay=0s.
		---@param displayBar table? # The displayBar settings table to migrate in-place
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

	-- Phase 3b: Backfill resourceConditionType, resourceConditionOperator, and resourceConditionValue
	-- for existing displayBar entries. Defaults preserve current behavior: no threshold active.
	do
		--- Backfills resource condition fields for existing displayBar entries.
		---@param displayBar table? # The displayBar settings table to migrate in-place
		local function MigrateResourceConditionSettings(displayBar)
			if displayBar == nil then
				return
			end
			for _, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.conditions ~= nil then
					if entry.resourceConditionType == nil then
						entry.resourceConditionType = "none"
					end
					if entry.resourceConditionOperator == nil then
						entry.resourceConditionOperator = ">="
					end
					-- Collapse unsupported operators to >= or <=
					local op = entry.resourceConditionOperator
					if op == ">" or op == "==" then
						entry.resourceConditionOperator = ">="
					elseif op == "<" or op == "!=" then
						entry.resourceConditionOperator = "<="
					end
					if entry.resourceConditionValue == nil then
						entry.resourceConditionValue = 0
					end
				end
			end
		end

		-- Migrate core.displayBar
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateResourceConditionSettings(TwintopInsanityBarSettings.core.displayBar)
		end

		-- Migrate all class/spec displayBar settings
		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateResourceConditionSettings(specSettings.displayBar)
					end
				end
			end
		end
	end

	-- Backfill spec-level extra visibility threshold definitions for secondary Mana Bars.
	do
		---@param specSettings table? # Spec settings table to update in-place
		local function MigrateManaBarVisibilityThresholds(specSettings)
			if specSettings == nil then
				return
			end

			local defaults = TRB.Functions.Settings:LoadDefaultManaBarVisibilityThresholds()
			specSettings.barVisibilityThresholds = specSettings.barVisibilityThresholds or {}
			for key, defaultValue in pairs(defaults) do
				if specSettings.barVisibilityThresholds[key] == nil then
					specSettings.barVisibilityThresholds[key] = {}
				end
				for settingKey, settingValue in pairs(defaultValue) do
					if specSettings.barVisibilityThresholds[key][settingKey] == nil then
						specSettings.barVisibilityThresholds[key][settingKey] = settingValue
					end
				end
			end
		end

		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.priest then
			MigrateManaBarVisibilityThresholds(TwintopInsanityBarSettings.priest.shadow)
		end
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid then
			MigrateManaBarVisibilityThresholds(TwintopInsanityBarSettings.druid.balance)
		end
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.shaman then
			MigrateManaBarVisibilityThresholds(TwintopInsanityBarSettings.shaman.elemental)
		end
	end

	-- Backfill per-bar hard-hide conditions. These replace the old global pet battle
	-- and taxi force-hide path, and default to enabled for all bars.
	do
		---@param displayBar table? # The displayBar settings table to migrate in-place
		local function MigrateHideConditionSettings(displayBar)
			if displayBar == nil then
				return
			end
			for _, entry in pairs(displayBar) do
				if type(entry) == "table" and entry.conditions ~= nil then
					local defaults = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()
					if entry.hideConditions == nil then
						entry.hideConditions = defaults
					else
						---@type table<string, boolean>
						local hideConditions = entry.hideConditions
						if hideConditions.isSteadyFlight ~= nil and hideConditions.isMountedFlying == nil then
							hideConditions.isMountedFlying = hideConditions.isSteadyFlight
							hideConditions.isSteadyFlight = nil
						end
						for key, value in pairs(defaults) do
							if hideConditions[key] == nil then
								hideConditions[key] = value
							end
						end
					end
				end
			end
		end

		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayBar then
			MigrateHideConditionSettings(TwintopInsanityBarSettings.core.displayBar)
		end

		for _, className in ipairs(classes) do
			if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
				for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
					if specSettings and type(specSettings) == "table" and specSettings.displayBar then
						MigrateHideConditionSettings(specSettings.displayBar)
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
						matchHeight = false,
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
					matchHeight = false,
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
		--- Migrates health bar overlay settings (absorb and incoming heal) from displayBar.health to colors.healthBar.
		--- Moves showAbsorb/absorbMode to colors.healthBar.absorb and showIncomingHeal/incomingHealMode to colors.healthBar.incomingHeal.
		---@param settings table? # A spec's settings table containing displayBar and colors sub-tables
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

	-- Migrate fontOutline and fontShadow for displayText defaults and bar text entries
	-- Core (global) displayText defaults
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.core and TwintopInsanityBarSettings.core.displayText then
		local dt = TwintopInsanityBarSettings.core.displayText
		if dt.default and dt.default.fontOutline == nil then
			dt.default.fontOutline = "OUTLINE"
			dt.default.fontOutlineName = L["FontOutlineOutline"]
			dt.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		if dt.barText then
			for _, entry in ipairs(dt.barText) do
				if entry.fontOutline == nil then
					entry.fontOutline = "OUTLINE"
					entry.fontOutlineName = L["FontOutlineOutline"]
				end
				if entry.fontShadow == nil then
					entry.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
				end
				if entry.useDefaultFontOutline == nil then
					entry.useDefaultFontOutline = false
				end
				if entry.useDefaultFontShadow == nil then
					entry.useDefaultFontShadow = false
				end
			end
		end
	end
	-- Per-spec displayText defaults and bar text entries
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for specName, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if type(specSettings) == "table" and specSettings.displayText then
					local dt = specSettings.displayText
					if dt.default and dt.default.fontOutline == nil then
						dt.default.fontOutline = "OUTLINE"
						dt.default.fontOutlineName = L["FontOutlineOutline"]
						dt.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
					end
					if dt.barText then
						for _, entry in ipairs(dt.barText) do
							if entry.fontOutline == nil then
								entry.fontOutline = "OUTLINE"
								entry.fontOutlineName = L["FontOutlineOutline"]
							end
							if entry.fontShadow == nil then
								entry.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
							end
							if entry.useDefaultFontOutline == nil then
								entry.useDefaultFontOutline = false
							end
							if entry.useDefaultFontShadow == nil then
								entry.useDefaultFontShadow = false
							end
						end
					end
				end
			end
		end
	end

	-- Migrate Shadow Priest indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.priest and TwintopInsanityBarSettings.priest.shadow then
		local shadow = TwintopInsanityBarSettings.priest.shadow
		if shadow.colors and shadow.colors.bar and shadow.colors.bar.instantMindBlast ~= nil
			and type(shadow.colors.bar.instantMindBlast) == "table"
			and (shadow.colors.shared == nil or shadow.colors.shared.indicatorColors == nil) then

			shadow.colors.shared = shadow.colors.shared or {}
			shadow.colors.shared.nodeOrder = {
				"instantMindBlast",
				"voidformEnd",
				"shadowWordMadnessUsable",
				"voidform",
				"mindDevourer",
				"entropicRift",
				"borderMindFlayInsanity",
			}
			shadow.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			shadow.colors.shared.indicatorColors = {}
			local ic = shadow.colors.shared.indicatorColors
			local bar = shadow.colors.bar

			-- Helper to build targets with a single default element
			local function MakeTargets(barKey, elemKey)
				local t = {
					insanityBar = { bar = false, border = false, background = false },
					manaBar = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			-- Bar indicators
			ic.instantMindBlast = {
				color = bar.instantMindBlast and bar.instantMindBlast.color or "FFC2A3E0",
				enabled = bar.instantMindBlast and bar.instantMindBlast.enabled ~= false,
				targets = MakeTargets("insanityBar", "bar"),
			}
			ic.voidformEnd = {
				color = bar.voidformEnd and bar.voidformEnd.color or "FFFF0000",
				enabled = shadow.endOf and shadow.endOf.voidform and shadow.endOf.voidform.enabled ~= false,
				targets = MakeTargets("insanityBar", "bar"),
			}
			ic.shadowWordMadnessUsable = {
				color = bar.shadowWordMadnessUsable and bar.shadowWordMadnessUsable.color or "FF5C2F89",
				enabled = bar.shadowWordMadnessUsable and bar.shadowWordMadnessUsable.enabled ~= false,
				targets = MakeTargets("insanityBar", "bar"),
			}
			ic.voidform = {
				color = bar.voidform and bar.voidform.color or "FF431863",
				enabled = bar.voidform and bar.voidform.enabled ~= false,
				targets = MakeTargets("insanityBar", "bar"),
			}

			-- Border indicators
			ic.mindDevourer = {
				color = bar.mindDevourer and bar.mindDevourer.color or "FF00C3FF",
				enabled = bar.mindDevourer and bar.mindDevourer.enabled ~= false,
				targets = MakeTargets("insanityBar", "border"),
			}
			ic.entropicRift = {
				color = bar.entropicRift and bar.entropicRift.color or "FF8A004C",
				enabled = bar.entropicRift and bar.entropicRift.enabled ~= false,
				targets = MakeTargets("insanityBar", "border"),
			}
			ic.borderMindFlayInsanity = {
				color = bar.borderMindFlayInsanity and bar.borderMindFlayInsanity.color or "FF00FF00",
				enabled = bar.borderMindFlayInsanity and bar.borderMindFlayInsanity.enabled ~= false,
				targets = MakeTargets("insanityBar", "border"),
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("insanityBar", "border"),
			}

			-- Clean up old keys from colors.bar
			bar.instantMindBlast = nil
			bar.voidform = nil
			bar.voidformEnd = nil
			bar.shadowWordMadnessUsable = nil
			bar.borderMindFlayInsanity = nil
			bar.entropicRift = nil
			bar.mindDevourer = nil
			bar.borderOvercap = nil

			-- Move endOf.voidform.enabled to the indicator; leave timing fields in place
			if shadow.endOf and shadow.endOf.voidform then
				shadow.endOf.voidform.enabled = nil
			end
		end
	end

	-- Migrate gradient indicators out of nodeOrder into gradientOrder
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.priest and TwintopInsanityBarSettings.priest.shadow then
		local shadow = TwintopInsanityBarSettings.priest.shadow
		if shadow.colors and shadow.colors.shared and shadow.colors.shared.nodeOrder and not shadow.colors.shared.gradientOrder then
			local newNodeOrder = {}
			local newGradientOrder = {}
			local ic = shadow.colors.shared.indicatorColors or {}
			for _, key in ipairs(shadow.colors.shared.nodeOrder) do
				if ic[key] and ic[key].isGradient then
					table.insert(newGradientOrder, key)
				else
					table.insert(newNodeOrder, key)
				end
			end
			shadow.colors.shared.nodeOrder = newNodeOrder
			shadow.colors.shared.gradientOrder = newGradientOrder
		end
	end

	-- Migrate Holy Priest indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.priest and TwintopInsanityBarSettings.priest.holy then
		local holy = TwintopInsanityBarSettings.priest.holy
		if holy.colors and holy.colors.bar and holy.colors.bar.benediction ~= nil
			and type(holy.colors.bar.benediction) == "table"
			and (holy.colors.shared == nil or holy.colors.shared.indicatorColors == nil) then

			holy.colors.shared = holy.colors.shared or {}
			holy.colors.shared.nodeOrder = {
				"benediction",
				"holyWordSerenity",
				"holyWordSanctify",
				"holyWordChastise",
				"apotheosisEnd",
				"apotheosis",
				"surgeOfLight",
				"lightweaver",
			}
			holy.colors.shared.gradientOrder = {}
			holy.colors.shared.indicatorColors = {}
			local ic = holy.colors.shared.indicatorColors
			local bar = holy.colors.bar

			-- Helper to build targets with a single default element
			local function MakeTargets(barKey, elemKey)
				local t = {
					manaBar = { bar = false, border = false, background = false },
					holyWordsBar = { bar = false, border = false, background = false },
					lightweaverBar = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			-- Determine if old completeCooldown was enabled (for HW bar targeting)
			local hwColors = holy.colors.bars and holy.colors.bars.holyWords
			local hwCCEnabled = hwColors and hwColors.completeCooldown and hwColors.completeCooldown.enabled ~= false

			-- Bar indicators
			local benedictionTargets = MakeTargets("manaBar", "bar")
			-- Also migrate the legacy Lightweaver background benediction indicator
			local lwColors = holy.colors.bars and holy.colors.bars.lightweaver
			if lwColors and lwColors.benediction and lwColors.benediction.enabled then
				benedictionTargets.lightweaverBar.background = true
			end
			ic.benediction = {
				color = bar.benediction and bar.benediction.color or "FFC4933F",
				enabled = bar.benediction and bar.benediction.enabled ~= false,
				targets = benedictionTargets,
			}
			local serenityTargets = MakeTargets("manaBar", "bar")
			if hwCCEnabled then serenityTargets.holyWordsBar.bar = true end
			ic.holyWordSerenity = {
				color = bar.holyWordSerenity and bar.holyWordSerenity.color or "FF00FF00",
				enabled = bar.holyWordSerenity and bar.holyWordSerenity.enabled ~= false,
				targets = serenityTargets,
			}
			local sanctifyTargets = MakeTargets("manaBar", "bar")
			if hwCCEnabled then sanctifyTargets.holyWordsBar.bar = true end
			ic.holyWordSanctify = {
				color = bar.holyWordSanctify and bar.holyWordSanctify.color or "FF55FF55",
				enabled = bar.holyWordSanctify and bar.holyWordSanctify.enabled ~= false,
				targets = sanctifyTargets,
			}
			local chastiseEnabled = bar.holyWordChastise and bar.holyWordChastise.enabled ~= false
			local chastiseTargets = chastiseEnabled and MakeTargets("manaBar", "bar") or MakeTargets()
			if hwCCEnabled and chastiseEnabled then chastiseTargets.holyWordsBar.bar = true end
			ic.holyWordChastise = {
				color = bar.holyWordChastise and bar.holyWordChastise.color or "FFAAFFAA",
				enabled = chastiseEnabled,
				targets = chastiseTargets,
			}
			ic.apotheosisEnd = {
				color = bar.apotheosisEnd and bar.apotheosisEnd.color or "FFFF0000",
				enabled = holy.endOf and holy.endOf.apotheosis and holy.endOf.apotheosis.enabled ~= false,
				targets = MakeTargets("manaBar", "bar"),
			}
			ic.apotheosis = {
				color = bar.apotheosis and bar.apotheosis.color or "FFFADA5E",
				enabled = bar.apotheosis and bar.apotheosis.enabled ~= false,
				targets = MakeTargets("manaBar", "bar"),
			}

			-- Border indicators
			ic.surgeOfLight = {
				color = bar.surgeOfLight and bar.surgeOfLight.color or "FFFCE58E",
				enabled = bar.surgeOfLight and bar.surgeOfLight.enabled ~= false,
				targets = MakeTargets("manaBar", "border"),
			}
			ic.lightweaver = {
				color = bar.lightweaver and bar.lightweaver.color or "FF00FFFF",
				enabled = bar.lightweaver and bar.lightweaver.enabled ~= false,
				targets = MakeTargets("manaBar", "border"),
			}

			-- Clean up old keys from colors.bar
			bar.benediction = nil
			bar.holyWordSerenity = nil
			bar.holyWordSanctify = nil
			bar.holyWordChastise = nil
			bar.apotheosis = nil
			bar.apotheosisEnd = nil
			bar.surgeOfLight = nil
			bar.lightweaver = nil

			-- Move endOf.apotheosis.enabled to the indicator; leave timing fields in place
			if holy.endOf and holy.endOf.apotheosis then
				holy.endOf.apotheosis.enabled = nil
			end

			-- Clean up completeCooldown from holyWords bar colors
			if hwColors then
				hwColors.completeCooldown = nil
			end

			-- Clean up benediction from lightweaver bar colors
			if lwColors then
				lwColors.benediction = nil
			end
		end

		-- Migrate completeCooldown indicator into per-HW indicators (for users who already have indicatorColors)
		if holy.colors and holy.colors.shared and holy.colors.shared.indicatorColors
			and holy.colors.shared.indicatorColors.completeCooldown then
			local ic = holy.colors.shared.indicatorColors
			local cc = ic.completeCooldown
			local ccTargetsHW = cc.targets and cc.targets.holyWordsBar

			-- Transfer holyWordsBar targets to per-HW indicators
			if ccTargetsHW then
				for _, key in ipairs({ "holyWordSerenity", "holyWordSanctify", "holyWordChastise" }) do
					if ic[key] then
						ic[key].targets = ic[key].targets or {}
						ic[key].targets.holyWordsBar = ic[key].targets.holyWordsBar or { bar = false, border = false, background = false }
						for elem, val in pairs(ccTargetsHW) do
							if val then
								ic[key].targets.holyWordsBar[elem] = true
							end
						end
					end
				end
			end

			-- Remove completeCooldown
			ic.completeCooldown = nil

			-- Remove from nodeOrder
			if holy.colors.shared.nodeOrder then
				local newOrder = {}
				for _, k in ipairs(holy.colors.shared.nodeOrder) do
					if k ~= "completeCooldown" then
						newOrder[#newOrder + 1] = k
					end
				end
				holy.colors.shared.nodeOrder = newOrder
			end
		end
	end

	-- Migrate Havoc Demon Hunter indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.demonhunter and TwintopInsanityBarSettings.demonhunter.havoc then
		local havoc = TwintopInsanityBarSettings.demonhunter.havoc
		if havoc.colors and havoc.colors.bar and havoc.colors.bar.metamorphosis ~= nil
			and type(havoc.colors.bar.metamorphosis) == "table"
			and (havoc.colors.shared == nil or havoc.colors.shared.indicatorColors == nil) then

			havoc.colors.shared = havoc.colors.shared or {}
			havoc.colors.shared.nodeOrder = {
				"metamorphosisEnd",
				"metamorphosis",
			}
			havoc.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			havoc.colors.shared.indicatorColors = {}
			local ic = havoc.colors.shared.indicatorColors
			local bar = havoc.colors.bar

			-- Helper to build targets with a single default element
			local function MakeTargets(elemKey)
				local t = {
					furyBar = { bar = false, border = false, background = false },
				}
				t.furyBar[elemKey] = true
				return t
			end

			-- Bar indicators
			ic.metamorphosisEnd = {
				color = bar.metamorphosisEnd and bar.metamorphosisEnd.color or "FFFF0000",
				enabled = havoc.endOf and havoc.endOf.metamorphosis and havoc.endOf.metamorphosis.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.metamorphosis = {
				color = bar.metamorphosis and bar.metamorphosis.color or "FF67F100",
				enabled = bar.metamorphosis and bar.metamorphosis.enabled ~= false,
				targets = MakeTargets("bar"),
			}

			-- Border gradient indicator
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("border"),
			}

			-- Clean up old keys from colors.bar
			bar.metamorphosis = nil
			bar.metamorphosisEnd = nil
			bar.borderOvercap = nil

			-- Move endOf.metamorphosis.enabled to the indicator; leave timing fields in place
			if havoc.endOf and havoc.endOf.metamorphosis then
				havoc.endOf.metamorphosis.enabled = nil
			end
		end
	end

	-- Migrate Vengeance Demon Hunter indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.demonhunter and TwintopInsanityBarSettings.demonhunter.vengeance then
		local vengeance = TwintopInsanityBarSettings.demonhunter.vengeance
		if vengeance.colors and vengeance.colors.bar and vengeance.colors.bar.metamorphosis ~= nil
			and type(vengeance.colors.bar.metamorphosis) == "table"
			and (vengeance.colors.shared == nil or vengeance.colors.shared.indicatorColors == nil) then

			vengeance.colors.shared = vengeance.colors.shared or {}
			vengeance.colors.shared.nodeOrder = {
				"metamorphosisEnd",
				"metamorphosis",
			}
			vengeance.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			vengeance.colors.shared.indicatorColors = {}
			local ic = vengeance.colors.shared.indicatorColors
			local bar = vengeance.colors.bar

			-- Helper to build targets with a single default element
			local function MakeTargets(elemKey)
				local t = {
					furyBar = { bar = false, border = false, background = false },
					soulFragmentsBar = { bar = false, border = false, background = false },
				}
				t.furyBar[elemKey] = true
				return t
			end

			-- Bar indicators
			ic.metamorphosisEnd = {
				color = bar.metamorphosisEnd and bar.metamorphosisEnd.color or "FFFF0000",
				enabled = vengeance.endOf and vengeance.endOf.metamorphosis and vengeance.endOf.metamorphosis.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.metamorphosis = {
				color = bar.metamorphosis and bar.metamorphosis.color or "FF67F100",
				enabled = bar.metamorphosis and bar.metamorphosis.enabled ~= false,
				targets = MakeTargets("bar"),
			}

			-- Border gradient indicator
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("border"),
			}

			-- Clean up old keys from colors.bar
			bar.metamorphosis = nil
			bar.metamorphosisEnd = nil
			bar.borderOvercap = nil

			-- Move endOf.metamorphosis.enabled to the indicator; leave timing fields in place
			if vengeance.endOf and vengeance.endOf.metamorphosis then
				vengeance.endOf.metamorphosis.enabled = nil
			end
		end
	end

	-- Migrate Devourer Demon Hunter indicator colors from colors.bar.* and colors.comboPoints.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.demonhunter and TwintopInsanityBarSettings.demonhunter.devourer then
		local devourer = TwintopInsanityBarSettings.demonhunter.devourer
		if devourer.colors and devourer.colors.bar and devourer.colors.bar.voidMetamorphosis ~= nil
			and type(devourer.colors.bar.voidMetamorphosis) == "table"
			and (devourer.colors.shared == nil or devourer.colors.shared.indicatorColors == nil) then

			devourer.colors.shared = devourer.colors.shared or {}
			devourer.colors.shared.nodeOrder = {
				"voidMetamorphosisReady",
				"collapsingStarReady",
				"voidMetamorphosis",
				"voidRayReady",
			}
			devourer.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			devourer.colors.shared.indicatorColors = {}
			local ic = devourer.colors.shared.indicatorColors
			local bar = devourer.colors.bar
			local cp = devourer.colors.comboPoints

			-- Helper to build targets with a single default element on a specific bar
			local function MakeTargets(barKey, elemKey)
				local t = {
					furyBar = { bar = false, border = false, background = false },
					soulFragmentsBar = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			-- Fury bar indicators
			ic.voidMetamorphosis = {
				color = bar.voidMetamorphosis and bar.voidMetamorphosis.color or "FF431863",
				enabled = bar.voidMetamorphosis and bar.voidMetamorphosis.enabled ~= false,
				targets = MakeTargets("furyBar", "bar"),
			}

			-- Border gradient indicator
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("furyBar", "border"),
			}

			-- Soul Fragments bar indicators
			ic.voidMetamorphosisReady = {
				color = cp and cp.voidMetamorphosisReady and cp.voidMetamorphosisReady.color or "FF431863",
				enabled = cp and cp.voidMetamorphosisReady and cp.voidMetamorphosisReady.enabled ~= false,
				targets = MakeTargets("soulFragmentsBar", "bar"),
			}
			ic.collapsingStarReady = {
				color = cp and cp.collapsingStarReady and cp.collapsingStarReady.color or "FF431863",
				enabled = cp and cp.collapsingStarReady and cp.collapsingStarReady.enabled ~= false,
				targets = MakeTargets("soulFragmentsBar", "bar"),
			}

			-- New indicator (no legacy key to migrate from)
			ic.voidRayReady = {
				color = "FF008B8B",
				enabled = true,
				targets = MakeTargets("furyBar", "bar"),
			}

			-- Clean up old keys from colors.bar
			bar.voidMetamorphosis = nil
			bar.borderOvercap = nil

			-- Clean up old keys from colors.comboPoints
			if cp then
				cp.voidMetamorphosisReady = nil
				cp.collapsingStarReady = nil
			end
		end

		-- Add voidRayReady indicator for users who already migrated to shared indicators but don't have this new entry
		if devourer.colors and devourer.colors.shared and devourer.colors.shared.indicatorColors
			and devourer.colors.shared.indicatorColors.voidRayReady == nil then
			devourer.colors.shared.indicatorColors.voidRayReady = {
				color = "FF008B8B",
				enabled = true,
				targets = {
					furyBar = { bar = true, border = false, background = false },
					soulFragmentsBar = { bar = false, border = false, background = false },
				},
			}
			-- Append to nodeOrder at the end (lowest priority)
			table.insert(devourer.colors.shared.nodeOrder, "voidRayReady")
		end
	end

	-- Migrate Evoker Devastation indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.evoker and TwintopInsanityBarSettings.evoker.devastation then
		local devastation = TwintopInsanityBarSettings.evoker.devastation
		if devastation.colors and devastation.colors.bar and devastation.colors.bar.dragonrage ~= nil
			and type(devastation.colors.bar.dragonrage) == "table"
			and (devastation.colors.shared == nil or devastation.colors.shared.indicatorColors == nil) then

			devastation.colors.shared = devastation.colors.shared or {}
			devastation.colors.shared.nodeOrder = { "dragonrageEnd", "dragonrage", "essenceBurst" }
			devastation.colors.shared.gradientOrder = {}
			devastation.colors.shared.indicatorColors = {}
			local ic = devastation.colors.shared.indicatorColors
			local bar = devastation.colors.bar

			local function MakeTargets(barKey, elemKey)
				local t = {
					manaBar = { bar = false, border = false, background = false },
					essences = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			ic.dragonrageEnd = {
				color = bar.dragonrageEnd and bar.dragonrageEnd.color or "FFFF0000",
				enabled = devastation.endOf and devastation.endOf.dragonrage and devastation.endOf.dragonrage.enabled ~= false,
				targets = MakeTargets("manaBar", "bar"),
			}
			ic.dragonrage = {
				color = bar.dragonrage and bar.dragonrage.color or "FFFF6B00",
				enabled = bar.dragonrage and bar.dragonrage.enabled ~= false,
				targets = MakeTargets("manaBar", "bar"),
			}
			ic.essenceBurst = {
				color = bar.essenceBurst and bar.essenceBurst.color or "FFFCE58E",
				enabled = bar.essenceBurst and bar.essenceBurst.enabled ~= false,
				targets = {
					manaBar = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.manaBar and bar.essenceBurst.targets.manaBar.border) or false, background = false },
					essences = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.essences and bar.essenceBurst.targets.essences.border) or false, background = false },
				},
			}

			-- Clean up old keys from colors.bar
			bar.dragonrage = nil
			bar.dragonrageEnd = nil
			bar.essenceBurst = nil

			-- Move endOf.dragonrage.enabled to the indicator; leave timing fields in place
			if devastation.endOf and devastation.endOf.dragonrage then
				devastation.endOf.dragonrage.enabled = nil
			end
		end
	end

	-- Migrate Evoker Preservation indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.evoker and TwintopInsanityBarSettings.evoker.preservation then
		local preservation = TwintopInsanityBarSettings.evoker.preservation
		if preservation.colors and preservation.colors.bar and preservation.colors.bar.essenceBurst ~= nil
			and type(preservation.colors.bar.essenceBurst) == "table"
			and (preservation.colors.shared == nil or preservation.colors.shared.indicatorColors == nil) then

			preservation.colors.shared = preservation.colors.shared or {}
			preservation.colors.shared.nodeOrder = { "innervate", "essenceBurst" }
			preservation.colors.shared.gradientOrder = {}
			preservation.colors.shared.indicatorColors = {}
			local ic = preservation.colors.shared.indicatorColors
			local bar = preservation.colors.bar

			local function MakeTargets(barKey, elemKey)
				local t = {
					manaBar = { bar = false, border = false, background = false },
					essences = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			ic.innervate = {
				color = bar.innervate and bar.innervate.color or "FF00FF00",
				enabled = bar.innervate and bar.innervate.enabled ~= false,
				targets = MakeTargets("manaBar", "bar"),
			}
			ic.essenceBurst = {
				color = bar.essenceBurst and bar.essenceBurst.color or "FFFCE58E",
				enabled = bar.essenceBurst and bar.essenceBurst.enabled ~= false,
				targets = {
					manaBar = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.manaBar and bar.essenceBurst.targets.manaBar.border) or false, background = false },
					essences = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.essences and bar.essenceBurst.targets.essences.border) or false, background = false },
				},
			}

			-- Clean up old keys from colors.bar
			bar.innervate = nil
			bar.essenceBurst = nil
		end
	end

	-- Migrate Evoker Augmentation indicator colors from colors.bar.* and colors.bars.ebonMight.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.evoker and TwintopInsanityBarSettings.evoker.augmentation then
		local augmentation = TwintopInsanityBarSettings.evoker.augmentation
		if augmentation.colors and augmentation.colors.bar and augmentation.colors.bar.ebonMight ~= nil
			and type(augmentation.colors.bar.ebonMight) == "table"
			and (augmentation.colors.shared == nil or augmentation.colors.shared.indicatorColors == nil) then

			augmentation.colors.shared = augmentation.colors.shared or {}
			augmentation.colors.shared.nodeOrder = { "ebonMightDropDuringCast", "ebonMightEnd", "ebonMight", "essenceBurst" }
			augmentation.colors.shared.gradientOrder = {}
			augmentation.colors.shared.indicatorColors = {}
			local ic = augmentation.colors.shared.indicatorColors
			local bar = augmentation.colors.bar
			local ebonMightBar = augmentation.colors.bars and augmentation.colors.bars.ebonMight

			local function MakeTargets(barKey, elemKey)
				local t = {
					manaBar = { bar = false, border = false, background = false },
					essences = { bar = false, border = false, background = false },
					ebonMight = { bar = false, border = false, background = false },
				}
				if t[barKey] then
					t[barKey][elemKey] = true
				end
				return t
			end

			-- ebonMightDropDuringCast: mana bar had enabled=false, EM bar wontExtend had enabled=true
			-- Use EM bar wontExtend.enabled as the indicator enabled state; keep manaBar target off by default
			ic.ebonMightDropDuringCast = {
				color = bar.ebonMightDropDuringCast and bar.ebonMightDropDuringCast.color or "FF550000",
				enabled = (ebonMightBar and ebonMightBar.wontExtend and ebonMightBar.wontExtend.enabled ~= false)
					or (bar.ebonMightDropDuringCast and bar.ebonMightDropDuringCast.enabled == true),
				targets = {
					manaBar = { bar = bar.ebonMightDropDuringCast and bar.ebonMightDropDuringCast.enabled == true, border = false, background = false },
					essences = { bar = false, border = false, background = false },
					ebonMight = { bar = ebonMightBar and ebonMightBar.wontExtend and ebonMightBar.wontExtend.enabled ~= false or false, border = false, background = false },
				},
			}

			-- ebonMightEnd: mana bar had enabled=false, EM bar endingSoon had enabled=true
			ic.ebonMightEnd = {
				color = bar.ebonMightEnd and bar.ebonMightEnd.color or "FFFF0000",
				enabled = (ebonMightBar and ebonMightBar.endingSoon and ebonMightBar.endingSoon.enabled ~= false)
					or (bar.ebonMightEnd and bar.ebonMightEnd.enabled == true),
				targets = {
					manaBar = { bar = bar.ebonMightEnd and bar.ebonMightEnd.enabled == true, border = false, background = false },
					essences = { bar = false, border = false, background = false },
					ebonMight = { bar = ebonMightBar and ebonMightBar.endingSoon and ebonMightBar.endingSoon.enabled ~= false or false, border = false, background = false },
				},
			}

			-- ebonMight (active): target mana bar and EM bar (EM bar was always visible in EM color when active)
			ic.ebonMight = {
				color = bar.ebonMight and bar.ebonMight.color or "FFFF9900",
				enabled = bar.ebonMight and bar.ebonMight.enabled == true,
				targets = {
					manaBar = { bar = bar.ebonMight and bar.ebonMight.enabled == true, border = false, background = false },
					essences = { bar = false, border = false, background = false },
					ebonMight = { bar = bar.ebonMight and bar.ebonMight.enabled == true, border = false, background = false },
				},
			}

			ic.essenceBurst = {
				color = bar.essenceBurst and bar.essenceBurst.color or "FFFCE58E",
				enabled = bar.essenceBurst and bar.essenceBurst.enabled ~= false,
				targets = {
					manaBar = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.manaBar and bar.essenceBurst.targets.manaBar.border) or false, background = false },
					essences = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.essences and bar.essenceBurst.targets.essences.border) or false, background = false },
					ebonMight = { bar = false, border = (bar.essenceBurst and bar.essenceBurst.targets and bar.essenceBurst.targets.ebonMight and bar.essenceBurst.targets.ebonMight.border) or false, background = false },
				},
			}

			-- Clean up old keys from colors.bar
			bar.ebonMight = nil
			bar.ebonMightEnd = nil
			bar.ebonMightDropDuringCast = nil
			bar.essenceBurst = nil

			-- Clean up old keys from colors.bars.ebonMight
			if ebonMightBar then
				ebonMightBar.endingSoon = nil
				ebonMightBar.wontExtend = nil
			end

			-- Move endOf.ebonMight.enabled to nil; timing fields stay
			if augmentation.endOf and augmentation.endOf.ebonMight then
				augmentation.endOf.ebonMight.enabled = nil
			end
		end
	end

	-- Migrate Balance Druid indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.balance then
		local balance = TwintopInsanityBarSettings.druid.balance
		if balance.colors and balance.colors.bar and balance.colors.bar.lunar ~= nil
			and type(balance.colors.bar.lunar) == "table"
			and (balance.colors.shared == nil or balance.colors.shared.indicatorColors == nil) then

			balance.colors.shared = balance.colors.shared or {}
			balance.colors.shared.nodeOrder = {
				"eclipseEnd",
				"celestial",
				"solar",
				"lunar",
			}
			balance.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			balance.colors.shared.indicatorColors = {}
			local ic = balance.colors.shared.indicatorColors
			local bar = balance.colors.bar

			local function MakeTargets(elemKey)
				local t = {
					astralPowerBar = { bar = false, border = false, background = false },
				}
				t.astralPowerBar[elemKey] = true
				return t
			end

			ic.eclipseEnd = {
				color = bar.eclipseEnd and bar.eclipseEnd.color or "FFFF0000",
				enabled = balance.endOf and balance.endOf.eclipse and balance.endOf.eclipse.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.celestial = {
				color = bar.celestial and bar.celestial.color or "FF4A95CE",
				enabled = bar.celestial and bar.celestial.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.solar = {
				color = bar.solar and bar.solar.color or "FFFFEE00",
				enabled = bar.solar and bar.solar.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.lunar = {
				color = bar.lunar and bar.lunar.color or "FF144D72",
				enabled = bar.lunar and bar.lunar.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("border"),
			}

			bar.lunar = nil
			bar.solar = nil
			bar.celestial = nil
			bar.eclipseEnd = nil
			bar.borderOvercap = nil

			if balance.endOf and balance.endOf.eclipse then
				balance.endOf.eclipse.enabled = nil
			end
		end
	end

	-- Migrate Feral Druid indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.feral then
		local feral = TwintopInsanityBarSettings.druid.feral
		if feral.colors and feral.colors.bar and feral.colors.bar.maxBite ~= nil
			and type(feral.colors.bar.maxBite) == "table"
			and (feral.colors.shared == nil or feral.colors.shared.indicatorColors == nil) then

			feral.colors.shared = feral.colors.shared or {}
			feral.colors.shared.nodeOrder = {
				"apexPredator",
				"ravage",
				"borderStealth",
			}
			feral.colors.shared.gradientOrder = {
				"maxBite",
				"borderOvercap",
			}
			feral.colors.shared.indicatorColors = {}
			local ic = feral.colors.shared.indicatorColors
			local bar = feral.colors.bar

			local function MakeTargets(elemKey)
				local t = {
					energyBar = { bar = false, border = false, background = false },
				}
				t.energyBar[elemKey] = true
				return t
			end

			ic.apexPredator = {
				color = bar.apexPredator and bar.apexPredator.color or "FFE75480",
				enabled = bar.apexPredator and bar.apexPredator.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.ravage = {
				color = "FFF4B183",
				enabled = true,
				targets = {
					comboPoints = { bar = true, border = false, background = false },
				},
			}
			ic.borderStealth = {
				color = bar.borderStealth and bar.borderStealth.color or "FF000000",
				enabled = bar.borderStealth and bar.borderStealth.enabled ~= false,
				targets = MakeTargets("border"),
			}
			ic.maxBite = {
				color = bar.maxBite and bar.maxBite.color or "FF009900",
				enabled = bar.maxBite and bar.maxBite.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("bar"),
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("border"),
			}

			bar.apexPredator = nil
			bar.maxBite = nil
			bar.borderStealth = nil
			bar.borderOvercap = nil
		end

		-- Add Ravage indicator for existing Feral users and ensure it has higher priority than Stealth.
		if feral.colors and feral.colors.shared and feral.colors.shared.indicatorColors then
			local ic = feral.colors.shared.indicatorColors
			if ic.ravage == nil then
				ic.ravage = {
					color = "FFF4B183",
					enabled = true,
					targets = {
						comboPoints = { bar = true, border = false, background = false },
					},
				}
			end

			feral.colors.shared.nodeOrder = feral.colors.shared.nodeOrder or {}
			local filtered = {}
			for _, key in ipairs(feral.colors.shared.nodeOrder) do
				if key ~= "ravage" then
					table.insert(filtered, key)
				end
			end

			local inserted = false
			local rebuilt = {}
			for _, key in ipairs(filtered) do
				if key == "borderStealth" and not inserted then
					table.insert(rebuilt, "ravage")
					inserted = true
				end
				table.insert(rebuilt, key)
			end
			if not inserted then
				table.insert(rebuilt, "ravage")
			end
			feral.colors.shared.nodeOrder = rebuilt
		end
	end

	-- Migrate Guardian Druid indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.guardian then
		local guardian = TwintopInsanityBarSettings.druid.guardian
		if guardian.colors and guardian.colors.bar and guardian.colors.bar.berserk ~= nil
			and type(guardian.colors.bar.berserk) == "table"
			and (guardian.colors.shared == nil or guardian.colors.shared.indicatorColors == nil) then

			guardian.colors.shared = guardian.colors.shared or {}
			guardian.colors.shared.nodeOrder = {
				"berserkEnd",
				"berserk",
			}
			guardian.colors.shared.gradientOrder = {
				"borderOvercap",
			}
			guardian.colors.shared.indicatorColors = {}
			local ic = guardian.colors.shared.indicatorColors
			local bar = guardian.colors.bar

			local function MakeTargets(elemKey)
				local t = {
					rageBar = { bar = false, border = false, background = false },
				}
				t.rageBar[elemKey] = true
				return t
			end

			ic.berserkEnd = {
				color = bar.berserkEnd and bar.berserkEnd.color or "FFFF5555",
				enabled = guardian.endOf and guardian.endOf.berserk and guardian.endOf.berserk.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.berserk = {
				color = bar.berserk and bar.berserk.color or "FFFFCC55",
				enabled = bar.berserk and bar.berserk.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FF800000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("border"),
			}

			bar.berserk = nil
			bar.berserkEnd = nil
			bar.borderOvercap = nil

			if guardian.endOf and guardian.endOf.berserk then
				guardian.endOf.berserk.enabled = nil
			end
		end
	end

	-- Migrate Restoration Druid indicator colors from colors.bar.* to colors.shared.indicatorColors.*
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.restoration then
		local restoration = TwintopInsanityBarSettings.druid.restoration
		if restoration.colors and restoration.colors.bar and restoration.colors.bar.noEfflorescence ~= nil
			and type(restoration.colors.bar.noEfflorescence) == "table"
			and (restoration.colors.shared == nil or restoration.colors.shared.indicatorColors == nil) then

			restoration.colors.shared = restoration.colors.shared or {}
			restoration.colors.shared.nodeOrder = {
				"incarnationEnd",
				"incarnation",
				"noEfflorescence",
			}
			restoration.colors.shared.gradientOrder = {}
			restoration.colors.shared.indicatorColors = {}
			local ic = restoration.colors.shared.indicatorColors
			local bar = restoration.colors.bar

			local function MakeTargets(elemKey)
				local t = {
					manaBar = { bar = false, border = false, background = false },
				}
				t.manaBar[elemKey] = true
				return t
			end

			ic.incarnationEnd = {
				color = bar.incarnationEnd and bar.incarnationEnd.color or "FFDD5500",
				enabled = restoration.endOf and restoration.endOf.incarnation and restoration.endOf.incarnation.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.incarnation = {
				color = bar.incarnation and bar.incarnation.color or "FF005500",
				enabled = bar.incarnation and bar.incarnation.enabled ~= false,
				targets = MakeTargets("bar"),
			}
			ic.noEfflorescence = {
				color = bar.noEfflorescence and bar.noEfflorescence.color or "FFFF0000",
				enabled = bar.noEfflorescence and bar.noEfflorescence.enabled ~= false,
				targets = MakeTargets("bar"),
			}

			bar.noEfflorescence = nil
			bar.incarnation = nil
			bar.incarnationEnd = nil

			if restoration.endOf and restoration.endOf.incarnation then
				restoration.endOf.incarnation.enabled = nil
			end
		end
	end

	-- Migrate Restoration Druid clearcasting from colors.bar.clearcasting to colors.shared.indicatorColors.clearcasting
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.restoration then
		local restoration = TwintopInsanityBarSettings.druid.restoration
		if restoration.colors and restoration.colors.shared and restoration.colors.shared.indicatorColors
			and restoration.colors.shared.indicatorColors.clearcasting == nil
			and restoration.colors.bar and restoration.colors.bar.clearcasting ~= nil then

			restoration.colors.shared.nodeOrder = restoration.colors.shared.nodeOrder or {}

			local hasClearcasting = false
			for _, key in ipairs(restoration.colors.shared.nodeOrder) do
				if key == "clearcasting" then
					hasClearcasting = true
					break
				end
			end

			if not hasClearcasting then
				table.insert(restoration.colors.shared.nodeOrder, "clearcasting")
			end

			restoration.colors.shared.indicatorColors.clearcasting = {
				color = restoration.colors.bar.clearcasting.color or "FF4A95CE",
				color2 = restoration.colors.bar.clearcasting.color2 or "FF4A95CE",
				gradientDirection = restoration.colors.bar.clearcasting.gradientDirection or "disabled",
				enabled = restoration.colors.bar.clearcasting.enabled ~= false,
				targets = {
					manaBar = { bar = true, border = false, background = false },
				},
			}

			restoration.colors.bar.clearcasting = nil
		end
	end

	-- Migrate Feral Druid clearcasting from colors.bar.clearcasting to colors.shared.indicatorColors.clearcasting
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.druid and TwintopInsanityBarSettings.druid.feral then
		local feral = TwintopInsanityBarSettings.druid.feral
		if feral.colors and feral.colors.shared and feral.colors.shared.indicatorColors
			and feral.colors.shared.indicatorColors.clearcasting == nil
			and feral.colors.bar and feral.colors.bar.clearcasting ~= nil then

			-- Insert clearcasting after ravage but before borderStealth in nodeOrder
			feral.colors.shared.nodeOrder = feral.colors.shared.nodeOrder or {}
			local nodeOrder = feral.colors.shared.nodeOrder
			local hasClearcasting = false
			local borderStealthIndex = nil
			for i, key in ipairs(nodeOrder) do
				if key == "clearcasting" then
					hasClearcasting = true
					break
				elseif key == "borderStealth" and borderStealthIndex == nil then
					borderStealthIndex = i
				end
			end
			if not hasClearcasting then
				if borderStealthIndex ~= nil then
					table.insert(nodeOrder, borderStealthIndex, "clearcasting")
				else
					table.insert(nodeOrder, "clearcasting")
				end
			end

			feral.colors.shared.indicatorColors.clearcasting = {
				color = feral.colors.bar.clearcasting.color or "FF4A95CE",
				color2 = feral.colors.bar.clearcasting.color2 or "FF4A95CE",
				gradientDirection = feral.colors.bar.clearcasting.gradientDirection or "disabled",
				enabled = feral.colors.bar.clearcasting.enabled ~= false,
				targets = {
					energyBar = { bar = true, border = false, background = false },
				},
			}

			feral.colors.bar.clearcasting = nil
		end
	end

	-- Migrate Hunter BeastMastery to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.hunter and TwintopInsanityBarSettings.hunter.beastMastery then
		local spec = TwintopInsanityBarSettings.hunter.beastMastery
		if spec.colors and spec.colors.bar
		and (spec.colors.bar.bestialWrath or spec.colors.bar.beastCleave)
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "bestialWrathEnd", "beastCleave", "bestialWrath" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.bestialWrath = {
				color = bar.bestialWrath and bar.bestialWrath.color or "FF005500",
				enabled = bar.bestialWrath and bar.bestialWrath.enabled ~= false,
				targets = { focusBar = { bar = true, border = false, background = false } }
			}
			ic.bestialWrathEnd = {
				color = bar.bestialWrathEnd and bar.bestialWrathEnd.color or "FFFF0000",
				enabled = true,
				targets = { focusBar = { bar = true, border = false, background = false } }
			}
			ic.beastCleave = {
				color = bar.beastCleave and bar.beastCleave.color or "FF77FF77",
				enabled = bar.beastCleave and bar.beastCleave.enabled ~= false,
				targets = { focusBar = { bar = false, border = true, background = false } }
			}
			bar.bestialWrath = nil
			bar.bestialWrathEnd = nil
			bar.beastCleave = nil
		end
	end

	-- Migrate Hunter Marksmanship to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.hunter and TwintopInsanityBarSettings.hunter.marksmanship then
		local spec = TwintopInsanityBarSettings.hunter.marksmanship
		if spec.colors and spec.colors.bar
		and spec.colors.bar.trueshot
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "trueshotEnd", "trueshot" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.trueshot = {
				color = bar.trueshot and bar.trueshot.color or "FF00B60E",
				enabled = bar.trueshot and bar.trueshot.enabled ~= false,
				targets = { focusBar = { bar = true, border = false, background = false } }
			}
			ic.trueshotEnd = {
				color = bar.trueshotEnd and bar.trueshotEnd.color or "FFFF0000",
				enabled = true,
				targets = { focusBar = { bar = true, border = false, background = false } }
			}
			bar.trueshot = nil
			bar.trueshotEnd = nil
		end
	end

	-- Migrate Hunter Survival to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.hunter and TwintopInsanityBarSettings.hunter.survival then
		local spec = TwintopInsanityBarSettings.hunter.survival
		if spec.colors and spec.colors.bar
		and spec.colors.bar.takedown
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "takedownEnd", "takedown" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			local function MakeTargets(defaultBarKey, defaultElementKey)
				local targets = {
					focusBar = { bar = false, border = false, background = false },
					tipOfTheSpearBar = { bar = false, border = false, background = false },
				}
				if targets[defaultBarKey] then
					targets[defaultBarKey][defaultElementKey] = true
				end
				return targets
			end
			ic.takedown = {
				color = bar.takedown and bar.takedown.color or "FF005500",
				enabled = bar.takedown and bar.takedown.enabled ~= false,
				targets = MakeTargets("focusBar", "bar")
			}
			ic.takedownEnd = {
				color = bar.takedownEnd and bar.takedownEnd.color or "FFFF0000",
				enabled = true,
				targets = MakeTargets("focusBar", "bar")
			}
			bar.takedown = nil
			bar.takedownEnd = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
			local ic = spec.colors.shared.indicatorColors
			for _, key in ipairs({ "takedown", "takedownEnd", "borderOvercap" }) do
				if ic[key] then
					ic[key].targets = ic[key].targets or {}
					ic[key].targets.focusBar = ic[key].targets.focusBar or { bar = false, border = false, background = false }
					ic[key].targets.tipOfTheSpearBar = ic[key].targets.tipOfTheSpearBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Migrate Hunter borderOvercap gradient to indicator colors (for users who already have flat indicators migrated but not the gradient)
	for _, specName in ipairs({ "beastMastery", "marksmanship", "survival" }) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings.hunter and TwintopInsanityBarSettings.hunter[specName] then
			local spec = TwintopInsanityBarSettings.hunter[specName]
			if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
			and spec.colors.shared.indicatorColors.borderOvercap == nil then
				spec.colors.shared.gradientOrder = { "borderOvercap" }
				spec.colors.shared.indicatorColors.borderOvercap = {
					color = (spec.colors.bar and spec.colors.bar.borderOvercap and spec.colors.bar.borderOvercap.color) or "FFFF0000",
					enabled = (spec.colors.bar and spec.colors.bar.borderOvercap and spec.colors.bar.borderOvercap.enabled) ~= false,
					isGradient = true,
					targets = {
						focusBar = { bar = false, border = true, background = false },
						tipOfTheSpearBar = { bar = false, border = false, background = false },
					},
				}
				if spec.colors.bar and spec.colors.bar.borderOvercap then
					spec.colors.bar.borderOvercap = nil
				end
			elseif specName == "survival" and spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
				local ic = spec.colors.shared.indicatorColors.borderOvercap
				if ic then
					ic.targets = ic.targets or {}
					ic.targets.focusBar = ic.targets.focusBar or { bar = false, border = false, background = false }
					ic.targets.tipOfTheSpearBar = ic.targets.tipOfTheSpearBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Migrate Warrior Arms to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warrior and TwintopInsanityBarSettings.warrior.arms then
		local spec = TwintopInsanityBarSettings.warrior.arms
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderOvercap
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = {}
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}
			spec.colors.shared.indicatorColors.borderOvercap = {
				color = spec.colors.bar.borderOvercap.color or "FF800000",
				enabled = spec.colors.bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = { rageBar = { bar = false, border = true, background = false } },
			}
			spec.colors.bar.borderOvercap = nil
		end
	end

	-- Migrate Warrior Fury to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warrior and TwintopInsanityBarSettings.warrior.fury then
		local spec = TwintopInsanityBarSettings.warrior.fury
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderOvercap
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = {}
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}
			spec.colors.shared.indicatorColors.borderOvercap = {
				color = spec.colors.bar.borderOvercap.color or "FF800000",
				enabled = spec.colors.bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = { rageBar = { bar = false, border = true, background = false } },
			}
			spec.colors.bar.borderOvercap = nil
		end
	end

	-- Migrate Warrior Fury zeroStackBackground from whirlwind bar colors to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warrior and TwintopInsanityBarSettings.warrior.fury then
		local spec = TwintopInsanityBarSettings.warrior.fury
		if spec.colors and spec.colors.bars and spec.colors.bars.whirlwind
		and spec.colors.bars.whirlwind.zeroStackBackground
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil or spec.colors.shared.indicatorColors.zeroStackBackground == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			spec.colors.shared.gradientOrder = spec.colors.shared.gradientOrder or {}
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}

			local old = spec.colors.bars.whirlwind.zeroStackBackground
			local enabled = old.enabled ~= false
			if old.enabled == false and old.color == "66333333" then
				enabled = true
			end
			spec.colors.shared.indicatorColors.zeroStackBackground = {
				color = old.color or "FF333333",
				enabled = enabled,
				targets = { whirlwindBar = { bar = false, border = false, background = true } },
			}

			-- Add to nodeOrder if not already present
			local found = false
			for _, v in ipairs(spec.colors.shared.nodeOrder) do
				if v == "zeroStackBackground" then found = true break end
			end
			if not found then
				table.insert(spec.colors.shared.nodeOrder, 1, "zeroStackBackground")
			end

			spec.colors.bars.whirlwind.zeroStackBackground = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors and spec.colors.shared.indicatorColors.zeroStackBackground then
			local indicator = spec.colors.shared.indicatorColors.zeroStackBackground
			indicator.targets = indicator.targets or {}
			indicator.targets.whirlwindBar = indicator.targets.whirlwindBar or { bar = false, border = false, background = true }
			if indicator.enabled == false and indicator.color == "66333333" and indicator.targets.whirlwindBar.background then
				indicator.enabled = true
			end
		end
	end

	-- Migrate Warrior Protection to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warrior and TwintopInsanityBarSettings.warrior.protection then
		local spec = TwintopInsanityBarSettings.warrior.protection
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderOvercap
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = {}
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}
			spec.colors.shared.indicatorColors.borderOvercap = {
				color = spec.colors.bar.borderOvercap.color or "FF800000",
				enabled = spec.colors.bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = { rageBar = { bar = false, border = true, background = false } },
			}
			spec.colors.bar.borderOvercap = nil
		end
	end

	local function EnsureDeathKnightIndicatorTargetTables(indicator)
		indicator.targets = indicator.targets or {}
		indicator.targets.runicPowerBar = indicator.targets.runicPowerBar or { bar = false, border = false, background = false }
		indicator.targets.runesBar = indicator.targets.runesBar or { bar = false, border = false, background = false }
	end

	local function EnsureDeathKnightBloodIndicatorTargetTables(indicator)
		EnsureDeathKnightIndicatorTargetTables(indicator)
		indicator.targets = indicator.targets or {}
		indicator.targets.boneShield = indicator.targets.boneShield or { bar = false, border = false, background = false }
	end

	local function EnsureDeathKnightIndicatorOrder(order, key)
		order = order or {}
		for _, existingKey in ipairs(order) do
			if existingKey == key then
				return order
			end
		end
		table.insert(order, key)
		return order
	end

	local function MigrateDeathKnightIndicatorColors(spec)
		if not (spec and spec.colors) then
			return
		end

		spec.colors.shared = spec.colors.shared or {}
		spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
		spec.colors.shared.gradientOrder = spec.colors.shared.gradientOrder or {}
		spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}

		local indicatorColors = spec.colors.shared.indicatorColors
		local legacyBarOvercap = spec.colors.bar and spec.colors.bar.borderOvercap
		local legacyRuneOvercap = spec.colors.comboPoints and spec.colors.comboPoints.overcap

		if indicatorColors.borderOvercap == nil and legacyBarOvercap then
			indicatorColors.borderOvercap = {
				color = legacyBarOvercap.color or "FFFF0000",
				enabled = legacyBarOvercap.enabled ~= false,
				isGradient = true,
				targets = {
					runicPowerBar = { bar = false, border = true, background = false },
					runesBar = { bar = false, border = false, background = false },
					boneShield = spec.bars and spec.bars.boneShield and { bar = false, border = false, background = false } or nil,
				},
			}
		end

		if indicatorColors.borderOvercap then
			indicatorColors.borderOvercap.isGradient = true
			if spec.bars and spec.bars.boneShield then
				EnsureDeathKnightBloodIndicatorTargetTables(indicatorColors.borderOvercap)
			else
				EnsureDeathKnightIndicatorTargetTables(indicatorColors.borderOvercap)
			end
			spec.colors.shared.gradientOrder = EnsureDeathKnightIndicatorOrder(spec.colors.shared.gradientOrder, "borderOvercap")
		end

		local createdRuneRegenOvercap = false
		if indicatorColors.runeRegenOvercap == nil then
			createdRuneRegenOvercap = true
			local legacyEnabled = legacyRuneOvercap and legacyRuneOvercap.enabled == true or false
			local defaultEnabled = legacyRuneOvercap == nil
			local enabled = legacyRuneOvercap ~= nil and legacyEnabled or defaultEnabled
			indicatorColors.runeRegenOvercap = {
				color = legacyRuneOvercap and legacyRuneOvercap.color or "FFFF4500",
				enabled = enabled,
				targets = {},
			}
		end

		if indicatorColors.runeRegenOvercap then
			if spec.bars and spec.bars.boneShield then
				EnsureDeathKnightBloodIndicatorTargetTables(indicatorColors.runeRegenOvercap)
			else
				EnsureDeathKnightIndicatorTargetTables(indicatorColors.runeRegenOvercap)
			end
			if createdRuneRegenOvercap then
				-- Only the creation path should seed Death Knight's default target.
				-- An existing all-false target table is valid saved state from the
				-- indicator options UI and must survive port-forwarding unchanged.
				indicatorColors.runeRegenOvercap.targets.runesBar.bar = indicatorColors.runeRegenOvercap.enabled == true
			end
			spec.colors.shared.nodeOrder = EnsureDeathKnightIndicatorOrder(spec.colors.shared.nodeOrder, "runeRegenOvercap")
		end

		if spec.colors.bar then
			spec.colors.bar.borderOvercap = nil
		end
		if spec.colors.comboPoints then
			spec.colors.comboPoints.overcap = nil
		end
	end

	-- Migrate Death Knight Blood to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.deathknight and TwintopInsanityBarSettings.deathknight.blood then
		MigrateDeathKnightIndicatorColors(TwintopInsanityBarSettings.deathknight.blood)
	end

	-- Migrate Death Knight Frost to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.deathknight and TwintopInsanityBarSettings.deathknight.frost then
		MigrateDeathKnightIndicatorColors(TwintopInsanityBarSettings.deathknight.frost)
	end

	-- Migrate Death Knight Unholy to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.deathknight and TwintopInsanityBarSettings.deathknight.unholy then
		MigrateDeathKnightIndicatorColors(TwintopInsanityBarSettings.deathknight.unholy)
	end

	-- Migrate Paladin Holy to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.paladin and TwintopInsanityBarSettings.paladin.holy then
		local spec = TwintopInsanityBarSettings.paladin.holy
		if spec.colors
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or { "infusionOfLight" }
			spec.colors.shared.gradientOrder = spec.colors.shared.gradientOrder or {}
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar or {}
			if ic.infusionOfLight == nil then
				ic.infusionOfLight = {
					color = bar.infusionOfLight and bar.infusionOfLight.color or "FFFCE58E",
					enabled = (bar.infusionOfLight == nil) or (bar.infusionOfLight.enabled ~= false),
					targets = {
						manaBar = { bar = false, border = true, background = false },
						holyPowerBar = { bar = false, border = false, background = false },
					}
				}
			end
			if spec.colors.bar then
				spec.colors.bar.infusionOfLight = nil
			end
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors and spec.colors.shared.indicatorColors.infusionOfLight then
			local targets = spec.colors.shared.indicatorColors.infusionOfLight.targets or {}
			spec.colors.shared.indicatorColors.infusionOfLight.targets = targets
			targets.manaBar = targets.manaBar or { bar = false, border = false, background = false }
			targets.holyPowerBar = targets.holyPowerBar or { bar = false, border = false, background = false }
		end
	end

	-- Migrate Paladin Protection to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.paladin and TwintopInsanityBarSettings.paladin.protection then
		local spec = TwintopInsanityBarSettings.paladin.protection
		if spec.colors and spec.colors.bar
		and spec.colors.bar.infusionOfLight
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "infusionOfLight" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.infusionOfLight = {
				color = bar.infusionOfLight and bar.infusionOfLight.color or "FFFCE58E",
				enabled = bar.infusionOfLight and bar.infusionOfLight.enabled ~= false,
				targets = {
					manaBar = { bar = false, border = true, background = false },
					holyPowerBar = { bar = false, border = false, background = false },
				}
			}
			bar.infusionOfLight = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors and spec.colors.shared.indicatorColors.infusionOfLight then
			local targets = spec.colors.shared.indicatorColors.infusionOfLight.targets or {}
			spec.colors.shared.indicatorColors.infusionOfLight.targets = targets
			targets.manaBar = targets.manaBar or { bar = false, border = false, background = false }
			targets.holyPowerBar = targets.holyPowerBar or { bar = false, border = false, background = false }
		end
	end

	-- Backfill Paladin Holy divinePurpose indicator
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.paladin and TwintopInsanityBarSettings.paladin.holy then
		local spec = TwintopInsanityBarSettings.paladin.holy
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.divinePurpose == nil then
			spec.colors.shared.indicatorColors.divinePurpose = {
				color = "FF44FF44",
				color2 = "FF44FF44",
				gradientDirection = "disabled",
				enabled = true,
				targets = {
					manaBar = { bar = false, border = false, background = false },
					holyPowerBar = { bar = false, border = true, background = true },
				},
			}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "divinePurpose" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, "divinePurpose")
			end
		end
	end

	-- Backfill Paladin Protection divinePurpose indicator
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.paladin and TwintopInsanityBarSettings.paladin.protection then
		local spec = TwintopInsanityBarSettings.paladin.protection
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.divinePurpose == nil then
			spec.colors.shared.indicatorColors.divinePurpose = {
				color = "FF44FF44",
				color2 = "FF44FF44",
				gradientDirection = "disabled",
				enabled = true,
				targets = {
					manaBar = { bar = false, border = false, background = false },
					holyPowerBar = { bar = false, border = true, background = true },
				},
			}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "divinePurpose" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, "divinePurpose")
			end
		end
	end

	-- Backfill Paladin Retribution divinePurpose indicator
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.paladin and TwintopInsanityBarSettings.paladin.retribution then
		local spec = TwintopInsanityBarSettings.paladin.retribution
		if spec.colors then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			spec.colors.shared.gradientOrder = spec.colors.shared.gradientOrder or {}
			spec.colors.shared.indicatorColors = spec.colors.shared.indicatorColors or {}
			if spec.colors.shared.indicatorColors.divinePurpose == nil then
				spec.colors.shared.indicatorColors.divinePurpose = {
					color = "FF44FF44",
					color2 = "FF44FF44",
					gradientDirection = "disabled",
					enabled = true,
					targets = {
						manaBar = { bar = false, border = false, background = false },
						holyPowerBar = { bar = false, border = true, background = true },
					},
				}
				local nodeOrder = spec.colors.shared.nodeOrder
				local found = false
				for _, v in ipairs(nodeOrder) do
					if v == "divinePurpose" then found = true break end
				end
				if not found then
					table.insert(nodeOrder, "divinePurpose")
				end
			end
		end
	end

	-- Migrate Rogue Assassination to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.rogue and TwintopInsanityBarSettings.rogue.assassination then
		local spec = TwintopInsanityBarSettings.rogue.assassination
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderStealth
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "borderStealth" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.borderStealth = {
				color = bar.borderStealth and bar.borderStealth.color or "FF000000",
				enabled = bar.borderStealth and bar.borderStealth.enabled ~= false,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			bar.borderStealth = nil
			bar.borderOvercap = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
			local ic = spec.colors.shared.indicatorColors
			for _, key in ipairs({ "borderStealth", "borderOvercap" }) do
				if ic[key] then
					ic[key].targets = ic[key].targets or {}
					ic[key].targets.energyBar = ic[key].targets.energyBar or { bar = false, border = false, background = false }
					ic[key].targets.comboPointsBar = ic[key].targets.comboPointsBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Migrate Rogue Outlaw to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.rogue and TwintopInsanityBarSettings.rogue.outlaw then
		local spec = TwintopInsanityBarSettings.rogue.outlaw
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderStealth
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "borderStealth" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.borderStealth = {
				color = bar.borderStealth and bar.borderStealth.color or "FF000000",
				enabled = bar.borderStealth and bar.borderStealth.enabled ~= false,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			bar.borderStealth = nil
			bar.borderOvercap = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
			local ic = spec.colors.shared.indicatorColors
			for _, key in ipairs({ "borderStealth", "borderOvercap" }) do
				if ic[key] then
					ic[key].targets = ic[key].targets or {}
					ic[key].targets.energyBar = ic[key].targets.energyBar or { bar = false, border = false, background = false }
					ic[key].targets.comboPointsBar = ic[key].targets.comboPointsBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Migrate Rogue Subtlety to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.rogue and TwintopInsanityBarSettings.rogue.subtlety then
		local spec = TwintopInsanityBarSettings.rogue.subtlety
		if spec.colors and spec.colors.bar
		and spec.colors.bar.borderStealth
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "borderStealth" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.borderStealth = {
				color = bar.borderStealth and bar.borderStealth.color or "FF000000",
				enabled = bar.borderStealth and bar.borderStealth.enabled ~= false,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = {
					energyBar = { bar = false, border = true, background = false },
					comboPointsBar = { bar = false, border = false, background = false },
				}
			}
			bar.borderStealth = nil
			bar.borderOvercap = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
			local ic = spec.colors.shared.indicatorColors
			for _, key in ipairs({ "borderStealth", "borderOvercap" }) do
				if ic[key] then
					ic[key].targets = ic[key].targets or {}
					ic[key].targets.energyBar = ic[key].targets.energyBar or { bar = false, border = false, background = false }
					ic[key].targets.comboPointsBar = ic[key].targets.comboPointsBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Migrate Shaman Elemental to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.shaman and TwintopInsanityBarSettings.shaman.elemental then
		local spec = TwintopInsanityBarSettings.shaman.elemental
		if spec.colors and spec.colors.bar
		and spec.colors.bar.ascendance
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "ascendanceEnd", "earthShock", "earthquake", "ascendance" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.ascendance = {
				color = bar.ascendance and bar.ascendance.color or "FF00FFFF",
				enabled = bar.ascendance and bar.ascendance.enabled ~= false,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			ic.ascendanceEnd = {
				color = bar.ascendanceEnd and bar.ascendanceEnd.color or "FFFF0000",
				enabled = true,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			ic.earthShock = {
				color = bar.earthShock and bar.earthShock.color or "FF00A2FF",
				enabled = bar.earthShock and bar.earthShock.enabled ~= false,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			ic.earthquake = {
				color = bar.earthquake and bar.earthquake.color or "FFFF8800",
				enabled = bar.earthquake and bar.earthquake.enabled ~= false,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = { maelstromBar = { bar = false, border = true, background = false } }
			}
			bar.ascendance = nil
			bar.ascendanceEnd = nil
			bar.earthShock = nil
			bar.earthquake = nil
			bar.borderOvercap = nil
			if spec.endOf and spec.endOf.ascendance then
				spec.endOf.ascendance.enabled = nil
			end
		end
	end

	-- Migrate Shaman Enhancement to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.shaman and TwintopInsanityBarSettings.shaman.enhancement then
		local spec = TwintopInsanityBarSettings.shaman.enhancement
		if spec.colors and spec.colors.bar
		and spec.colors.bar.ascendance
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "ascendanceEnd", "ascendance" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.ascendance = {
				color = bar.ascendance and bar.ascendance.color or "FF00FFFF",
				enabled = bar.ascendance and bar.ascendance.enabled ~= false,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			ic.ascendanceEnd = {
				color = bar.ascendanceEnd and bar.ascendanceEnd.color or "FFFF0000",
				enabled = true,
				targets = { maelstromBar = { bar = true, border = false, background = false } }
			}
			bar.ascendance = nil
			bar.ascendanceEnd = nil
			if spec.endOf and spec.endOf.ascendance then
				spec.endOf.ascendance.enabled = nil
			end
		end
	end

	-- Migrate Shaman Restoration to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.shaman and TwintopInsanityBarSettings.shaman.restoration then
		local spec = TwintopInsanityBarSettings.shaman.restoration
		if spec.colors and spec.colors.bar
		and spec.colors.bar.ascendance
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "ascendanceEnd", "ascendance" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.ascendance = {
				color = bar.ascendance and bar.ascendance.color or "FF00FFFF",
				enabled = bar.ascendance and bar.ascendance.enabled ~= false,
				targets = { manaBar = { bar = true, border = false, background = false } }
			}
			ic.ascendanceEnd = {
				color = bar.ascendanceEnd and bar.ascendanceEnd.color or "FFFF0000",
				enabled = true,
				targets = { manaBar = { bar = true, border = false, background = false } }
			}
			bar.ascendance = nil
			bar.ascendanceEnd = nil
			if spec.endOf and spec.endOf.ascendance then
				spec.endOf.ascendance.enabled = nil
			end
		end
	end

	-- Migrate Monk Brewmaster to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.monk and TwintopInsanityBarSettings.monk.brewmaster then
		local spec = TwintopInsanityBarSettings.monk.brewmaster
		if spec.colors and spec.colors.bar
		and spec.colors.bar.invokeNiuzao
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "invokeNiuzaoEnd", "invokeNiuzao" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.invokeNiuzao = {
				color = bar.invokeNiuzao and bar.invokeNiuzao.color or "FFFF8000",
				enabled = bar.invokeNiuzao and bar.invokeNiuzao.enabled ~= false,
				targets = { energyBar = { bar = true, border = false, background = false } }
			}
			ic.invokeNiuzaoEnd = {
				color = bar.invokeNiuzaoEnd and bar.invokeNiuzaoEnd.color or "FFFF0000",
				enabled = true,
				targets = { energyBar = { bar = true, border = false, background = false } }
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = { energyBar = { bar = false, border = true, background = false } }
			}
			bar.invokeNiuzao = nil
			bar.invokeNiuzaoEnd = nil
			bar.borderOvercap = nil
			if spec.endOf and spec.endOf.invokeNiuzao then
				spec.endOf.invokeNiuzao.enabled = nil
			end
		end
	end

	-- Migrate Monk Mistweaver to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.monk and TwintopInsanityBarSettings.monk.mistweaver then
		local spec = TwintopInsanityBarSettings.monk.mistweaver
		if spec.colors and spec.colors.bar
		and spec.colors.bar.vivaciousVivification
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "vivaciousVivification", "heartOfTheJadeSerpent", "heartOfTheJadeSerpentReady" }
			spec.colors.shared.gradientOrder = {}
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			ic.vivaciousVivification = {
				color = bar.vivaciousVivification and bar.vivaciousVivification.color or "FF00FF00",
				enabled = bar.vivaciousVivification and bar.vivaciousVivification.enabled ~= false,
				targets = { manaBar = { bar = true, border = false, background = false } }
			}
			ic.heartOfTheJadeSerpentReady = {
				color = bar.heartOfTheJadeSerpentReady and bar.heartOfTheJadeSerpentReady.color or "FFFF8000",
				enabled = bar.heartOfTheJadeSerpentReady and bar.heartOfTheJadeSerpentReady.enabled ~= false,
				targets = { manaBar = { bar = false, border = true, background = false } }
			}
			ic.heartOfTheJadeSerpent = {
				color = bar.heartOfTheJadeSerpent and bar.heartOfTheJadeSerpent.color or "FFFF0000",
				enabled = bar.heartOfTheJadeSerpent and bar.heartOfTheJadeSerpent.enabled ~= false,
				targets = { manaBar = { bar = false, border = true, background = false } }
			}
			bar.vivaciousVivification = nil
			bar.heartOfTheJadeSerpentReady = nil
			bar.heartOfTheJadeSerpent = nil
		end
	end

	-- Migrate Monk Windwalker to indicator colors
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.monk and TwintopInsanityBarSettings.monk.windwalker then
		local spec = TwintopInsanityBarSettings.monk.windwalker
		if spec.colors and spec.colors.bar
		and spec.colors.bar.heartOfTheJadeSerpentReady
		and (spec.colors.shared == nil or spec.colors.shared.indicatorColors == nil) then
			spec.colors.shared = spec.colors.shared or {}
			spec.colors.shared.nodeOrder = { "heartOfTheJadeSerpentReady", "heartOfTheJadeSerpent", "danceOfChiJi" }
			spec.colors.shared.gradientOrder = { "borderOvercap" }
			spec.colors.shared.indicatorColors = {}
			local ic = spec.colors.shared.indicatorColors
			local bar = spec.colors.bar
			local function MakeTargets(defaultBarKey, defaultElementKey)
				local targets = {
					energyBar = { bar = false, border = false, background = false },
					chiBar = { bar = false, border = false, background = false },
				}
				if targets[defaultBarKey] then
					targets[defaultBarKey][defaultElementKey] = true
				end
				return targets
			end
			ic.heartOfTheJadeSerpentReady = {
				color = bar.heartOfTheJadeSerpentReady and bar.heartOfTheJadeSerpentReady.color or "FFFF8000",
				enabled = bar.heartOfTheJadeSerpentReady and bar.heartOfTheJadeSerpentReady.enabled ~= false,
				targets = MakeTargets("energyBar", "border")
			}
			ic.heartOfTheJadeSerpent = {
				color = bar.heartOfTheJadeSerpent and bar.heartOfTheJadeSerpent.color or "FFFF0000",
				enabled = bar.heartOfTheJadeSerpent and bar.heartOfTheJadeSerpent.enabled ~= false,
				targets = MakeTargets("energyBar", "border")
			}
			ic.danceOfChiJi = {
				color = ((bar.danceOfChiJi and bar.danceOfChiJi.color) or (bar.borderChiJi and bar.borderChiJi.color)) or "FFFF00FF",
				enabled = ((bar.danceOfChiJi and bar.danceOfChiJi.enabled ~= false) or (bar.borderChiJi and bar.borderChiJi.enabled ~= false)) ~= false,
				targets = MakeTargets("energyBar", "border")
			}
			ic.borderOvercap = {
				color = bar.borderOvercap and bar.borderOvercap.color or "FFFF0000",
				enabled = bar.borderOvercap and bar.borderOvercap.enabled ~= false,
				isGradient = true,
				targets = MakeTargets("energyBar", "border")
			}
			bar.heartOfTheJadeSerpentReady = nil
			bar.heartOfTheJadeSerpent = nil
			bar.danceOfChiJi = nil
			bar.borderChiJi = nil
			bar.borderOvercap = nil
		end

		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors then
			local ic = spec.colors.shared.indicatorColors
			for _, key in ipairs({ "heartOfTheJadeSerpentReady", "heartOfTheJadeSerpent", "danceOfChiJi", "borderOvercap" }) do
				if ic[key] then
					ic[key].targets = ic[key].targets or {}
					ic[key].targets.energyBar = ic[key].targets.energyBar or { bar = false, border = false, background = false }
					ic[key].targets.chiBar = ic[key].targets.chiBar or { bar = false, border = false, background = false }
				end
			end
		end
	end

	-- Ensure colors.shared exists for all specs so indicator-color consumers can rely on it.
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for _, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if type(specSettings) == "table" and specSettings.colors ~= nil then
					specSettings.colors.shared = specSettings.colors.shared or {}
					specSettings.colors.shared.nodeOrder = specSettings.colors.shared.nodeOrder or {}
					specSettings.colors.shared.gradientOrder = specSettings.colors.shared.gradientOrder or {}
					specSettings.colors.shared.indicatorColors = specSettings.colors.shared.indicatorColors or {}
				end
			end
		end
	end

	-- Remove legacy consistentUnfilledColor from comboPoints colors (deprecated option removed)
	if TwintopInsanityBarSettings ~= nil then
		for _, classValue in pairs(TwintopInsanityBarSettings) do
			if type(classValue) == "table" then
				for _, specVal in pairs(classValue) do
					if type(specVal) == "table" and
					specVal.colors ~= nil and
					specVal.colors.comboPoints ~= nil then
						specVal.colors.comboPoints.consistentUnfilledColor = nil
					end
				end
			end
		end
	end

	-- Backfill color2 + gradientDirection on fill color entries for bar gradient support
	local comboPointNonFillKeys = {
		border = true, background = true, sameColor = true, sortRunes = true,
		generation = true, compressedView = true,
	}
	local customBarNonFillKeys = {
		border = true, background = true, type = true, sameColor = true,
		nodeOrder = true, nodeColors = true,
	}

	---@param entry table
	local function BackfillGradientFields(entry)
		if type(entry) == "table" and entry.color ~= nil then
			if entry.color2 == nil then
				entry.color2 = entry.color
			end
			if entry.gradientDirection == nil then
				entry.gradientDirection = "disabled"
			end
		end
	end

	---@param entry table
	local function StripGradientFields(entry)
		if type(entry) == "table" then
			entry.color2 = nil
			entry.gradientDirection = nil
		end
	end

	local function EnsureSecondaryPartialFillColor(className, specName)
		local specSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
		if type(specSettings) ~= "table" then
			return
		end

		specSettings.colors = specSettings.colors or {}
		specSettings.colors.comboPoints = specSettings.colors.comboPoints or {}

		local comboPointColors = specSettings.colors.comboPoints
		local defaultColor = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)
		if comboPointColors.regenerating == nil then
			comboPointColors.regenerating = defaultColor
		elseif type(comboPointColors.regenerating) == "string" then
			comboPointColors.regenerating = {
				color = comboPointColors.regenerating,
				color2 = comboPointColors.regenerating,
				gradientDirection = "disabled",
				enabled = false
			}
		elseif type(comboPointColors.regenerating) == "table" then
			comboPointColors.regenerating.color = comboPointColors.regenerating.color or defaultColor.color
			comboPointColors.regenerating.color2 = comboPointColors.regenerating.color2 or comboPointColors.regenerating.color
			comboPointColors.regenerating.gradientDirection = comboPointColors.regenerating.gradientDirection or "disabled"
			if comboPointColors.regenerating.enabled == nil then
				comboPointColors.regenerating.enabled = false
			end
		end
	end

	local function EnsureCustomBarPartialFillColor(className, specName, barKey, defaultColors)
		local specSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
		if type(specSettings) ~= "table" then
			return
		end

		specSettings.colors = specSettings.colors or {}
		specSettings.colors.bars = specSettings.colors.bars or {}
		if type(specSettings.colors.bars[barKey]) ~= "table" then
			specSettings.colors.bars[barKey] = defaultColors or {}
		end

		local barColors = specSettings.colors.bars[barKey]
		local defaultColor = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)
		if barColors.regenerating == nil then
			barColors.regenerating = defaultColor
		elseif type(barColors.regenerating) == "string" then
			barColors.regenerating = {
				color = barColors.regenerating,
				color2 = barColors.regenerating,
				gradientDirection = "disabled",
				enabled = false
			}
		elseif type(barColors.regenerating) == "table" then
			barColors.regenerating.color = barColors.regenerating.color or defaultColor.color
			barColors.regenerating.color2 = barColors.regenerating.color2 or barColors.regenerating.color
			barColors.regenerating.gradientDirection = barColors.regenerating.gradientDirection or "disabled"
			if barColors.regenerating.enabled == nil then
				barColors.regenerating.enabled = false
			end
		end
	end

	local function EnsureSecondaryCastingOverlayColor(className, specName)
		local specSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
		if type(specSettings) ~= "table" then
			return
		end

		specSettings.colors = specSettings.colors or {}
		specSettings.colors.comboPoints = specSettings.colors.comboPoints or {}

		local comboPointColors = specSettings.colors.comboPoints
		local defaultColor = TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(true)
		if comboPointColors.casting == nil then
			comboPointColors.casting = defaultColor
		elseif type(comboPointColors.casting) == "string" then
			comboPointColors.casting = {
				color = comboPointColors.casting,
				color2 = comboPointColors.casting,
				gradientDirection = "disabled",
				enabled = true,
				fullHeight = false
			}
		elseif type(comboPointColors.casting) == "table" then
			comboPointColors.casting.color = comboPointColors.casting.color or defaultColor.color
			comboPointColors.casting.color2 = comboPointColors.casting.color2 or comboPointColors.casting.color
			comboPointColors.casting.gradientDirection = comboPointColors.casting.gradientDirection or "disabled"
			if comboPointColors.casting.enabled == nil then
				comboPointColors.casting.enabled = true
			end
			if comboPointColors.casting.fullHeight == nil then
				comboPointColors.casting.fullHeight = false
			end
		end
	end

	local function EnsureSecondarySpendingOverlayColor(className, specName)
		local specSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
		if type(specSettings) ~= "table" then
			return
		end

		specSettings.colors = specSettings.colors or {}
		specSettings.colors.comboPoints = specSettings.colors.comboPoints or {}

		local comboPointColors = specSettings.colors.comboPoints
		local defaultColor = TRB.Functions.Settings:DefaultSecondarySpendingOverlayColor(true)
		if comboPointColors.spending == nil then
			comboPointColors.spending = defaultColor
		elseif type(comboPointColors.spending) == "string" then
			comboPointColors.spending = {
				color = comboPointColors.spending,
				color2 = comboPointColors.spending,
				gradientDirection = "disabled",
				enabled = true,
				fullHeight = false
			}
		elseif type(comboPointColors.spending) == "table" then
			comboPointColors.spending.color = comboPointColors.spending.color or defaultColor.color
			comboPointColors.spending.color2 = comboPointColors.spending.color2 or comboPointColors.spending.color
			comboPointColors.spending.gradientDirection = comboPointColors.spending.gradientDirection or "disabled"
			if comboPointColors.spending.enabled == nil then
				comboPointColors.spending.enabled = true
			end
			if comboPointColors.spending.fullHeight == nil then
				comboPointColors.spending.fullHeight = false
			end
		end
	end

	local function EnsureSecondaryCastingOverlayTexture(className, specName)
		local specSettings = TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] and TwintopInsanityBarSettings[className][specName]
		if type(specSettings) ~= "table" then
			return
		end

		specSettings.textures = specSettings.textures or {}
		local textures = specSettings.textures
		local defaultTextures = TRB.Functions.Settings:DefaultTextures(true)
		textures.comboPointsCastingBar = textures.comboPointsCastingBar or textures.castingBar or textures.comboPointsBar or defaultTextures.castingBar
		textures.comboPointsCastingBarName = textures.comboPointsCastingBarName or textures.castingBarName or textures.comboPointsBarName or defaultTextures.castingBarName
	end

	EnsureSecondaryPartialFillColor("paladin", "holy")
	EnsureSecondaryPartialFillColor("paladin", "protection")
	EnsureSecondaryPartialFillColor("paladin", "retribution")
	EnsureSecondaryCastingOverlayColor("paladin", "holy")
	EnsureSecondaryCastingOverlayTexture("paladin", "holy")
	EnsureSecondaryPartialFillColor("warlock", "affliction")
	EnsureSecondaryPartialFillColor("warlock", "demonology")
	EnsureSecondaryPartialFillColor("warlock", "destruction")
	EnsureSecondaryCastingOverlayColor("warlock", "affliction")
	EnsureSecondarySpendingOverlayColor("warlock", "affliction")
	EnsureSecondaryCastingOverlayColor("warlock", "demonology")
	EnsureSecondarySpendingOverlayColor("warlock", "demonology")
	EnsureSecondaryCastingOverlayTexture("warlock", "demonology")
	EnsureSecondaryCastingOverlayColor("warlock", "destruction")
	EnsureSecondarySpendingOverlayColor("warlock", "destruction")
	EnsureSecondaryCastingOverlayTexture("warlock", "destruction")
	EnsureSecondaryPartialFillColor("druid", "feral")
	EnsureSecondaryPartialFillColor("evoker", "devastation")
	EnsureSecondaryPartialFillColor("evoker", "preservation")
	EnsureSecondaryPartialFillColor("evoker", "augmentation")
	EnsureCustomBarPartialFillColor("mage", "fire", "fireBlastCharges", TRB.Functions.Settings:DefaultFireBlastChargesBarColors())

	-- Backfill global health bar settings
	if TwintopInsanityBarSettings ~= nil and TwintopInsanityBarSettings.core ~= nil and TwintopInsanityBarSettings.core.healthBar ~= nil then
		local hb = TwintopInsanityBarSettings.core.healthBar
		StripGradientFields(hb.low)
		StripGradientFields(hb.medium)
		StripGradientFields(hb.high)
	end

	-- Backfill all per-spec fill color entries
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for _, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if type(specSettings) == "table" and specSettings.colors ~= nil then
					local colors = specSettings.colors

					-- colors.bar: base, casting, spending (fills only)
					if colors.bar then
						BackfillGradientFields(colors.bar.base)
						BackfillGradientFields(colors.bar.casting)
						BackfillGradientFields(colors.bar.spending)
					end

					-- colors.comboPoints: all fill keys
					if colors.comboPoints then
						for key, entry in pairs(colors.comboPoints) do
							if not comboPointNonFillKeys[key] then
								BackfillGradientFields(entry)
							end
						end
					end

					-- colors.healthBar: low, medium, high (fills only)
					if colors.healthBar then
						StripGradientFields(colors.healthBar.low)
						StripGradientFields(colors.healthBar.medium)
						StripGradientFields(colors.healthBar.high)
					end

					-- colors.bars.*: custom bars (BarTypeRegistry)
					if colors.bars then
						for barName, barSettings in pairs(colors.bars) do
							if type(barSettings) == "table" then
								-- Simple bar fill (e.g., boneShield.bar, mana.bar)
								BackfillGradientFields(barSettings.bar)

								-- Step-based fills (e.g., stagger.low/medium/heavy/extreme)
								for barKey, barEntry in pairs(barSettings) do
									if not customBarNonFillKeys[barKey] and barKey ~= "bar" then
										if barName == "stagger" then
											StripGradientFields(barEntry)
										else
											BackfillGradientFields(barEntry)
										end
									end
								end

								-- Per-node fills (e.g., defensives.nodeColors.*)
								if barSettings.nodeColors then
									for _, nodeEntry in pairs(barSettings.nodeColors) do
										BackfillGradientFields(nodeEntry)
									end
								end
							end
						end
					end

					-- colors.shared.indicatorColors.*
					if colors.shared and colors.shared.indicatorColors then
						for _, indicator in pairs(colors.shared.indicatorColors) do
							BackfillGradientFields(indicator)
						end
					end
				end
			end
		end
	end

	-- Sanitize colors.shared.nodeOrder / gradientOrder for every spec. This
	-- runs every login (not gated on a one-shot flag) so it cleans up any
	-- duplicates introduced by earlier migrations or array-index merges like
	-- Table:Merge writing a shorter default list over a longer saved list.
	-- Rules applied to each spec:
	--   * Drop any key not present in colors.shared.indicatorColors.
	--   * Drop duplicates (keep the first occurrence).
	--   * Route entries into nodeOrder vs gradientOrder based on the
	--     indicator's isGradient flag.
	--   * Append any indicatorColors keys that are missing from both lists
	--     into the appropriate list based on isGradient.
	for _, className in ipairs(classes) do
		if TwintopInsanityBarSettings and TwintopInsanityBarSettings[className] then
			for _, specSettings in pairs(TwintopInsanityBarSettings[className]) do
				if type(specSettings) == "table"
					and type(specSettings.colors) == "table"
					and type(specSettings.colors.shared) == "table"
					and type(specSettings.colors.shared.indicatorColors) == "table" then
					local shared = specSettings.colors.shared
					local ic = shared.indicatorColors

					local newNodeOrder = {}
					local newGradientOrder = {}
					local seen = {}

					local function routeKey(key)
						if type(key) ~= "string" or seen[key] then return end
						local indicator = ic[key]
						if type(indicator) ~= "table" then return end
						seen[key] = true
						if indicator.isGradient then
							table.insert(newGradientOrder, key)
						else
							table.insert(newNodeOrder, key)
						end
					end

					if type(shared.nodeOrder) == "table" then
						for _, key in ipairs(shared.nodeOrder) do
							routeKey(key)
						end
					end
					if type(shared.gradientOrder) == "table" then
						for _, key in ipairs(shared.gradientOrder) do
							routeKey(key)
						end
					end
					-- Do NOT append every key in indicatorColors here: an orphan
					-- entry (one left behind by a removed/renamed indicator that
					-- has no matching indicatorDef) would be inserted into
					-- nodeOrder and create a phantom row in the Indicator Colors
					-- panel, breaking the up/down arrow counts. New default keys
					-- are already carried into nodeOrder by Table:Merge overlaying
					-- saved settings onto the (longer) default array.

					shared.nodeOrder = newNodeOrder
					shared.gradientOrder = newGradientOrder
				end
			end
		end
	end

	-- Backfill Warlock Demonology dominionOfArgusEnd indicator (Dominion of Argus ending-soon color).
	-- Runs before defaults are merged in, so for users who already have a saved nodeOrder the new
	-- entry must be inserted here (index-based merge would otherwise drop it). Top priority.
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warlock and TwintopInsanityBarSettings.warlock.demonology then
		local spec = TwintopInsanityBarSettings.warlock.demonology
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.dominionOfArgusEnd == nil then
			-- Mirror the user's existing Dominion of Argus indicator visibility (enabled state and
			-- targeted bars/elements) so the ending-soon indicator shows where they configured it,
			-- or stays hidden if they disabled it. Fall back to defaults if it isn't present.
			local existing = spec.colors.shared.indicatorColors.dominionOfArgus
			local enabled = true
			local targets = nil
			if existing then
				enabled = existing.enabled ~= false
				targets = TRB.Functions.Table:DeepCopy(existing.targets)
			end
			if targets == nil then
				targets = {
					manaBar = { bar = true, border = false, background = false },
					soulShardsBar = { bar = false, border = false, background = false },
				}
			end
			spec.colors.shared.indicatorColors.dominionOfArgusEnd = {
				color = "FFFF0000",
				color2 = "FFFF0000",
				gradientDirection = "disabled",
				enabled = enabled,
				targets = targets,
			}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "dominionOfArgusEnd" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, 1, "dominionOfArgusEnd")
			end
		end
	end

	-- Backfill Warlock Demonology infernalBolt indicator (Infernal Bolt available color).
	-- Runs before defaults are merged in, so for users who already have a saved nodeOrder the new
	-- entry must be appended here (index-based merge would otherwise drop it). Net-new independent
	-- indicator (no paired "active" sibling), so it gets default visibility. Bottom priority.
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warlock and TwintopInsanityBarSettings.warlock.demonology then
		local spec = TwintopInsanityBarSettings.warlock.demonology
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.infernalBolt == nil then
			spec.colors.shared.indicatorColors.infernalBolt = {
				color = "FFFF00FF",
				color2 = "FFFF00FF",
				gradientDirection = "disabled",
				enabled = true,
				targets = {
					manaBar = { bar = false, border = true, background = false },
					soulShardsBar = { bar = false, border = false, background = false },
				},
			}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "infernalBolt" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, "infernalBolt")
			end
		end
	end

	-- Backfill Warlock Demonology ruination indicator (Ruination available color).
	-- Runs before defaults are merged in, so for users who already have a saved nodeOrder the new
	-- entry must be appended here (index-based merge would otherwise drop it). Net-new independent
	-- indicator (no paired "active" sibling), so it gets default visibility. Bottom priority.
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warlock and TwintopInsanityBarSettings.warlock.demonology then
		local spec = TwintopInsanityBarSettings.warlock.demonology
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.ruination == nil then
			spec.colors.shared.indicatorColors.ruination = {
				color = "FFBBFFAA",
				color2 = "FFBBFFAA",
				gradientDirection = "disabled",
				enabled = true,
				targets = {
					manaBar = { bar = false, border = true, background = false },
					soulShardsBar = { bar = false, border = false, background = false },
				},
			}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "ruination" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, "ruination")
			end
		end
	end

	-- Backfill Warrior Protection violentOutburst indicator + audio (Violent Outburst proc).
	-- Protection's shared indicator system already shipped, so an index-based merge would drop a
	-- brand-new nodeOrder entry; append it here for users with a saved nodeOrder. Bottom priority.
	if TwintopInsanityBarSettings and TwintopInsanityBarSettings.warrior and TwintopInsanityBarSettings.warrior.protection then
		local spec = TwintopInsanityBarSettings.warrior.protection
		if spec.colors and spec.colors.shared and spec.colors.shared.indicatorColors
		and spec.colors.shared.indicatorColors.violentOutburst == nil then
			spec.colors.shared.indicatorColors.violentOutburst = {
				color = "FF00FF00",
				enabled = true,
				isGradient = false,
				targets = {
					rageBar = { bar = false, border = true, background = false },
					defensivesIgnorePainTimeBar = { bar = false, border = false, background = false },
					defensivesIgnorePainAbsorbBar = { bar = false, border = false, background = false },
					defensivesShieldBlockBar = { bar = false, border = false, background = false },
				},
			}
			spec.colors.shared.nodeOrder = spec.colors.shared.nodeOrder or {}
			local nodeOrder = spec.colors.shared.nodeOrder
			local found = false
			for _, v in ipairs(nodeOrder) do
				if v == "violentOutburst" then found = true break end
			end
			if not found then
				table.insert(nodeOrder, "violentOutburst")
			end
		end
		if spec.audio and spec.audio.violentOutburst == nil then
			spec.audio.violentOutburst = {
				name = L["WarriorAudioViolentOutburstProc"],
				enabled = false,
				sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			}
		end
	end
end

---@param oldSettings table? # The raw saved-variables table to clean
---@return table # A new table containing only recognized top-level keys
function TRB.Functions.Settings:CleanupSettings(oldSettings)
	local newSettings = {}
	if oldSettings ~= nil then
		for k, v in pairs(oldSettings) do
			if  k == "manualUpdateChecks" or
				k == "profiles" or
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

	local function NormalizeOverlayFullHeight(settings)
		if type(settings) ~= "table" or type(settings.colors) ~= "table" then
			return
		end

		if type(settings.colors.bar) == "table" and type(settings.colors.bar.casting) == "table" and settings.colors.bar.casting.fullHeight == nil then
			settings.colors.bar.casting.fullHeight = false
		end
		if type(settings.colors.bar) == "table" and type(settings.colors.bar.spending) == "table" and settings.colors.bar.spending.fullHeight == nil then
			settings.colors.bar.spending.fullHeight = false
		end
		if type(settings.colors.comboPoints) == "table" and type(settings.colors.comboPoints.casting) == "table" and settings.colors.comboPoints.casting.fullHeight == nil then
			settings.colors.comboPoints.casting.fullHeight = false
		end
		if type(settings.colors.comboPoints) == "table" and type(settings.colors.comboPoints.spending) == "table" and settings.colors.comboPoints.spending.fullHeight == nil then
			settings.colors.comboPoints.spending.fullHeight = false
		end

		if type(settings.colors.healthBar) == "table" then
			if type(settings.colors.healthBar.absorb) == "table" and settings.colors.healthBar.absorb.fullHeight == nil then
				settings.colors.healthBar.absorb.fullHeight = false
			end
			if type(settings.colors.healthBar.incomingHeal) == "table" and settings.colors.healthBar.incomingHeal.fullHeight == nil then
				settings.colors.healthBar.incomingHeal.fullHeight = false
			end
			if type(settings.colors.healthBar.healAbsorb) == "table" and settings.colors.healthBar.healAbsorb.fullHeight == nil then
				settings.colors.healthBar.healAbsorb.fullHeight = false
			end
		end
	end

	NormalizeOverlayFullHeight(newSettings.core)
	for _, className in ipairs({
		"deathknight", "demonhunter", "druid", "evoker", "hunter", "mage",
		"monk", "paladin", "priest", "rogue", "shaman", "warlock", "warrior"
	}) do
		if type(newSettings[className]) == "table" then
			for _, specSettings in pairs(newSettings[className]) do
				NormalizeOverlayFullHeight(specSettings)
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
		fillDirection = "leftRight",
		anchor = {
			barKey = "screen",
			anchorPoint = "CENTER",
			attachPoint = "CENTER",
			xOffset = 0,
			yOffset = -200,
			matchWidth = false,
			matchHeight = false,
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
		fillDirection = "leftRight",
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
			matchHeight = false,
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
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
		},
	}
end

---Gets the default secondary partial-fill color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondaryPartialFillColor(enabled)
	if enabled == nil then
		enabled = false
	end

	return {
		color = "FFFF4500",
		color2 = "FFFF4500",
		gradientDirection = "disabled",
		enabled = enabled
	}
end

---Gets the default secondary casting overlay color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(enabled)
	if enabled == nil then
		enabled = true
	end

	return {
		color = "FFFFFFFF",
		color2 = "FFFFFFFF",
		gradientDirection = "disabled",
		enabled = enabled,
		fullHeight = false
	}
end

---Gets the default secondary spending overlay color configuration.
---@param enabled boolean?
---@return table
function TRB.Functions.Settings:DefaultSecondarySpendingOverlayColor(enabled)
	if enabled == nil then
		enabled = true
	end

	return {
		color = "FF555555",
		color2 = "FF555555",
		gradientDirection = "disabled",
		enabled = enabled,
		fullHeight = false
	}
end

--- Gets the default health bar color configuration including border, background, absorb, incoming heal, and step-based thresholds.
---@return table # Health bar color settings with low/medium/high color steps and overlay defaults
function TRB.Functions.Settings:DefaultHealthBarColors()
	return {
		border = { color = "FF008800" },
		background = { color = "66000000" },
		absorb = { color = "CCFFFFB9", enabled = true, mode = "appended", fullHeight = false },
		incomingHeal = { color = "CC80b980", enabled = true, mode = "appended", fullHeight = false },
		healAbsorb = { color = "CCCC4444", enabled = true, mode = "inset", fullHeight = false },
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
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
		},
	}
end

---Gets the default mana bar colors
---@return TRB.Classes.Settings.GenericBarColorsBase
function TRB.Functions.Settings:DefaultManaBarColors()
	return {
		bar = { color = "FF0000FF", color2 = "FF0000FF", gradientDirection = "disabled" },
		border = { color = "FF0000AA" },
		background = { color = "66000000" }
	}
end

---Gets default Ebon Might bar dimensions
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultEbonMightBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	dims.relativeTo = "BOTTOM"
	dims.relativeToName = L["PositionBelowMiddle"]
	dims.anchor.barKey = "health"
	dims.anchor.anchorPoint = "BOTTOM"
	dims.anchor.attachPoint = "TOP"
	return dims
end

---Gets default Ebon Might bar colors (orange bar, dark orange border)
---@return table
function TRB.Functions.Settings:DefaultEbonMightBarColors()
	local colors = self:DefaultCustomBarColors("FFFF9900", "FFCC7700", "66000000")
	colors.endingSoon = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled", enabled = true }
	colors.wontExtend = { color = "FF550000", color2 = "FF550000", gradientDirection = "disabled", enabled = true }
	return colors
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
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
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
		bar = { color = barColor or "FF0000FF", color2 = barColor or "FF0000FF", gradientDirection = "disabled" },
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
		low = { color = lowColor or "FF00FF00", color2 = lowColor or "FF00FF00", gradientDirection = "disabled", threshold = 0.0 },
		medium = { color = mediumColor or "FFFFFF00", color2 = mediumColor or "FFFFFF00", gradientDirection = "disabled", threshold = mediumThreshold or 0.30 },
		high = { color = highColor or "FFFF0000", color2 = highColor or "FFFF0000", gradientDirection = "disabled", threshold = highThreshold or 0.70 }
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
		low = { color = "FF00FF00", threshold = 0.0 },
		medium = { color = "FFFFFF00", threshold = 0.30 },
		heavy = { color = "FFFF0000", threshold = 0.60 }
	}
end

---Gets default Castbar bar dimensions (single node, full width; wider/taller default than a generic bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultCastbarBarDimensions(classic)
	local dims = self:DefaultCustomBarDimensions(classic)
	-- Castbars sit below the health bar by default so they never overlap the primary resource bar.
	dims.relativeTo = "BOTTOM"
	dims.relativeToName = L["PositionBelowMiddle"]
	dims.anchor.barKey = "health"
	dims.anchor.anchorPoint = "BOTTOM"
	dims.anchor.attachPoint = "TOP"
	return dims
end

-- Built-in channel tick profiles, keyed by [className][specName] using the lowercase settings-tree keys
-- (e.g. settings.priest.shadow). Only specs that actually have channeled spells worth tick markers get an
-- entry; every other spec intentionally has none and is seeded with an empty profile set. Users can still
-- add their own per spec via the castbar options tick-rate list. Each profile drives tick placement:
--   mode "fixedCount": tick count stays constant, channel duration scales with haste (e.g. Mind Flay).
--   mode "fixedRate": channel duration is fixed, tick rate scales with haste, final partial tick (e.g. Void Torrent).
-- baseDuration and baseTickRate are UNHASTED seconds; the render scales them by GCD-inferred haste.
---@type table<string, table<string, table<integer, TRB.Classes.Settings.CastbarTickProfile>>>
local castbarTickProfilesBySpec = {
	priest = {
		shadow = {
			-- Mind Flay: constant tick count, duration shrinks with haste.
			[15407] = { mode = "fixedCount", baseDuration = 4.5, tickCount = 6, firstTickAtStart = false, chains = true },
			-- Void Torrent: fixed 3s channel, tick rate accelerates with haste, partial final tick.
			[263165] = { mode = "fixedRate", baseDuration = 3.0, baseTickRate = 1, firstTickAtStart = true },
		},
	},
}

---Gets a fresh copy of the built-in channel tick profiles for one spec, or an empty table when the spec
---has no built-in channeled spells. Returns a DeepCopy so each spec's saved settings own their tables
---(the shared source table is never handed out or mutated).
---@param className string? # Lowercase class name matching the settings tree (e.g. "priest")
---@param specName string? # Lowercase spec name matching the settings tree (e.g. "shadow")
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Functions.Settings:DefaultCastbarTickProfilesForSpec(className, specName)
	local byClass = className and castbarTickProfilesBySpec[className]
	local profiles = byClass and specName and byClass[specName]
	if type(profiles) ~= "table" then
		return {}
	end
	return TRB.Functions.Table:DeepCopy(profiles)
end

---Gets the default Castbar bar settings (dimensions + behavior flags + per-spec tick profiles)
---@param classic boolean?
---@param className string? # Lowercase class name, for the per-spec tick profile lookup
---@param specName string? # Lowercase spec name, for the per-spec tick profile lookup
---@return TRB.Classes.Settings.CastbarBar
function TRB.Functions.Settings:DefaultCastbarBarSettings(classic, className, specName)
	local settings = self:DefaultCastbarBarDimensions(classic) --[[@as TRB.Classes.Settings.CastbarBar]]
	-- Simple opt-in flag (not tied to the displayBar/BarVisibility system): when true, the castbar
	-- shows automatically while casting/channeling/empowering and hides otherwise. No user-configurable
	-- always/never/conditions apply, since a castbar only ever makes sense while something is casting.
	settings.enabled = false
	settings.showTicks = true
	settings.showLatency = true
	settings.showPushback = true
	settings.showEmpowerStages = true
	settings.castTimePrecision = 1
	settings.durationPrecision = 1
	settings.latencyPrecision = 1
	settings.tickProfiles = self:DefaultCastbarTickProfilesForSpec(className, specName)
	return settings
end

---Gets the default Castbar colors. `bar` is the standard-cast fill; `channel` and `uninterruptible`
---recolor the fill per state. Overlay colors (latency/pushback) and tick lines are separate. Empower
---fill uses absolute per-level colors: `base` while charging toward Level I, then `level1`..`level4` as
---each empower level is reached (mapped from GetCurrentEmpowerStage at render time; game max is 4).
---@return table
function TRB.Functions.Settings:DefaultCastbarBarColors()
	return {
		bar = { color = "FFFFCC00", color2 = "FFFFCC00", gradientDirection = "disabled" },
		channel = { color = "FF00CCFF", color2 = "FF00CCFF", gradientDirection = "disabled" },
		uninterruptible = { color = "FF888888", color2 = "FF888888", gradientDirection = "disabled" },
		border = { color = "FF000000" },
		background = { color = "66000000" },
		latency = { color = "80FF0000", enabled = true },
		pushback = { color = "80FF00FF", enabled = true },
		tick = { color = "FFFFFFFF", enabled = true },
		empowerStages = {
			base = { color = "FFC8B0FF" },
			level1 = { color = "FFFFCC00" },
			level2 = { color = "FFFFAA00" },
			level3 = { color = "FFFF6600" },
			level4 = { color = "FFFF3000" }
		}
	}
end

---Central injector: adds castbar defaults (bars/colors/textures) to a spec's default settings table so
---the standard defaults->saved Table:Merge carries them into every spec of every class. Idempotent.
---Deliberately does NOT touch displayBar: the castbar's on-screen visibility is driven entirely by
---active cast state (Functions/Castbar.lua), not the displayBar/BarVisibility system.
---@param specDefaults table # A single spec's default settings table (from a class's LoadDefaultSettings)
---@param className string? # Lowercase class name, for the per-spec tick profile lookup
---@param specName string? # Lowercase spec name, for the per-spec tick profile lookup
---@param classic boolean?
function TRB.Functions.Settings:InjectCastbarDefaults(specDefaults, className, specName, classic)
	if type(specDefaults) ~= "table" then
		return
	end

	-- Dimensions + behavior under bars.castbar
	specDefaults.bars = specDefaults.bars or {}
	if specDefaults.bars.castbar == nil then
		specDefaults.bars.castbar = self:DefaultCastbarBarSettings(classic, className, specName)
	end

	-- Colors under colors.bars.castbar
	specDefaults.colors = specDefaults.colors or {}
	specDefaults.colors.bars = specDefaults.colors.bars or {}
	if specDefaults.colors.bars.castbar == nil then
		specDefaults.colors.bars.castbar = self:DefaultCastbarBarColors()
	end

	-- Flat texture keys castbarBar / castbarBorder / castbarBackground
	specDefaults.textures = specDefaults.textures or {}
	if specDefaults.textures.castbarBar == nil then
		local tex = self:DefaultCustomBarTextures()
		specDefaults.textures.castbarBar = tex.bar
		specDefaults.textures.castbarBarName = tex.barName
		specDefaults.textures.castbarBorder = tex.border
		specDefaults.textures.castbarBorderName = tex.borderName
		specDefaults.textures.castbarBackground = tex.background
		specDefaults.textures.castbarBackgroundName = tex.backgroundName
	end
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
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
		},
	}
end

---Gets default Warrior Defensives bar colors
---@return table
function TRB.Functions.Settings:DefaultDefensivesBarColors()
	return {
		border = { color = "FFC21807" },
		background = { color = "66000000" },
		nodeOrder = { "ignorePain", "ignorePainAbsorb", "shieldBlock" },
		nodeColors = {
			ignorePain = { color = "FFFFD000", color2 = "FFFFD000", gradientDirection = "disabled", enabled = true },
			ignorePainAbsorb = { color = "FFFF9800", color2 = "FFFF9800", gradientDirection = "disabled", enabled = true },
			shieldBlock = { color = "FF0099FF", color2 = "FF0099FF", gradientDirection = "disabled", enabled = true }
		}
	}
end

---Gets default Holy Words bar dimensions (anchored above primary bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultHolyWordsBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
		},
	}
end

---Gets default Holy Words bar colors
---@return table
function TRB.Functions.Settings:DefaultHolyWordsBarColors()
	return {
		border = { color = "FF000099" },
		background = { color = "66000000" },
		nodeOrder = { "holyWordSerenity", "holyWordSanctify", "holyWordChastise" },
		nodeColors = {
			holyWordSerenity = { color = "FF00DDDD", color2 = "FF00DDDD", gradientDirection = "disabled", enabled = true },
			holyWordSanctify = { color = "FFFFDD22", color2 = "FFFFDD22", gradientDirection = "disabled", enabled = true },
			holyWordChastise = { color = "FFFF8080", color2 = "FFFF8080", gradientDirection = "disabled", enabled = true }
		},
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
			fillDirection = "leftRight",
			growthDirection = "leftRight",
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
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
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
			matchHeight = false,
		},
	}
end

---Gets default Fire Blast Charges bar colors (Fire Mage)
---@return table
function TRB.Functions.Settings:DefaultFireBlastChargesBarColors()
	return {
		border = { color = "FFFF7878" },
		background = { color = "66000000" },
		regenerating = TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false),
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FFFF8800", color2 = "FFFF8800", gradientDirection = "disabled" },
			charge2 = { color = "FFFF6600", color2 = "FFFF6600", gradientDirection = "disabled" },
			charge3 = { color = "FFFF4400", color2 = "FFFF4400", gradientDirection = "disabled" },
		},
	}
end

---Gets default Whirlwind stacks bar colors (Fury Warrior)
---@return table
function TRB.Functions.Settings:DefaultWhirlwindBarColors()
	return {
		border = { color = "FFFFD300" },
		background = { color = "66000000" },
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FFFFFFAA", color2 = "FFFFFFAA", gradientDirection = "disabled" },
			charge2 = { color = "FFFFFF00", color2 = "FFFFFF00", gradientDirection = "disabled" },
			charge3 = { color = "FFFF9900", color2 = "FFFF9900", gradientDirection = "disabled" },
			charge4 = { color = "FFFF0000", color2 = "FFFF0000", gradientDirection = "disabled" },
		},
		zeroStackBackground = {
			color = "B3FF5E5E",
			enabled = true
		}
	}
end

---Gets default Utility bar colors (generic; class modules should override via BarTypeRegistry)
---@return table
function TRB.Functions.Settings:DefaultUtilityBarColors()
	return {
		border = { color = "FF888888" },
		background = { color = "66000000" },
		nodeColors = {
			charge1 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true },
			charge2 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true },
			charge3 = { color = "FFAAAAAA", color2 = "FFAAAAAA", gradientDirection = "disabled", enabled = true }
		}
	}
end

---Gets default Lightweaver bar dimensions (anchored above Holy Words bar)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultLightweaverBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			fillDirection = "leftRight",
			growthDirection = "leftRight",
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "holyWords",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "holyWords",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Lightweaver bar colors (progressively darker blue per stack)
---@return table
function TRB.Functions.Settings:DefaultLightweaverBarColors()
	return {
		border = { color = "FF4466CC" },
		background = { color = "66000000" },
		sameColor = false,
		nodeColors = {
			charge1 = { color = "FF88CCFF", color2 = "FF88CCFF", gradientDirection = "disabled" },
			charge2 = { color = "FF55AAFF", color2 = "FF55AAFF", gradientDirection = "disabled" },
			charge3 = { color = "FF3388EE", color2 = "FF3388EE", gradientDirection = "disabled" },
			charge4 = { color = "FF1166CC", color2 = "FF1166CC", gradientDirection = "disabled" },
		}
	}
end

---Gets default Bone Shield bar dimensions (Blood Death Knight, anchored above runes)
---@param classic boolean?
---@return TRB.Classes.Settings.SecondaryBar
function TRB.Functions.Settings:DefaultBoneShieldBarDimensions(classic)
	if classic then
		return {
			width = 25,
			height = 13,
			xPos = 0,
			yPos = 4,
			border = 1,
			spacing = 14,
			collapseBorderWidth = false,
			fillDirection = "leftRight",
			growthDirection = "leftRight",
			relativeTo = "TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth = true,
			anchor = {
				barKey = "secondary",
				anchorPoint = "TOP",
				attachPoint = "BOTTOM",
				xOffset = 0,
				yOffset = 4,
				matchWidth = true,
				matchHeight = false,
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
		fillDirection = "leftRight",
		growthDirection = "leftRight",
		relativeTo = "TOP",
		relativeToName = L["PositionAboveMiddle"],
		fullWidth = true,
		anchor = {
			barKey = "secondary",
			anchorPoint = "TOP",
			attachPoint = "BOTTOM",
			xOffset = 0,
			yOffset = 0,
			matchWidth = true,
			matchHeight = false,
		},
	}
end

---Gets default Bone Shield bar colors (Blood Death Knight)
---@return table
function TRB.Functions.Settings:DefaultBoneShieldBarColors()
	return {
		bar = { color = "FF8DD48D", color2 = "FF8DD48D", gradientDirection = "disabled" },
		ossuary = { color = "FFB8FFB8", color2 = "FFB8FFB8", gradientDirection = "disabled", enabled = true },
		ossuaryThreshold = { color = "FF404040", color2 = "FF404040", gradientDirection = "disabled", enabled = true },
		border = { color = "FF205E20" },
		background = { color = "66000000" }
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
		-- When forceResync is true but the anchor block already has a valid barKey,
		-- trust it over stale legacy fields (fixes export/import losing screen anchors).
		if barSettings.anchor ~= nil and barSettings.anchor.barKey ~= nil then return end
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
					matchHeight = false,
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
				matchHeight = false,
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
		healAbsorbBar="Interface\\Buttons\\WHITE8X8",
		healAbsorbBarName="Solid",
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

---Marks a bar text entry to inherit all shared font settings by default.
---@param entry TRB.Classes.Settings.DisplayTextEntry
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry(entry)
	if entry ~= nil then
		entry.useDefaultFontColor = true
		entry.useDefaultFontFace = true
		entry.useDefaultFontSize = true
		entry.useDefaultFontOutline = true
		entry.useDefaultFontShadow = true
	end
	return entry
end

---Marks all bar text entries in a list to inherit shared font settings by default.
---@param textSettings TRB.Classes.Settings.DisplayTextEntry[]
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
	if textSettings ~= nil then
		for _, entry in ipairs(textSettings) do
			TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry(entry)
		end
	end
	return textSettings
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

		return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntry({
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = name,
			guid = TRB.Functions.String:Guid(),
			text = "{$" .. variable .. "}[#" .. icon .. "$" .. variable .. "]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = position,
			fontJustifyHorizontalName = fontJustifyHorizontalName,
			fontSize = 14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = xPos,
				yPos = 0,
				relativeTo = position,
				relativeToName = fontJustifyHorizontalName,
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		})
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
		relativeToName = L["ThresholdIconPositionBelowRight"],
		enabled = true,
		desaturated = true,
		xPos = 0,
		yPos = 12,
		width = 24,
		height = 24
	}
end

---Creates default per-threshold settings for a threshold dictionary entry.
---When `enabled` is false on a sub-entry (audio, individual color, icon, line),
---the global setting is used instead.
---@param isEnabled boolean # Whether the threshold is enabled by default
---@return TRB.Classes.Settings.ThresholdDictionaryEntry
function TRB.Functions.Settings:DefaultThresholdDictionaryEntry(isEnabled)
	return {
		enabled = isEnabled,
		audio = {
			enabled = false,
			sound = "",
			soundName = "",
		},
		colors = {
			under = {
				color = "FFFFFFFF",
				mode = "shared",
			},
			over = {
				color = "FF00FF00",
				mode = "shared",
			},
			unusable = {
				color = "FFFF0000",
				mode = "shared",
			},
			outOfRange = {
				color = "FF440000",
				mode = "shared",
			},
		},
		icon = {
			enabled = false,
			show = true,
			width = 24,
			height = 24,
			xPos = 0,
			yPos = 12,
			relativeTo = "BOTTOM",
			desaturated = true,
			border = 2,
		},
		line = {
			enabled = false,
			width = 2,
			overlapBorder = true,
		},
	}
end

---Creates default threshold line colors.
---@return TRB.Classes.Settings.ThresholdColors
function TRB.Functions.Settings:DefaultThresholdColors()
	return {
		under = {
			color = "FFFFFFFF"
		},
		over = {
			color = "FF00FF00"
		},
		unusable = {
			color = "FFFF0000",
			enabled = true,
			show = true
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
end

---Creates default specialization threshold settings.
---@return TRB.Classes.Settings.Thresholds
function TRB.Functions.Settings:DefaultThresholdSettings()
	return {
		properties = {
			width = 2,
			overlapBorder = true,
		},
		icons = TRB.Functions.Settings:DefaultThresholdIconSettings(),
		specProperties = {},
		thresholdDictionary = {},
		customThresholds = {},
	}
end

---@param entry TRB.Classes.Settings.ThresholdDictionaryEntry?
---@param isEnabled boolean?
---@return TRB.Classes.Settings.ThresholdDictionaryEntry
function TRB.Functions.Settings:NormalizeThresholdDictionaryEntry(entry, isEnabled)
	local defaultEntry = TRB.Functions.Settings:DefaultThresholdDictionaryEntry(isEnabled == true)
	if type(entry) ~= "table" then
		return defaultEntry
	end

	-- Backfill defaults into the EXISTING entry while preserving its table identity
	-- (and the identity of every nested table). The options color pickers capture
	-- references to entry.colors.under/over/staticColor; replacing the entry with a
	-- fresh DeepMergeCopy table would orphan those references, so live edits would
	-- neither apply in real time nor persist to disk. DeepMergeInto mutates in place.
	local merged = TRB.Functions.Table:DeepMergeCopy(defaultEntry, entry)
	TRB.Functions.Table:DeepMergeInto(entry, merged)
	return entry
end

---Custom thresholds use the shared thresholdDictionary entry shape, but a namespaced key
---keeps them from colliding with predefined spell threshold setting keys.
---@param guid string?
---@return string?
function TRB.Functions.Settings:GetCustomThresholdDictionaryKey(guid)
	if guid == nil then
		return nil
	end

	local key = tostring(guid)
	local prefix = "custom:"
	if string.sub(key, 1, string.len(prefix)) == prefix then
		return key
	end

	return prefix .. key
end

---@param customThreshold table?
---@param guid string?
---@return TRB.Classes.Settings.CustomThresholdLine
function TRB.Functions.Settings:NormalizeCustomThresholdLine(customThreshold, guid)
	local line = customThreshold
	if type(line) ~= "table" then
		line = {}
	end

	local resolvedGuid = line.guid or guid or TRB.Functions.String:Guid()
	line.guid = resolvedGuid
	line.name = line.name or L["CustomThresholdDefaultName"]
	line.barTarget = line.barTarget or "primary"
	line.value = tonumber(line.value) or 0
	line.valueMode = (line.valueMode == "offset") and "offset" or "absolute"
	line.iconSourceType = line.iconSourceType or "none"
	if line.iconSourceType ~= "spell" and line.iconSourceType ~= "item" and line.iconSourceType ~= "icon" and line.iconSourceType ~= "none" then
		line.iconSourceType = "none"
	end
	line.iconSourceId = tonumber(line.iconSourceId) or 0

	return line --[[@as TRB.Classes.Settings.CustomThresholdLine]]
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$health/$healthMax $healthPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$healthPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$health",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			color = {
				color = "fffe7878",
			},
			fontSize = 48,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
		},
	}

	local extraTextSettings = TRB.Functions.Settings:LoadDefaultHealthBarTextSettings(classic)

	for x = 1, #extraTextSettings do
		table.insert(textSettings, extraTextSettings[x])
	end
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$mana/$manaMax $manaPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=13,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionLeft"],
			guid = TRB.Functions.String:Guid(),
			text="$manaPercent%",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = L["PositionRight"],
			guid = TRB.Functions.String:Guid(),
			text="$mana",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

---Returns default bar text for Fire Mage Fire Blast charge nodes.
---@return TRB.Classes.Settings.DisplayTextEntry[]
function TRB.Functions.Settings:LoadDefaultFireBlastChargeBarTextSettings()
	---@type TRB.Classes.Settings.DisplayTextEntry[]
	local textSettings = {}
	local chargeFrameNames = {
		L["MageFireFireBlastCharge1"],
		L["MageFireFireBlastCharge2"],
		L["MageFireFireBlastCharge3"],
	}

	for chargeIndex = 1, 3 do
		table.insert(textSettings, {
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			useDefaultFontOutline = false,
			useDefaultFontShadow = false,
			enabled = true,
			name = "FB" .. chargeIndex,
			guid = TRB.Functions.String:Guid(),
			text = "{$fireBlastChargesMax=" .. chargeIndex .. "&$fireBlastTime}[$fireBlastTime]",
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize = 14,
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
			color = { color = "FFFFFFFF" },
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "CENTER",
				relativeToName = L["PositionCenter"],
				relativeToFrame = "FireBlastCharge_" .. chargeIndex,
				relativeToFrameName = chargeFrameNames[chargeIndex],
			}
		})
	end

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
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
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]$resource",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=20,
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionMiddle"],
				guid = TRB.Functions.String:Guid(),
				text="$resource",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "CENTER",
				fontJustifyHorizontalName = L["PositionCenter"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="{$casting}[#casting$casting+]$mana/$manaMax $manaPercent%",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionLeft"],
				guid = TRB.Functions.String:Guid(),
				text="$manaPercent%",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "LEFT",
				fontJustifyHorizontalName = L["PositionLeft"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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
				useDefaultFontOutline = false,
				useDefaultFontShadow = false,
				enabled = true,
				name = L["PositionRight"],
				guid = TRB.Functions.String:Guid(),
				text="$mana",
				fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
				fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
				fontJustifyHorizontal = "RIGHT",
				fontJustifyHorizontalName = L["PositionRight"],
				fontSize=16,
				fontOutline = "OUTLINE",
				fontOutlineName = L["FontOutlineOutline"],
				fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 },
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

	return TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(textSettings)
end

---Shows a message in chat informing the user that their bar text has been reset due to Midnight changes.
---@param className string
function TRB.Functions.Settings:ShowMidnightBarTextResetMessage(className)
	print(string.format(L["MidnightBarTextResetMessage"], className))
end
