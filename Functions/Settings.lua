local _, TRB = ...
local L = TRB.Localization

TRB.Functions.Settings = {}

local specGlobalDefaults = {
	--specEnable = false,
	--bar = false,
	--comboPoints = false,
	--displayBar = false,
	displayText = false,
	textColors = false,
    dotColors = false,
	--textures = false,
	--thresholds = false
}

function TRB.Functions.Settings:LoadDefaultSettings()
	local settings = {
		core = {
			dataRefreshRate = 5.0,
			reactionTime = 0.1,
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
				channel={
					name=L["AudioChannelMaster"],
					channel="Master"
				}
			},
			strata={
				level="BACKGROUND",
				name=L["StrataBackground"]
			},
			timers = {
				precisionLow = 1,
				precisionHigh = 0,
				precisionThreshold = 5
			},
			thresholds = {
				width = 2,
				overlapBorder=true,
				outOfRange=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = L["PositionAbove"],
					enabled=true,
					desaturated=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				}
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false,
				dragonriding=true
			},
			bar = {
				width=1555,
				height=34,
				xPos=0,
				yPos=200,
				border=4,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true,
				smooth=false
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
                            enabled=true,
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
			},
			comboPoints = {
				width=25,
				height=13,
				xPos=0,
				yPos=4,
				border=1,
				spacing=14,
				relativeTo="TOP",
				relativeToName = L["PositionAboveMiddle"],
				fullWidth=false,
			},
			textures={
				background="Interface\\Tooltips\\UI-Tooltip-Background",
				backgroundName="Blizzard Tooltip",
				border="Interface\\Buttons\\WHITE8X8",
				borderName="1 Pixel",
				resourceBar="Interface\\TargetingFrame\\UI-StatusBar",
				resourceBarName="Blizzard",
				passiveBar="Interface\\TargetingFrame\\UI-StatusBar",
				passiveBarName="Blizzard",
				castingBar="Interface\\TargetingFrame\\UI-StatusBar",
				castingBarName="Blizzard",
				textureLock=true,
				comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName="Blizzard Tooltip",
				comboPointsBorder="Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName="1 Pixel",
				comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName="Blizzard",
			},
			displayText={
				default = {
					fontFace="Fonts\\FRIZQT__.TTF",
					fontFaceName="Friz Quadrata TT",
					fontJustifyHorizontal = "LEFT",
					fontJustifyHorizontalName = L["PositionLeft"],
					fontSize=18,
					color = "FFFFFFFF",
				},
				barText = {}
			},
			global = {
				globalEnable = false,
				demonhunter = {
					havoc = specGlobalDefaults,
					vengeance = specGlobalDefaults
				},
				druid = {
					balance = specGlobalDefaults,
					feral = specGlobalDefaults,
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
					mistweaver = specGlobalDefaults,
					windwalker = specGlobalDefaults
				},
				paladin = {
					holy = specGlobalDefaults,
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
					affliction = specGlobalDefaults
				},
				warrior = {
					arms = specGlobalDefaults,
					fury = specGlobalDefaults
				}
			},
			enabled = {
				demonhunter = {
					havoc = true,
					vengeance = true
				},
				druid = {
					balance = true,
					feral = true,
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
					mistweaver = true,
					windwalker = true
				},
				paladin = {
					holy = true
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
					affliction = true
				},
				warrior = {
					arms = true,
					fury = true
				}
			},
			experimental = {
				specs = {
					shaman = {
						enhancement = false
					}
				}
			}
		},
		demonhunter = {
			havoc = {},
			vengeance = {}
		},
		druid = {
			balance = {},
			feral = {},
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
			mistweaver = {},
			windwalker = {}
		},
		paladin = {
			holy = {}
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
			affliction = {}
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
		TwintopInsanityBarSettings.shaman.elemental.thresholds.elementalBlast == nil then

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
		TwintopInsanityBarSettings.priest.shadow.resourcePrecision = TwintopInsanityBarSettings.priest.shadow.insanityPrecision
		TwintopInsanityBarSettings.priest.shadow.insanityPrecision = nil
	end

	-- Rename ragePrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.arms ~= nil and
		TwintopInsanityBarSettings.warrior.arms.ragePrecision ~= nil
		then
		TwintopInsanityBarSettings.warrior.arms.resourcePrecision = TwintopInsanityBarSettings.warrior.arms.ragePrecision
		TwintopInsanityBarSettings.warrior.arms.ragePrecision = nil
	end

	-- Rename ragePrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.warrior ~= nil and
		TwintopInsanityBarSettings.warrior.fury ~= nil and
		TwintopInsanityBarSettings.warrior.fury.ragePrecision ~= nil
		then
		TwintopInsanityBarSettings.warrior.fury.resourcePrecision = TwintopInsanityBarSettings.warrior.fury.ragePrecision
		TwintopInsanityBarSettings.warrior.fury.ragePrecision = nil
	end

	-- Rename astralPowerPrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.balance ~= nil and
		TwintopInsanityBarSettings.druid.balance.astralPowerPrecision ~= nil
		then
		TwintopInsanityBarSettings.druid.balance.resourcePrecision = TwintopInsanityBarSettings.druid.balance.astralPowerPrecision
		TwintopInsanityBarSettings.druid.balance.astralPowerPrecision = nil
	end

	-- Rename furyPrecision to resourcePrecision
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.demonhunter ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc ~= nil and
		TwintopInsanityBarSettings.demonhunter.havoc.furyPrecision ~= nil
		then
		TwintopInsanityBarSettings.demonhunter.havoc.resourcePrecision = TwintopInsanityBarSettings.demonhunter.havoc.furyPrecision
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
									fontFace="Fonts\\FRIZQT__.TTF",
									fontFaceName="Friz Quadrata TT",
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
										guid=TRB.Functions.String:Guid(),
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
										guid=TRB.Functions.String:Guid(),
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
										guid=TRB.Functions.String:Guid(),
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

									---@type TRB.Classes.DisplayTextEntry[]
									local extraTextSettings = {
										{
											enabled = enabled,
											useDefaultFontColor = false,
											fontFace = "Fonts\\FRIZQT__.TTF",
											useDefaultFontFace = false,
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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

									---@type TRB.Classes.DisplayTextEntry[]
									local extraTextSettings = {
										{
											useDefaultFontColor = false,
											fontFace = "Fonts\\FRIZQT__.TTF",
											useDefaultFontFace = false,
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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

									---@type TRB.Classes.DisplayTextEntry[]
									local extraTextSettings = {
										{
											enabled = enabled,
											fontFace = "Fonts\\FRIZQT__.TTF",
											useDefaultFontFace = false,
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
											guid=TRB.Functions.String:Guid(),
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
		TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquakeTargeted == nil then

		TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquakeTargeted = {
			enabled = TwintopInsanityBarSettings.shaman.elemental.thresholds.earthquake.enabled
		}
	end

	-- Mindbender threshold for Discipline
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.discipline ~= nil and
	TwintopInsanityBarSettings.priest.discipline.thresholds ~= nil and
	TwintopInsanityBarSettings.priest.discipline.thresholds.mindbender == nil then
		TwintopInsanityBarSettings.priest.discipline.thresholds.mindbender = {
			enabled = TwintopInsanityBarSettings.priest.discipline.thresholds.shadowfiend
		}
	end

	-- Voidwraith threshold for Discipline
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.priest ~= nil and
		TwintopInsanityBarSettings.priest.discipline ~= nil and
		TwintopInsanityBarSettings.priest.discipline.thresholds ~= nil and
		TwintopInsanityBarSettings.priest.discipline.thresholds.voidwraith == nil then

		TwintopInsanityBarSettings.priest.discipline.thresholds.voidwraith = {
			enabled = TwintopInsanityBarSettings.priest.discipline.thresholds.shadowfiend
		}
	end

	-- Ravage thresholds for Feral
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.druid ~= nil and
		TwintopInsanityBarSettings.druid.feral ~= nil and
		TwintopInsanityBarSettings.druid.feral.thresholds ~= nil and
		TwintopInsanityBarSettings.druid.feral.thresholds.ravage == nil then

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
		TwintopInsanityBarSettings.rogue.outlaw.thresholds.coupDeGrace == nil then

		TwintopInsanityBarSettings.rogue.outlaw.thresholds.coupDeGrace = {
			enabled = TwintopInsanityBarSettings.rogue.outlaw.thresholds.dispatch
		}
	end

	-- Coup de Grace thresholds for Subtlety
	if TwintopInsanityBarSettings ~= nil and
		TwintopInsanityBarSettings.rogue ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.thresholds ~= nil and
		TwintopInsanityBarSettings.rogue.subtlety.thresholds.coupDeGrace == nil then

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

	-- Global color settings refactor
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.discipline ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors.text.current ~= nil and
	type(TwintopInsanityBarSettings.priest.discipline.colors.text.current) == "string" then
		TwintopInsanityBarSettings.priest.discipline.colors.text.current = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.current,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.discipline.colors.text.casting = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.casting,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.discipline.colors.text.passive = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.passive,
			enabled = true
		}
	end
    
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.discipline ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors.text.dots ~= nil and
	TwintopInsanityBarSettings.priest.discipline.colors.text.dots.up ~= nil and
	type(TwintopInsanityBarSettings.priest.discipline.colors.text.dots.up) == "string" then
		TwintopInsanityBarSettings.priest.discipline.colors.text.dots.options = {
			enabled = TwintopInsanityBarSettings.priest.discipline.colors.text.dots.enabled
		}
		TwintopInsanityBarSettings.priest.discipline.colors.text.dots.up = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.dots.up
		}
		TwintopInsanityBarSettings.priest.discipline.colors.text.dots.down = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.dots.down
		}
		TwintopInsanityBarSettings.priest.discipline.colors.text.dots.pandemic = {
			color = TwintopInsanityBarSettings.priest.discipline.colors.text.dots.pandemic
		}
        TwintopInsanityBarSettings.priest.discipline.colors.text.dots.enabled = nil
	end
	
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.holy ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors.text.current ~= nil and
	type(TwintopInsanityBarSettings.priest.holy.colors.text.current) == "string" then
		TwintopInsanityBarSettings.priest.holy.colors.text.current = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.current,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.holy.colors.text.casting = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.casting,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.holy.colors.text.passive = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.passive,
			enabled = true
		}
	end
    
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.holy ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors.text.dots ~= nil and
	TwintopInsanityBarSettings.priest.holy.colors.text.dots.up ~= nil and
	type(TwintopInsanityBarSettings.priest.holy.colors.text.dots.up) == "string" then
		TwintopInsanityBarSettings.priest.holy.colors.text.dots.options = {
			enabled = TwintopInsanityBarSettings.priest.holy.colors.text.dots.enabled
		}
		TwintopInsanityBarSettings.priest.holy.colors.text.dots.up = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.dots.up
		}
		TwintopInsanityBarSettings.priest.holy.colors.text.dots.down = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.dots.down
		}
		TwintopInsanityBarSettings.priest.holy.colors.text.dots.pandemic = {
			color = TwintopInsanityBarSettings.priest.holy.colors.text.dots.pandemic
		}
        TwintopInsanityBarSettings.priest.holy.colors.text.dots.enabled = nil
	end
	
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.shadow ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text.current ~= nil and
	type(TwintopInsanityBarSettings.priest.shadow.colors.text.current) == "string" then
		TwintopInsanityBarSettings.priest.shadow.colors.text.current = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.current,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.casting = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.casting,
			enabled = true
		}
		--[[TwintopInsanityBarSettings.priest.shadow.colors.text.spending = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.spending,
			enabled = true
		}]]
		TwintopInsanityBarSettings.priest.shadow.colors.text.passive = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.passive,
			enabled = true
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.overcap = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.overcap,
			enabled = TwintopInsanityBarSettings.priest.shadow.colors.text.overcapEnabled
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.overThreshold = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.overThreshold,
			enabled = TwintopInsanityBarSettings.priest.shadow.colors.text.overThresholdEnabled
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.overcapEnabled = nil
		TwintopInsanityBarSettings.priest.shadow.colors.text.overThresholdEnabled = nil
	end
    
	if TwintopInsanityBarSettings ~= nil and
	TwintopInsanityBarSettings.priest ~= nil and
	TwintopInsanityBarSettings.priest.shadow ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text.dots ~= nil and
	TwintopInsanityBarSettings.priest.shadow.colors.text.dots.up ~= nil and
	type(TwintopInsanityBarSettings.priest.shadow.colors.text.dots.up) == "string" then
		TwintopInsanityBarSettings.priest.shadow.colors.text.dots.options = {
			enabled = TwintopInsanityBarSettings.priest.shadow.colors.text.dots.enabled
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.dots.up = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.dots.up
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.dots.down = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.dots.down
		}
		TwintopInsanityBarSettings.priest.shadow.colors.text.dots.pandemic = {
			color = TwintopInsanityBarSettings.priest.shadow.colors.text.dots.pandemic
		}
        TwintopInsanityBarSettings.priest.shadow.colors.text.dots.enabled = nil
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