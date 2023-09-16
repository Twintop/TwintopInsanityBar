---@diagnostic disable: undefined-field
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	local oUi = TRB.Data.constants.optionsUi
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local leftTextFrame = TRB.Frames.leftTextFrame
	local middleTextFrame = TRB.Frames.middleTextFrame
	local rightTextFrame = TRB.Frames.rightTextFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame

	TRB.Options.Priest = {}
	TRB.Options.Priest.Discipline = {}
	TRB.Options.Priest.Holy = {}
	TRB.Options.Priest.Shadow = {}


	local function DisciplineLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			},
			middle={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			},
			right={
				text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			}
		}

		return textSettings
	end

	local function DisciplineLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$potionCooldown}[#potionOfFrozenFocus $potionCooldown]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text = "",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$mana/$manaMax $manaPercent%",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 16
			}
		}

		return textSettings
	end

	local function DisciplineLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholds = {
				width = 2,
				overlapBorder=true,
				outOfRange=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					desaturated=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				aeratedManaPotionRank1 = {
					enabled = false, -- 1
				},
				aeratedManaPotionRank2 = {
					enabled = false, -- 2
				},
				aeratedManaPotionRank3 = {
					enabled = true, -- 3
				},
				potionOfFrozenFocusRank1 = {
					enabled = false, -- 4
				},
				potionOfFrozenFocusRank2 = {
					enabled = false, -- 5
				},
				potionOfFrozenFocusRank3 = {
					enabled = true, -- 6
				},
				conjuredChillglobe = {
					enabled = true, -- 7
					cooldown = true
				},
				shadowfiend = {
					enabled = true, -- 8
					cooldown = false
				},
				mindbender = {
					enabled = true, -- 9
					cooldown = false
				},
				potionCooldown = {
					enabled=true,
					mode="time",
					gcdsMax=40,
					timeMax=60
				},
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			bar = {
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true
			},
			shadowfiend={
				mode="time",
				swingsMax=4,
				gcdsMax=2,
				timeMax=15.0,
				enabled=true
			},
			passiveGeneration = {
				innervate = true,
				manaTideTotem = true,
				symbolOfHope = true
			},
			colors={
				text={
					current="FF4D4DFF",
					casting="FFFFFFFF",
					passive="FF8080FF",
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
					dots={
						enabled=true,
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFFFF00"
					}
				},
				bar={
					border="FF000099",
					background="66000000",
					base="FF0000FF",
					innervate="FF00FF00",
					potionOfChilledClarity="FF9EC51E",
					surgeOfLight1="FFFCE58E",
					surgeOfLight2="FFAF9942",
					spending="FFFFFFFF",
					passive="FF8080FF",
					surgeOfLightBorderChange1=true,
					surgeOfLightBorderChange2=true,
					innervateBorderChange=true,
					potionOfChilledClarityBorderChange=true,
				},
				threshold={
					unusable="FFFF0000",
					over="FF00FF00",
					mindbender="FF8080FF",
					outOfRange="FF440000"
				}
			},
			displayText={},
			audio={
				innervate={
					name = "Innervate",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				surgeOfLight={
					name = "Innervate (1 stack)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				surgeOfLight2={
					name = "Innervate (2 stacks)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				}
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
				textureLock=true
			}
		}

		settings.displayText = DisciplineLoadDefaultBarTextSimpleSettings()
		return settings
	end


	local function HolyLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			},
			middle={
				text="{$apotheosisTime}[$apotheosisTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			},
			right={
				text="{$casting}[#casting$casting + ]{$passive}[$passive + ]$mana/$manaMax $manaPercent%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=16
			}
		}

		return textSettings
	end

	local function HolyLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$hwSanctifyTime}[#hwSanctify $hwSanctifyTime][          ]    {$potionCooldown}[#potionOfFrozenFocus $potionCooldown]||n{$hwSerenityTime}[#hwSerenity $hwSerenityTime] ",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text = "{$apotheosisTime}[#apotheosis $apotheosisTime #apotheosis]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$mana/$manaMax $manaPercent%",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 16
			}
		}

		return textSettings
	end

	local function HolyLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholds = {
				width = 2,
				overlapBorder=true,
				outOfRange=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					desaturated=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				aeratedManaPotionRank1 = {
					enabled = false, -- 1
				},
				aeratedManaPotionRank2 = {
					enabled = false, -- 2
				},
				aeratedManaPotionRank3 = {
					enabled = true, -- 3
				},
				potionOfFrozenFocusRank1 = {
					enabled = false, -- 4
				},
				potionOfFrozenFocusRank2 = {
					enabled = false, -- 5
				},
				potionOfFrozenFocusRank3 = {
					enabled = true, -- 6
				},
				conjuredChillglobe = {
					enabled = true, -- 7
					cooldown = true
				},
				shadowfiend = {
					enabled = true, -- 8
					cooldown = false
				},
				potionCooldown = {
					enabled=true,
					mode="time",
					gcdsMax=40,
					timeMax=60
				},
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			bar = {
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true,
				holyWordChastiseEnabled=false,
				holyWordSanctifyEnabled=true,
				holyWordSerenityEnabled=true
			},
			endOfApotheosis = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			shadowfiend={
				mode="time",
				swingsMax=4,
				gcdsMax=2,
				timeMax=15.0,
				enabled=true
			},
			passiveGeneration = {
				innervate = true,
				manaTideTotem = true,
				symbolOfHope = true
			},
			colors={
				text={
					current="FF4D4DFF",
					casting="FFFFFFFF",
					passive="FF8080FF",
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
					dots={
						enabled=true,
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFFFF00"
					}
				},
				bar={
					border="FF000099",
					background="66000000",
					base="FF0000FF",
					innervate="FF00FF00",
					potionOfChilledClarity="FF9EC51E",
					apotheosis="FFFADA5E",
					apotheosisEnd="FFFF0000",
					holyWordChastise="FFAAFFAA",
					holyWordSanctify="FF55FF55",
					holyWordSerenity="FF00FF00",
					surgeOfLight1="FFFCE58E",
					surgeOfLight2="FFAF9942",
					resonantWords="FFAA00FF",
					lightweaver="FF00FFFF",
					spending="FFFFFFFF",
					passive="FF8080FF",
					surgeOfLightBorderChange1=true,
					surgeOfLightBorderChange2=true,
					innervateBorderChange=true,
					resonantWordsBorderChange=true,
					lightweaverBorderChange=true,
					potionOfChilledClarityBorderChange=true,
				},
				threshold={
					unusable="FFFF0000",
					over="FF00FF00",
					mindbender="FF8080FF",
					outOfRange="FF440000"
				}
			},
			displayText={},
			audio={
				innervate={
					name = "Innervate",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				surgeOfLight={
					name = "Innervate (1 stack)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				surgeOfLight2={
					name = "Innervate (2 stacks)",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				resonantWords={
					name = "Resonant Words",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				lightweaver={
					name = "Lightweaver",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				}
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
				textureLock=true
			}
		}

		settings.displayText = HolyLoadDefaultBarTextSimpleSettings()
		return settings
	end

	local function ShadowLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="$haste%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="{$vfTime}[$vfTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$insanity%",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text="#swp $swpCount   #dp $dpCount   $haste% ($gcd)||n#vt $vtCount   {$cttvEquipped}[#loi $ecttvCount][       ]   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$mdTime}[#mDev $mdTime #mDev{$vfTime||$mfiTime}[||n]]{$mfiTime}[#mfi $mfiTime #mfi{$vfTime}[||n]]{$vfTime}[$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text="{$casting}[#casting$casting+]{$asCount}[#as$asInsanity+]{$mbInsanity}[#mindbender$mbInsanity+]{$loiInsanity}[#loi$loiInsanity+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultBarTextNarrowAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text="#swp $swpCount   $haste% ($gcd)||n#vt $vtCount   {$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$mdTime}[#mDev $mdTime #mDev{$vfTime}[||n]]{$vfTime}[$vfTime]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text="{$casting}[#casting$casting+]{$passive}[$passive+]$insanity",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function ShadowLoadDefaultSettings()
		local settings = {
			hasteApproachingThreshold=135,
			hasteThreshold=140,
			hastePrecision=2,
			insanityPrecision=0,
			auspiciousSpiritsTracker=true,
			voidTendrilTracker=true,
			thresholds = {
				width = 2,
				overlapBorder=true,
				outOfRange=true,
				icons = {
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					desaturated=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				devouringPlagueThresholdOnlyOverShow = false,
				devouringPlague = { -- 1
					enabled = true,
				},
				devouringPlague2 = { -- 2
					enabled = true,
				},
				devouringPlague3 = { -- 3
					enabled = true,
				}
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			bar = {
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true
			},
			mindbender={
				mode="gcd",
				swingsMax=4,
				gcdsMax=2,
				timeMax=3.0,
				enabled=true
			},
			endOfVoidform = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			overcap={
				mode="relative",
				relative=0,
				fixed=100
			},
			colors={
				text={
					currentInsanity="FFC2A3E0",
					castingInsanity="FFFFFFFF",
					passiveInsanity="FFDF00FF",
					overcapInsanity="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF",
					hasteBelow="FFFFFFFF",
					hasteApproaching="FFFFFF00",
					hasteAbove="FF00FF00",
					dots={
						enabled=true,
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFFFF00"
					}
				},
				bar={
					border="FF431863",
					borderOvercap="FFFF0000",
					borderMindFlayInsanity="FF00FF00",
					deathspeaker = {
						color = "FFFF9900",
						enabled = true
					},
					background="66000000",
					base="FF763BAF",
					devouringPlagueUsable="FF5C2F89",
					devouringPlagueUsableCasting="FFFFFFFF",
					instantMindBlast={
						color = "FFC2A3E0",
						enabled = true
					},
					inVoidform="FF431863",
					inVoidform1GCD="FFFF0000",
					casting="FFFFFFFF",
					passive="FFDF00FF",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true,
					mindFlayInsanityBorderChange=true
				},
				threshold={
					under="FFFFFFFF",
					over="FF00FF00",
					mindbender="FFFF11FF",
					outOfRange="FF440000"
				}
			},
			displayText={},
			audio={
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				mdProc={
					name = "Mind Devourer Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				dpReady={
					name = "Devouring Plague Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				deathspeaker={
					name = "Deathspeaker Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				}
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
				textureLock=true
			}
		}

		settings.displayText = ShadowLoadDefaultBarTextSimpleSettings()
		return settings
	end

	local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()
		settings.priest.discipline = DisciplineLoadDefaultSettings()
		settings.priest.holy = HolyLoadDefaultSettings()
		settings.priest.shadow = ShadowLoadDefaultSettings()
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

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""
		StaticPopupDialogs["TwintopResourceBar_ConfirmReload"] = {
			text = "Click to finish applying",
			button1 = "Yes",
			OnAccept = function()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Discipline Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.discipline = nil
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Discipline Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = DisciplineLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Discipline_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Discipline Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = DisciplineLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Discipline_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Discipline Priest (Bar Display).", 5, 1, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 1, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 1, yCoord, "Mana", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 1, yCoord, "Mana")
		
		yCoord = yCoord - 30

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_1_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana cost of current hardcast spell", spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_1_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana from Passive Sources (Potions, Mana Tide Totem bonus regen, etc.)", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 1, yCoord, "Mana", false, true)

		controls.colors.surgeOfLight1 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 1 stack of Surge of Light", spec.colors.bar.surgeOfLight1, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.surgeOfLight1
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight1")
		end)
						
		controls.colors.surgeOfLight2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 2 stacks of Surge of Light", spec.colors.bar.surgeOfLight2, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.surgeOfLight2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight2")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight1BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Threshold_Option_surgeOfLight1BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight1BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Surge of Light (1 stack)")
		f.tooltip = "This will change the bar border color when you have 1 stack of Surge of Light."
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange1)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange1 = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Threshold_Option_surgeOfLight2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Surge of Light (2 stacks)")
		f.tooltip = "This will change the bar border color when you have 2 stacks of Surge of Light."
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange2)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange2 = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 5, 1, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 1, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 5, 1, yCoord)
		
		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Discipline Priest (Font & Text).", 5, 1, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateFontOptions(parent, controls, spec, 5, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Mana Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana spent from hardcasting spells", spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Mana", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)
	

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($swpCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local title = ""

		controls.buttons.exportButton_Priest_Discipline_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Discipline Priest (Audio & Tracking).", 5, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervate
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio when you gain Innervate")
		f.tooltip = "This sound will play when you gain Innervate from a helpful Druid."
		f:SetChecked(spec.audio.innervate.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.innervate.enabled = self:GetChecked()

			if spec.audio.innervate.enabled then
				PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_Innervate_Audio", parent)
		controls.dropDown.innervateAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.innervateAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, spec.audio.innervate.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.innervateAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.innervateAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.innervate.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.innervateAudio:SetValue(newValue, newName)
			spec.audio.innervate.sound = newValue
			spec.audio.innervate.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SurgeOfLightCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Surge of Light proc occurs")
		f.tooltip = "Play an audio cue when a Surge of Light proc occurs. This will only play for the first proc."
		f:SetChecked(spec.audio.surgeOfLight.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight.enabled = self:GetChecked()

			if spec.audio.surgeOfLight.enabled then
				PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLightAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLightAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLightAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, spec.audio.surgeOfLight.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLightAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLightAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.surgeOfLight.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLightAudio:SetValue(newValue, newName)
			spec.audio.surgeOfLight.sound = newValue
			spec.audio.surgeOfLight.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight2 = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SurgeOfLight2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you have two (max) Surge of Light procs")
		f.tooltip = "Play audio cue when you get a second (and maximum) Surge of Light proc. If both are checked, only this sound will play."
		f:SetChecked(spec.audio.surgeOfLight2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight2.enabled = self:GetChecked()

			if spec.audio.surgeOfLight2.enabled then
				PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLight2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Discipline_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLight2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLight2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, spec.audio.surgeOfLight2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLight2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLight2Audio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.surgeOfLight2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLight2Audio:SetValue(newValue, newName)
			spec.audio.surgeOfLight2.sound = newValue
			spec.audio.surgeOfLight2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive External Mana Generation Tracking", 0, yCoord)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track passive mana regen while Innervate is active")
		f.tooltip = "Show the passive regeneration of mana over the remaining duration of Innervate."
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track bonus passive mana regen while Mana Tide Totem is active")
		f.tooltip = "Show the bonus passive regeneration of mana over the remaining duration of Mana Tide Totem."
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track mana regen from a Priest's Symbol of Hope")
		f.tooltip = "Show the regeneration of mana from another Priest's Symbol of Hope channel."
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Shadowfiend Tracking", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiend = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_Shadowfiend_Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowfiend
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Mana Gain")
		f.tooltip = "Show the gain of Mana over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
		f:SetChecked(spec.shadowfiend.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.shadowfiend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiendModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_GCDs", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from GCDs remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X GCDs, based on player's current GCD."
		if spec.shadowfiend.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(true)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "gcd"
		end)

		title = "Shadowfiend GCDs - 0.75sec Floor"
		controls.shadowfiendGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_Swings", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from Swings remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X melee swings from Shadowfiend. This is only different from the GCD option if you are above 200% haste (GCD cap)."
		if spec.shadowfiend.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(true)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "swing"
		end)

		title = "Shadowfiend Swings - No Floor"
		controls.shadowfiendSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_ShadowfiendMode_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from Time remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X seconds."
		if spec.shadowfiend.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(true)
			spec.shadowfiend.mode = "time"
		end)

		title = "Shadowfiend Remaining (sec)"
		controls.shadowfiendTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.shadowfiend.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.shadowfiend.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls
	end

	local function DisciplineConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.discipline
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.discipline

		local namePrefix = "Priest_Discipline"

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		
		controls.buttons.exportButton_Priest_Discipline_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Discipline_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Discipline Priest (Bar Text).", 5, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.Functions.OptionsUi:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		TRB.Functions.OptionsUi:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function DisciplineConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.discipline or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.disciplineDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Discipline", UIParent)
		interfaceSettingsFrame.disciplineDisplayPanel.name = "Discipline Priest"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.disciplineDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.disciplineDisplayPanel, "Discipline Priest")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.disciplineDisplayPanel)

		parent = interfaceSettingsFrame.disciplineDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Discipline Priest", 0, yCoord-5)	
		
		controls.checkBoxes.disciplinePriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Discipline_disciplinePriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.disciplinePriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Discipline Priest specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.priest.discipline)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.discipline = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.disciplinePriestEnabled, TRB.Data.settings.core.enabled.priest.discipline, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Discipline_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Discipline_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Discipline Priest (All).", 5, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Discipline_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Discipline_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 0, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.discipline = controls

		DisciplineConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		DisciplineConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		DisciplineConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		DisciplineConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		DisciplineConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end




	--[[

	Holy Option Menus

	]]

	local function HolyConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""
		StaticPopupDialogs["TwintopResourceBar_ConfirmReload"] = {
			text = "Click to finish applying",
			button1 = "Yes",
			OnAccept = function()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Holy Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.holy = nil
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Holy Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HolyLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Holy_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Holy Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HolyLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextSimple")
		end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Holy_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Holy Priest (Bar Display).", 5, 2, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 2, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 2, yCoord, "Mana", "notFull", false)

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 2, yCoord, "Mana")
		
		yCoord = yCoord - 30
		controls.checkBoxes.holyWordChastiseEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordChastiseEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordChastiseEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enable Holy Word: Chastise cooldown color")
		f.tooltip = "This will change the mana bar color when your current cast will complete the cooldown of Holy Word: Chastise."
		f:SetChecked(spec.bar.holyWordChastiseEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordChastiseEnabled = self:GetChecked()
		end)

		controls.colors.holyWordChastise = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana when your cast will complete the cooldown of Holy Word: Chastise", spec.colors.bar.holyWordChastise, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordChastise
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordChastise")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSanctifyEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSanctifyEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSanctifyEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enable Holy Word: Sanctify cooldown color")
		f.tooltip = "This will change the mana bar color when your current cast will complete the cooldown of Holy Word: Sanctify."
		f:SetChecked(spec.bar.holyWordSanctifyEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordSanctifyEnabled = self:GetChecked()
		end)

		controls.colors.holyWordSanctify = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana when your cast will complete the cooldown of Holy Word: Sanctify", spec.colors.bar.holyWordSanctify, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordSanctify
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordSanctify")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.holyWordSerenityEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyWordSerenityEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyWordSerenityEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enable Holy Word: Serenity cooldown color")
		f.tooltip = "This will change the mana bar color when your current cast will complete the cooldown of Holy Word: Serenity."
		f:SetChecked(spec.bar.holyWordSerenityEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.holyWordSerenityEnabled = self:GetChecked()
		end)

		controls.colors.holyWordSerenity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana when your cast will complete the cooldown of Holy Word: Serenity", spec.colors.bar.holyWordSerenity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.holyWordSerenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "holyWordSerenity")
		end)

		yCoord = yCoord - 30
		controls.colors.inApotheosis = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana while Apotheosis is active", spec.colors.bar.apotheosis, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inApotheosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "apotheosis")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfApotheosis = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfApotheosis
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Apotheosis")
		f.tooltip = "Changes the bar color when Apotheosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfApotheosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfApotheosis.enabled = self:GetChecked()
		end)

		controls.colors.inApotheosisEnd = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana when Apotheosis is close to ending (as configured)", spec.colors.bar.apotheosisEnd, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inApotheosisEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "apotheosisEnd")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_2_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana cost of current hardcast spell", spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_2_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana from Passive Sources (Potions, Mana Tide Totem bonus regen, etc.)", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 2, yCoord, "Mana", false, true)

		controls.colors.surgeOfLight1 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 1 stack of Surge of Light", spec.colors.bar.surgeOfLight1, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.surgeOfLight1
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight1")
		end)
						
		controls.colors.surgeOfLight2 = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have 2 stacks of Surge of Light", spec.colors.bar.surgeOfLight2, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.surgeOfLight2
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "surgeOfLight2")
		end)

		controls.colors.resonantWords = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have Resonant Words", spec.colors.bar.resonantWords, 300, 25, oUi.xCoord2, yCoord-150)
		f = controls.colors.resonantWords
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "resonantWords")
		end)

		controls.colors.lightweaver = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you have any stacks of Lightweaver", spec.colors.bar.lightweaver, 300, 25, oUi.xCoord2, yCoord-180)
		f = controls.colors.lightweaver
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "lightweaver")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.innervateBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_innervateBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Innervate")
		f.tooltip = "This will change the bar border color when you have Innervate."
		f:SetChecked(spec.colors.bar.innervateBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.innervateBorderChange = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.surgeOfLight2BorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_surgeOfLight2BorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2BorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Surge of Light (2 stacks)")
		f.tooltip = "This will change the bar border color when you have 2 stacks of Surge of Light."
		f:SetChecked(spec.colors.bar.surgeOfLightBorderChange2)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.surgeOfLightBorderChange2 = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.resonantWordsBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_resonantWordsBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.resonantWordsBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Resonant Words")
		f.tooltip = "This will change the bar border color when you have Resonant Words."
		f:SetChecked(spec.colors.bar.resonantWordsBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.resonantWordsBorderChange = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.lightweaverBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Threshold_Option_lightweaverBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lightweaverBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Lightweaver")
		f.tooltip = "This will change the bar border color when you have any stacks of Lightweaver."
		f:SetChecked(spec.colors.bar.lightweaverBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.lightweaverBorderChange = self:GetChecked()
		end)


		yCoord = yCoord - 30

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLinesForHealers(parent, controls, spec, 5, 2, yCoord)

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GeneratePotionOnCooldownConfigurationOptions(parent, controls, spec, 5, 2, yCoord)
		
		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "End of Apotheosis Configuration", 0, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfApotheosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfApotheosisModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Apotheosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Apotheosis ends."
		if spec.endOfApotheosis.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfApotheosisModeTime:SetChecked(false)
			spec.endOfApotheosis.mode = "gcd"
		end)

		title = "Apotheosis GCDs - 0.75sec Floor"
		controls.endOfApotheosisGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfApotheosis.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfApotheosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfApotheosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfApotheosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_EOA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfApotheosisModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Apotheosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Apotheosis will end."
		if spec.endOfApotheosis.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfApotheosisModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfApotheosisModeTime:SetChecked(true)
			spec.endOfApotheosis.mode = "time"
		end)

		title = "Apotheosis Time Remaining"
		controls.endOfApotheosisTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfApotheosis.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfApotheosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfApotheosis.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Holy Priest (Font & Text).", 5, 2, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateFontOptions(parent, controls, spec, 5, 2, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Mana Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Mana spent from hardcasting spells", spec.colors.text.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Mana", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passive")
		end)
	

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($swpCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local title = ""

		controls.buttons.exportButton_Priest_Holy_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Holy Priest (Audio & Tracking).", 5, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervate
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio when you gain Innervate")
		f.tooltip = "This sound will play when you gain Innervate from a helpful Druid."
		f:SetChecked(spec.audio.innervate.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.innervate.enabled = self:GetChecked()

			if spec.audio.innervate.enabled then
				PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.innervateAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_Innervate_Audio", parent)
		controls.dropDown.innervateAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.innervateAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, spec.audio.innervate.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.innervateAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.innervateAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.innervate.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.innervateAudio:SetValue(newValue, newName)
			spec.audio.innervate.sound = newValue
			spec.audio.innervate.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.innervateAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SurgeOfLightCB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Surge of Light proc occurs")
		f.tooltip = "Play an audio cue when a Surge of Light proc occurs. This will only play for the first proc."
		f:SetChecked(spec.audio.surgeOfLight.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight.enabled = self:GetChecked()

			if spec.audio.surgeOfLight.enabled then
				PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLightAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLightAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLightAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, spec.audio.surgeOfLight.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLightAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLightAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.surgeOfLight.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLightAudio:SetValue(newValue, newName)
			spec.audio.surgeOfLight.sound = newValue
			spec.audio.surgeOfLight.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLightAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.surgeOfLight2 = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SurgeOfLight2CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.surgeOfLight2
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you have two (max) Surge of Light procs")
		f.tooltip = "Play audio cue when you get a second (and maximum) Surge of Light proc. If both are checked, only this sound will play."
		f:SetChecked(spec.audio.surgeOfLight2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.surgeOfLight2.enabled = self:GetChecked()

			if spec.audio.surgeOfLight2.enabled then
				PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.surgeOfLight2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_SurgeOfLightAudio", parent)
		controls.dropDown.surgeOfLight2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.surgeOfLight2Audio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, spec.audio.surgeOfLight2.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.surgeOfLight2Audio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.surgeOfLight2Audio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.surgeOfLight2.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.surgeOfLight2Audio:SetValue(newValue, newName)
			spec.audio.surgeOfLight2.sound = newValue
			spec.audio.surgeOfLight2.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.surgeOfLight2Audio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.checkBoxes.resonantWordsAudioCB = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_resonantWords", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.resonantWordsAudioCB
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you gain Resonant Words")
		f.tooltip = "Play audio cue when you gain a Resonant Words proc."
		f:SetChecked(spec.audio.resonantWords.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.resonantWords.enabled = self:GetChecked()

			if spec.audio.resonantWords.enabled then
				PlaySoundFile(spec.audio.resonantWords.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resonantWordsAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_resonantWordsAudio", parent)
		controls.dropDown.resonantWordsAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.resonantWordsAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.resonantWordsAudio, spec.audio.resonantWords.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.resonantWordsAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.resonantWordsAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.resonantWords.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.resonantWordsAudio:SetValue(newValue, newName)
			spec.audio.resonantWords.sound = newValue
			spec.audio.resonantWords.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.resonantWordsAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.resonantWords.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.checkBoxes.lightweaverAudioCB = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_lightweaver", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lightweaverAudioCB
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you gain Lightweaver")
		f.tooltip = "Play audio cue when you gain Lightweaver."
		f:SetChecked(spec.audio.lightweaver.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.lightweaver.enabled = self:GetChecked()

			if spec.audio.lightweaver.enabled then
				PlaySoundFile(spec.audio.lightweaver.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.lightweaverAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_Holy_lightweaverAudio", parent)
		controls.dropDown.lightweaverAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.lightweaverAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.lightweaverAudio, spec.audio.lightweaver.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.lightweaverAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.lightweaverAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.lightweaver.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.lightweaverAudio:SetValue(newValue, newName)
			spec.audio.lightweaver.sound = newValue
			spec.audio.lightweaver.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.lightweaverAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.lightweaver.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Passive External Mana Generation Tracking", 0, yCoord)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track passive mana regen while Innervate is active")
		f.tooltip = "Show the passive regeneration of mana over the remaining duration of Innervate."
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track bonus passive mana regen while Mana Tide Totem is active")
		f.tooltip = "Show the bonus passive regeneration of mana over the remaining duration of Mana Tide Totem."
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track mana regen from Symbol of Hope")
		f.tooltip = "Show the regeneration of mana from Symbol of Hope channel. This will hide regen from both your own or another Priest's Symbol of Hope."
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Shadowfiend Tracking", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiend = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_Shadowfiend_Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowfiend
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend Mana Gain")
		f.tooltip = "Show the gain of Mana over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
		f:SetChecked(spec.shadowfiend.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.shadowfiend.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.shadowfiendModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_GCDs", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from GCDs remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X GCDs, based on player's current GCD."
		if spec.shadowfiend.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(true)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "gcd"
		end)

		title = "Shadowfiend GCDs - 0.75sec Floor"
		controls.shadowfiendGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_Swings", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from Swings remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X melee swings from Shadowfiend. This is only different from the GCD option if you are above 200% haste (GCD cap)."
		if spec.shadowfiend.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(true)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(false)
			spec.shadowfiend.mode = "swing"
		end)

		title = "Shadowfiend Swings - No Floor"
		controls.shadowfiendSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.shadowfiend.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.shadowfiend.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.shadowfiendModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_ShadowfiendMode_Time", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.shadowfiendModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mana from Time remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Mana incoming over the up to next X seconds."
		if spec.shadowfiend.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.shadowfiendModeGCDs:SetChecked(false)
			controls.checkBoxes.shadowfiendModeSwings:SetChecked(false)
			controls.checkBoxes.shadowfiendModeTime:SetChecked(true)
			spec.shadowfiend.mode = "time"
		end)

		title = "Shadowfiend Remaining (sec)"
		controls.shadowfiendTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.shadowfiend.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.shadowfiendTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.shadowfiend.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls
	end

	local function HolyConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.holy
		local yCoord = 5
		local f = nil

		local spec = TRB.Data.settings.priest.holy

		local namePrefix = "Priest_Holy"

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		
		controls.buttons.exportButton_Priest_Holy_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Holy_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Holy Priest (Bar Text).", 5, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.Functions.OptionsUi:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		TRB.Functions.OptionsUi:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 2 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function HolyConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.holy or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.holyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Holy", UIParent)
		interfaceSettingsFrame.holyDisplayPanel.name = "Holy Priest"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.holyDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.holyDisplayPanel, "Holy Priest")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.holyDisplayPanel)

		parent = interfaceSettingsFrame.holyDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Holy Priest", 0, yCoord-5)	
		
		controls.checkBoxes.holyPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Holy_holyPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.holyPriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Holy Priest specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.priest.holy)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.holy = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)
		end)
		
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.holyPriestEnabled, TRB.Data.settings.core.enabled.priest.holy, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Holy_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Holy_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Holy Priest (All).", 5, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Holy_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Holy_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 0, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.holy = controls

		HolyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		HolyConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		HolyConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		HolyConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		HolyConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end



	--[[

	Shadow Option Menus

	]]

	local function ShadowConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.shadow
		local yCoord = 5

		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.priest.shadow = nil
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = ShadowLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = ShadowLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Priest_Shadow_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Shadow Priest settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = ShadowLoadDefaultBarTextNarrowAdvancedSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextSimple")
		end)

		yCoord = yCoord - 40
		controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextNarrowAdvanced")
		end)

		yCoord = yCoord - 40
		controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Priest_Shadow_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Bar Display).", 5, 3, true, false, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 5, 3, yCoord, false)

		yCoord = yCoord - 30
		yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 5, 3, yCoord, "Insanity", "notEmpty", true, "Devouring Plague", "DP")

		yCoord = yCoord - 70
		yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 5, 3, yCoord, "Insanity")

		yCoord = yCoord - 30
		controls.colors.inVoidform = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity while in Voidform / Dark Ascension", spec.colors.bar.inVoidform, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inVoidform		
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inVoidform")
		end)

		yCoord = yCoord - 30
		controls.colors.inVoidform1GCD = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity when Voidform / Dark Ascension is ending (as configured)", spec.colors.bar.inVoidform1GCD, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.inVoidform1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "inVoidform1GCD")
		end)

		controls.checkBoxes.endOfVoidform = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Bar_Option_vfDaColorChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfVoidform
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("VF/DA color change when ending enabled")
		f.tooltip = "Changes the bar color when Voidform / Dark Ascension is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfVoidform.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfVoidform.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.devouringPlagueUsable = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity when you can cast Devouring Plague", spec.colors.bar.devouringPlagueUsable, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.devouringPlagueUsable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "devouringPlagueUsable")
		end)

		yCoord = yCoord - 30
		controls.colors.instantMindBlast = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity when Mind Blast is instant cast (Shadowy Insight proc)", spec.colors.bar.instantMindBlast.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.instantMindBlast
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "instantMindBlast")
		end)

		controls.checkBoxes.instantMindBlast = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Checkbox_InstantMindBlast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.instantMindBlast
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Instant Mind Blast color change enabled")
		f.tooltip = "This will change the bar color when Mind Blast is able to be cast instantly due to a Shadowy Insight proc."
		f:SetChecked(spec.colors.bar.instantMindBlast.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.instantMindBlast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity from hardcasting spells", spec.colors.bar.casting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 3)
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.colors.devouringPlagueUsableCasting = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity from hardcasting spells while DP can be cast", spec.colors.bar.devouringPlagueUsableCasting, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.devouringPlagueUsableCasting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "devouringPlagueUsableCasting")
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity from passive sources (e.g Auspicious Spirits, Shadowfiend/Mindbender swings)", spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 5, 3, yCoord, "Insanity", true, false)
		
		yCoord = yCoord - 30
		controls.checkBoxes.mindFlayInsanityBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Border_Option_mindFlayInsanityBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindFlayInsanityBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mind Flay: Insanity / Mind Spike: Insanity")
		f.tooltip = "This will change the bar border color when you are able to cast Mind Flay: Insanity / Mind Spike: Insanity"
		f:SetChecked(spec.colors.bar.mindFlayInsanityBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.mindFlayInsanityBorderChange = self:GetChecked()
		end)

		controls.colors.borderMindFlayInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when you can channel Mind Flay: Insanity or Mind Spike: Insanity", spec.colors.bar.borderMindFlayInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderMindFlayInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "borderMindFlayInsanity")
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.deathspeakerBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Border_Option_deathspeakerBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathspeakerBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Deathspeaker proc")
		f.tooltip = "This will change the bar border color when you are able to cast Shadow Word: Death with the Deathspeaker proc effect active."
		f:SetChecked(spec.colors.bar.deathspeaker.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.deathspeaker.enabled = self:GetChecked()
		end)

		controls.colors.deathspeaker = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Border when a Deathspeaker proc is active", spec.colors.bar.deathspeaker.color, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.deathspeaker
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "deathspeaker")
		end)

		yCoord = yCoord - 40
		controls.abilityThresholdSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Under minimum required Insanity", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Over minimum required Insanity", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.mindbender = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Shadowfiend / Mindbender / Wrathful Faerie Insanity Gain", spec.colors.threshold.mindbender, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.mindbender
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "mindbender")
		end)

		controls.colors.threshold.outOfRange = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-140)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.Threshold:RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.dpThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Devouring Plague")
		f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast Devouring Plague."
		f:SetChecked(spec.thresholds.devouringPlague.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague2", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThreshold2Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show 2x Devouring Plague threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast two Devouring Plagues in a row."
		f:SetChecked(spec.thresholds.devouringPlague2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague2.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlague3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThreshold3Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show 3x Devouring Plague threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Insanity is required to cast three Devouring Plagues in a row."
		f:SetChecked(spec.thresholds.devouringPlague3.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlague3.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.dpThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_Threshold_Option_devouringPlagueOnlyOver", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpThresholdOnlyOverShow
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Only show current + next threshold line?")
		f.tooltip = "This will only show Devouring Plague threshold lines if you already have enough Insanity to cast it, or, if it is the next threshold you're approaching. Only triggers the next after the previous threshold line has been reached, even if it is not checked above!"
		f:SetChecked(spec.thresholds.devouringPlagueThresholdOnlyOverShow)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.devouringPlagueThresholdOnlyOverShow = self:GetChecked()
		end)

		yCoord = yCoord - 25
		yCoord = yCoord - 25
		yCoord = yCoord - 50

		yCoord = TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "End of Voidform Configuration", 0, yCoord)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfVoidformModeGCDs = CreateFrame("CheckButton", "TRB_EOFV_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfVoidformModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Voidform ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Voidform ends."
		if spec.endOfVoidform.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfVoidformModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfVoidformModeTime:SetChecked(false)
			spec.endOfVoidform.mode = "gcd"
		end)

		title = "Voidform GCDs - 0.75sec Floor"
		controls.endOfVoidformGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0.5, 10, spec.endOfVoidform.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfVoidformGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.endOfVoidform.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfVoidformModeTime = CreateFrame("CheckButton", "TRB_EOFV_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfVoidformModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Voidform ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Voidform will end."
		if spec.endOfVoidform.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfVoidformModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfVoidformModeTime:SetChecked(true)
			spec.endOfVoidform.mode = "time"
		end)

		title = "Voidform Time Remaining"
		controls.endOfVoidformTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.endOfVoidform.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfVoidformTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.endOfVoidform.timeMax = value
		end)

		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, 5, 3, yCoord, "Insanity", 150)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Font & Text).", 5, 3, false, true, false, false, false)
		end)

		yCoord = TRB.Functions.OptionsUi:GenerateFontOptions(parent, controls, spec, 5, 3, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Insanity Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.currentInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Current Insanity", spec.colors.text.currentInsanity, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.currentInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "currentInsanity")
		end)

		controls.colors.text.castingInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Insanity from hardcasting spells", spec.colors.text.castingInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.castingInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "castingInsanity")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passiveInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Passive Insanity", spec.colors.text.passiveInsanity, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passiveInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "passiveInsanity")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Have enough Insanity to cast Devouring Plague", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcapInsanity = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Cast will overcap Insanity", spec.colors.text.overcapInsanity, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcapInsanity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "overcapInsanity")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", 0, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Insanity text color when you are able to cast Devouring Plague"
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Insanity text color when your current hardcast spell will result in overcapping maximum Insanity."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($swpCount, $vtCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.Functions.OptionsUi:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)


		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Haste Threshold Colors in Voidform", 0, yCoord)

		yCoord = yCoord - 50
		title = "Low to Med. Haste% Threshold in Voidform"
		controls.hasteApproachingThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteApproachingThreshold, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hasteApproachingThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value > spec.hasteThreshold then
				value = spec.hasteThreshold
			end

			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.hasteApproachingThreshold = value
		end)

		controls.colors.text.hasteBelow = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Low Haste% in Voidform", spec.colors.text.hasteBelow,
													250, 25, oUi.xCoord2, yCoord+10)
		f = controls.colors.text.hasteBelow
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteBelow")
		end)

		controls.colors.text.hasteApproaching = TRB.Functions.OptionsUi:BuildColorPicker(parent, "Medium Haste% in Voidform", spec.colors.text.hasteApproaching,
													250, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.text.hasteApproaching
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteApproaching")
		end)

		controls.colors.text.hasteAbove = TRB.Functions.OptionsUi:BuildColorPicker(parent, "High Haste% in Voidform", spec.colors.text.hasteAbove,
													250, 25, oUi.xCoord2, yCoord-70)
		f = controls.colors.text.hasteAbove
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.text, controls.colors.text, "hasteAbove")
		end)

		yCoord = yCoord - 60
		title = "Med. to High Haste% Threshold in Voidform"
		controls.hasteThreshold = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 500, spec.hasteThreshold, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hasteThreshold:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			elseif value < spec.hasteApproachingThreshold then
				value = spec.hasteApproachingThreshold
			end

			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.hasteThreshold = value
		end)
		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		title = "Insanity Decimal Precision"
		controls.insanityPrecision = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 2, spec.insanityPrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.insanityPrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.insanityPrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Priest_Shadow_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Audio & Tracking).", 5, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.dpReady = CreateFrame("CheckButton", "TwintopResourceBar_CB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dpReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Devouring Plague is usable")
		f.tooltip = "Play an audio cue when Devouring Plague can be cast."
		f:SetChecked(spec.audio.dpReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.dpReady.enabled = self:GetChecked()

			if spec.audio.dpReady.enabled then
				PlaySoundFile(spec.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.dpReadyAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_dpReadyAudio", parent)
		controls.dropDown.dpReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.dpReadyAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, spec.audio.dpReady.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.dpReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.dpReadyAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.dpReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.dpReadyAudio:SetValue(newValue, newName)
			spec.audio.dpReady.sound = newValue
			spec.audio.dpReady.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.dpReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.mdProc = CreateFrame("CheckButton", "TwintopResourceBar_CB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mdProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Mind Devourer proc occurs")
		f.tooltip = "Play an audio cue when a Mind Devourer proc occurs. This supercedes the regular Devouring Plague audio sound."
		f:SetChecked(spec.audio.mdProc.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.mdProc.enabled = self:GetChecked()

			if spec.audio.mdProc.enabled then
				PlaySoundFile(spec.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.mdProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_mdProcAudio", parent)
		controls.dropDown.mdProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.mdProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, spec.audio.mdProc.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.mdProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.mdProcAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.mdProc.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.mdProcAudio:SetValue(newValue, newName)
			spec.audio.mdProc.sound = newValue
			spec.audio.mdProc.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.mdProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Insanity")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Insanity."
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_overcapAudio", parent)
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			spec.audio.overcap.sound = newValue
			spec.audio.overcap.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		

		yCoord = yCoord - 60
		controls.checkBoxes.deathspeakerProc = CreateFrame("CheckButton", "TwintopResourceBar_Priest_3_Deathspeaker_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.deathspeakerProc
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when a Deathspeaker proc occurs")
		f.tooltip = "Play an audio cue when a Deathspeaker proc occurs. This supercedes the regular Devouring Plague audio sound."
		f:SetChecked(spec.audio.deathspeaker.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.deathspeaker.enabled = self:GetChecked()

			if spec.audio.deathspeaker.enabled then
				PlaySoundFile(spec.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.deathspeakerProcAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Priest_3_Deathspeaker_ProcAudio", parent)
		controls.dropDown.deathspeakerProcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.deathspeakerProcAudio, oUi.sliderWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.deathspeakerProcAudio, spec.audio.deathspeaker.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.deathspeakerProcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.deathspeakerProcAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					LibDD:UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == spec.audio.deathspeaker.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						LibDD:UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.deathspeakerProcAudio:SetValue(newValue, newName)
			spec.audio.deathspeaker.sound = newValue
			spec.audio.deathspeaker.soundName = newName
			LibDD:UIDropDownMenu_SetText(controls.dropDown.deathspeakerProcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Auspicious Spirits Tracking", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.as = CreateFrame("CheckButton", "TwintopResourceBar_CB3_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.as
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Auspicious Spirits")
		f.tooltip = "Track Shadowy Apparitions in flight that will generate Insanity upon reaching their target with the Auspicious Spirits talent."
		f:SetChecked(spec.auspiciousSpiritsTracker)
		f:SetScript("OnClick", function(self, ...)
			spec.auspiciousSpiritsTracker = self:GetChecked()

			if ((spec.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.auspiciousSpirits)) or TRB.Functions.BarText:IsTtdActive(spec)) and GetSpecialization() == 3 then
				targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			else
				targetsTimerFrame:SetScript("OnUpdate", nil)
			end
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Eternal Call to the Void / Void Tendril + Void Lasher Tracking", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.voidTendril = CreateFrame("CheckButton", "TwintopResourceBar_CB3_6a", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.voidTendril
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Eternal Call to the Void")
		f.tooltip = "Track Insanity generated from Lash of Insanity via Void Tendril + Void Lasher spawns / Eternal Call of the Void procs."
		f:SetChecked(spec.voidTendrilTracker)
		f:SetScript("OnClick", function(self, ...)
			spec.voidTendrilTracker = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Shadowfiend/Mindbender Tracking", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.mindbender = CreateFrame("CheckButton", "TwintopResourceBar_CB3_7", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mindbender
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track Shadowfiend/Mindbender Insanity Gain")
		f.tooltip = "Show the gain of Insanity over the next serveral swings, GCDs, or fixed length of time. Select which to track from the options below."
		f:SetChecked(spec.mindbender.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.mindbender.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.mindbenderModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_RB3_8", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from GCDs remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X GCDs, based on player's current GCD."
		if spec.mindbender.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(true)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			spec.mindbender.mode = "gcd"
		end)

		title = "Shadowfiend/Mindbender GCDs - 0.75sec Floor"
		controls.mindbenderGCDs = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.mindbender.gcdsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.mindbender.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.mindbenderModeSwings = CreateFrame("CheckButton", "TwintopResourceBar_RB3_9", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeSwings
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from Swings remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X melee swings from Shadowfiend/Mindbender. This is only different from the GCD option if you are above 200% haste (GCD cap)."
		if spec.mindbender.mode == "swing" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(true)
			controls.checkBoxes.mindbenderModeTime:SetChecked(false)
			spec.mindbender.mode = "swing"
		end)

		title = "Shadowfiend/Mindbender Swings - No Floor"
		controls.mindbenderSwings = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, 10, spec.mindbender.swingsMax, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderSwings:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.mindbender.swingsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.mindbenderModeTime = CreateFrame("CheckButton", "TwintopResourceBar_RB3_10", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.mindbenderModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Insanity from Time remaining")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Insanity incoming over the up to next X seconds."
		if spec.mindbender.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.mindbenderModeGCDs:SetChecked(false)
			controls.checkBoxes.mindbenderModeSwings:SetChecked(false)
			controls.checkBoxes.mindbenderModeTime:SetChecked(true)
			spec.mindbender.mode = "time"
		end)

		title = "Shadowfiend/Mindbender Remaining (sec)"
		controls.mindbenderTime = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 15, spec.mindbender.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.mindbenderTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			spec.mindbender.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls
	end

	local function ShadowConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.priest.shadow

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.shadow
		local yCoord = 5
		local f = nil
		local namePrefix = "Priest_Shadow"

		TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		controls.buttons.exportButton_Priest_Shadow_BarText = TRB.Functions.OptionsUi:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Priest_Shadow_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (Bar Text).", 5, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.Functions.OptionsUi:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 3 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)
		f:SetCursorPosition(0)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.Functions.OptionsUi:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 3 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)
		f:SetCursorPosition(0)

		yCoord = yCoord - 70
		TRB.Functions.OptionsUi:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 3 then
				TRB.Functions.BarText:IsTtdActive(spec)
			end
		end)
		f:SetCursorPosition(0)

		yCoord = yCoord - 30
		local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function ShadowConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.shadow or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.shadowDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Priest_Shadow", UIParent)
		interfaceSettingsFrame.shadowDisplayPanel.name = "Shadow Priest"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.shadowDisplayPanel.parent = parent.name
		--local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.shadowDisplayPanel, "Shadow Priest")
		InterfaceOptions_AddCategory(interfaceSettingsFrame.shadowDisplayPanel)

		parent = interfaceSettingsFrame.shadowDisplayPanel

		controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, "Shadow Priest", 0, yCoord-5)
	
		controls.checkBoxes.shadowPriestEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Priest_Shadow_shadowPriestEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shadowPriestEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Shadow Priest specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.priest.shadow)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.priest.shadow = self:GetChecked()
			TRB.Functions.Class:EventRegistration()
			TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)
		end)

		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.shadowPriestEnabled, TRB.Data.settings.core.enabled.priest.shadow, true)

		controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Priest_Shadow_All = TRB.Functions.OptionsUi:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_Priest_Shadow_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.IO:ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Shadow Priest (All).", 5, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Priest_Shadow_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Priest_Shadow_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 0, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.shadow = controls

		ShadowConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		ShadowConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		ShadowConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		ShadowConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		ShadowConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		
		if TRB.Data.settings.core.experimental.specs.priest.discipline then
			DisciplineConstructOptionsPanel(specCache.discipline)
		end
		
		HolyConstructOptionsPanel(specCache.holy)
		ShadowConstructOptionsPanel(specCache.shadow)
	end
	TRB.Options.Priest.ConstructOptionsPanel = ConstructOptionsPanel
end