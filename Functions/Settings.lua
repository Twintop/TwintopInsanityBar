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
    dotColors = false,
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
			ttd = {
				sampleRate = 0.2,
				numEntries = 50,
				precision = 1
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
				alwaysShow = false,
				notZeroShow = true,
				neverShow = false,
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
					overcap = {
						color = "FFFF0000",
						enabled = true
					},
					overThreshold = {
						color = "FF00FF00",
						enabled = false
					},
                    dots = {
                        options = {
                            enabled = true,
                        },
                        up = {
                            color = "FFFFFFFF"
                        },
                        down = {
                            color = "FFFF0000"
                        },
                        pandemic = {
                            color = "FFFFFF00"
                        }
                    }
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
				},
				thresholdHealers = {
					over = {
						color = "FF00FF00"
					},
					unusable = {
						color = "FFFF0000"
					},
					passive = {
						color = "FF8080FF"
					}
				},
				endCap = {
					base = {
						color = "FFFFFFFF",
						enabled = false,
						width = 2,
						useBorderColor = false,
						useBorderColorExceptDefault = false
					}
				}
			},
			textures={
				background = "Interface\\Tooltips\\UI-Tooltip-Background",
				backgroundName = "Blizzard Tooltip",
				border = "Interface\\Buttons\\WHITE8X8",
				borderName = "1 Pixel",
				resourceBar = "Interface\\TargetingFrame\\UI-StatusBar",
				resourceBarName = "Blizzard",
				passiveBar = "Interface\\TargetingFrame\\UI-StatusBar",
				passiveBarName = "Blizzard",
				castingBar = "Interface\\TargetingFrame\\UI-StatusBar",
				castingBarName = "Blizzard",
				textureLock = true,
				comboPointsBackground = "Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName = "Blizzard Tooltip",
				comboPointsBorder = "Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName = "1 Pixel",
				comboPointsBar = "Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName = "Blizzard",
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
			fury = {}
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
		TwintopInsanityBarSettings.druid.balance.starsurgeThreshold = nil
		TwintopInsanityBarSettings.druid.balance.starsurge2Threshold = nil
		TwintopInsanityBarSettings.druid.balance.starsurge3Threshold = nil
		TwintopInsanityBarSettings.druid.balance.starfallThreshold = nil
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
									fontFace = "Fonts\\FRIZQT__.TTF",
									fontFaceName = "Friz Quadrata TT",
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
											fontFace = "Fonts\\FRIZQT__.TTF",
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionCenter"],
											text = "{$predatorRevealedNextCp=($comboPoints+1)&$comboPoints=0}[$predatorRevealedTickTime]{$incarnationNextCp=($comboPoints+1)&$comboPoints=0}[$incarnationTickTime]",
											fontFaceName = "Friz Quadrata TT",
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
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
										},
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
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
											fontFace = "Fonts\\FRIZQT__.TTF",
											useDefaultFontFace = false,
											guid = TRB.Functions.String:Guid(),
											fontJustifyHorizontalName = L["PositionLeft"],
											text = "{$hwSerenityTime&$hwSerenityCharges=0}[$hwSerenityTime]",
											fontFaceName = "Friz Quadrata TT",
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
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
											useDefaultFontColor = false,
										},
										{
											enabled = enabled,
											fontFace = "Fonts\\FRIZQT__.TTF",
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
											fontFaceName = "Friz Quadrata TT",
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
											enabled = enabled,
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
											enabled = enabled,
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
											enabled = enabled,
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
											enabled = enabled,
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
											enabled = enabled,
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
			dragAndDrop = false,
			pinToPersonalResourceDisplay = false
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
								spec.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow = spec.thresholds.shadowWordMadnessThresholdOnlyOverShow
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
end

function TRB.Functions.Settings:CleanupSettings(oldSettings)
	local newSettings = {}
	if oldSettings ~= nil then
		for k, v in pairs(oldSettings) do
			if  k == "core" or
				k == "demonhunter" or
				k == "deathknight" or
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