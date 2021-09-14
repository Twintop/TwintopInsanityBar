local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local leftTextFrame = TRB.Frames.leftTextFrame
	local middleTextFrame = TRB.Frames.middleTextFrame
	local rightTextFrame = TRB.Frames.rightTextFrame

	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

	TRB.Options.Rogue = {}
	TRB.Options.Rogue.Assassination = {}
	TRB.Options.Rogue.Outlaw = {}
	TRB.Options.Rogue.Subtlety = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = {}

	local function AssassinationLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function AssassinationLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "$haste% ($gcd)||n{$ttd}[TTD: $ttd] ",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$regen}[$regen+]$energy",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function AssassinationLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			overcapThreshold=120,
			thresholds = {
                    -- Core Rogue
					ambush = {
						enabled = true, -- 1 -- TODO: Make this only show up when in stealth or when usable due to talents/mechanics outside of stealth.
					},
					cheapShot = {
						enabled = true, -- 2
					},
					crimsonVial = {
						enabled = true, -- 3
					},
					distract = {
						enabled = true, -- 4
					},
					feint = {
						enabled = true, -- 5
					},
					kidneyShot = {
						enabled = true, -- 6
					},
					sap = {
						enabled = true, -- 7 -- TODO: Make this only show up when in stealth.
					},
					shiv = {
						enabled = true, -- 8
					},
					sliceAndDice = {
						enabled = true, -- 9
					},
                    -- Assassination
					envenom = {
						enabled = true, -- 10
					},
					fanOfKnives = {
						enabled = true, -- 11
					},
					garrote = {
						enabled = true, -- 12
					},
					mutilate = {
						enabled = true, -- 13
					},
					poisonedKnife = {
						enabled = true, -- 14
					},
					rupture = {
						enabled = true, -- 15
					},
			},
			generation = {
				mode="gcd",
				gcds=1,
				time=1.5,
				enabled=true
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
				thresholdOverlapBorder=true,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true
			},
            comboPoints = {
                width=100,
                height=10,
				xPos=0,
				yPos=50,
				border=1,
                spacing=10,
                relativeTo="TOP",
                relativeToName="Above - Middle",
                fullWidth=true,
            },
			colors = {
				text = {
					current="FFFFFF00",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFD59900",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
				},
				bar = {
					border="FFFFD300",
					borderOvercap="FFFF0000",
					--borderBeastialWrath="FF005500",
					background="66000000",
					base="FFFFFF00",
					--frenzyUse="FF00B60E",
					--frenzyHold="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FFD59900",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true,
				},
				comboPoints = {
					border="FFFFD300",
					--borderOvercap="FFFF0000",
					--borderBeastialWrath="FF005500",
					background="66000000",
					base="FFFFFF00",
					penultimate="FFFF9900",
					final="FFFF0000",
					--frenzyUse="FF00B60E",
					--frenzyHold="FFFF0000",
					--casting="FFFFFFFF",
					--spending="FF555555",
					--passive="FFD59900",
					--flashAlpha=0.70,
					--flashPeriod=0.5,
					--flashEnabled=true,
					--overcapEnabled=true,
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					unusable="FFFF0000"
				}
			},
			displayText = {},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				--[[killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				}]]
            },
			textures = {
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
			}
		}

		settings.displayText = AssassinationLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function AssassinationResetSettings()
		local settings = AssassinationLoadDefaultSettings()
		return settings
	end



	local function OutlawLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$trueshotTime}[$trueshotTime sec]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function OutlawLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$serpentSting}[#serpentSting $ssCount   ]$haste% ($gcd)||n{$serpentSting}[          ]{$ttd}[TTD: $ttd][ ]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$flayersMarkTime}[#flayersMark $flayersMarkTime #flayersMark||n]{$trueshotTime}[#trueshot $trueshotTime #trueshot]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$energy",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function OutlawLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			overcapThreshold=100,
			thresholds = {
				aimedShot = {
					enabled = true, -- 1
				},
				arcaneShot = {
					enabled = true, -- 2 --Also Chimera Shot @ 13
				},
				serpentSting = {
					enabled = false, -- 3
				},
				crimsonVial = {
					enabled = true, -- 4
				},
				killShot = {
					enabled = true, -- 5
				},
				sap = {
					enabled = true, -- 6
				},
				cheapShot = {
					enabled = true, -- 7
				},
				explosiveShot = {
					enabled = false, -- 8
				},
				sliceAndDice = {
					enabled = false, -- 9
				},
				burstingShot = {
					enabled = false, -- 10
				},
				shiv = {
					enabled = false, -- 11
				},
				fanOfKnives = {
					enabled = true, -- 12
				}
			},
			generation = {
				mode="gcd",
				gcds=1,
				time=1.5,
				enabled=true
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfTrueshot = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			steadyEnergy = {
				enabled=true,
				mode="gcd",
				gcdsMax=3,
				timeMax=4.5
			},
			bar = {
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				thresholdOverlapBorder=true,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true
			},
			colors = {
				text = {
					current="FFAB5124",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
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
				bar = {
					border="FFAB5124",
					borderOvercap="FFFF0000",
					borderSteadyEnergy="FFFFFF00",
					background="66000000",
					base="FFFF8040",
					trueshot="FF00B60E",
					trueshotEnding="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					unusable="FFFF0000"
				}
			},
			displayText = {},
			audio = {
				aimedShot={
					name = "Aimed Shot Capping",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn",
					mode="gcd",
					gcds=1,
					time=1.5
				},
				lockAndLoad={
					name = "Lock and Load Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				secretsOfTheUnblinkingVigil={
					name = "Secrets of the Unblinking Vigil Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				}
            },
			textures = {
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

		settings.displayText = OutlawLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function OutlawResetSettings()
		local settings = OutlawLoadDefaultSettings()
		return settings
	end



	local function SubtletyLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$coordinatedAssaultTime}[$coordinatedAssaultTime sec]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function SubtletyLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#serpentSting $ssCount   $haste% ($gcd)||n          {$ttd}[TTD: $ttd][ ]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$flayersMarkTime}[#flayersMark $flayersMarkTime #flayersMark||n]{$coordinatedAssaultTime}[#coordinatedAssault $coordinatedAssaultTime #coordinatedAssault]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$toeEnergy}[#termsOfEngagement$toeEnergy+]{$regen}[$regen+]$energy",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function SubtletyLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			overcapThreshold=100,
			thresholds = {
					arcaneShot = {
						enabled = false, -- 1
					},
					killShot = {
						enabled = true, -- 2
					},
					sliceAndDice = {
						enabled = false, -- 3
					},
					shiv = {
						enabled = false, -- 4
					},
					wingClip = {
						enabled = false, -- 5
					},
					carve = {
						enabled = true, -- 6, Butchery = 7
					},
					raptorStrike = {
						enabled = true, -- 8, also Mongoose Bite
					},
					serpentSting = {
						enabled = false, -- 9
					},
					cheapShot = {
						enabled = true, -- 10
					},
					chakrams = {
						enabled = true, -- 11
					}
			},
			generation = {
				mode="gcd",
				gcds=1,
				time=1.5,
				enabled=true
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfCoordinatedAssault = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
			},
			bar = {
				width=555,
				height=34,
				xPos=0,
				yPos=-200,
				border=4,
				thresholdOverlapBorder=true,
				dragAndDrop=false,
				pinToPersonalResourceDisplay=false,
				showPassive=true,
				showCasting=true
			},
			colors = {
				text = {
					current="FFAB5124",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
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
				bar = {
					border="FFAB5124",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFFF8040",
					coordinatedAssault="FF00B60E",
					coordinatedAssaultEnding="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					unusable="FFFF0000"
				}
			},
			displayText = {},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				}
            },
			textures = {
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

		settings.displayText = SubtletyLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function SubtletyResetSettings()
		local settings = SubtletyLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.rogue.assassination = AssassinationLoadDefaultSettings()
		--settings.rogue.outlaw = OutlawLoadDefaultSettings()
		--settings.rogue.subtlety = SubtletyLoadDefaultSettings()
		return settings
	end
    TRB.Options.Rogue.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Assassination Option Menus

	]]

	local function AssassinationConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.assassination
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.assassination = AssassinationResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.assassination.displayText = AssassinationLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.assassination.displayText = AssassinationLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Rogue_Assassination_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Assassination Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.assassination.displayText = AssassinationLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions.BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Assassination_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
	end

	local function AssassinationConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.assassination
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.rogue.assassination.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.assassination.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.assassination)

		controls.buttons.exportButton_Rogue_Assassination_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Bar Display).", 4, 1, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.rogue.assassination.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.assassination.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.assassination.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.assassination.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.rogue.assassination)
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.assassination, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.assassination.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.rogue.assassination.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.assassination.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.assassination.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.assassination.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.rogue.assassination)
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.rogue.assassination.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.bar.xPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.assassination.bar.xPos, TRB.Data.settings.rogue.assassination.bar.yPos)
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.rogue.assassination.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.bar.yPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.assassination.bar.xPos, TRB.Data.settings.rogue.assassination.bar.yPos)
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.rogue.assassination.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.bar.border = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(TRB.Data.settings.rogue.assassination.bar.width-(TRB.Data.settings.rogue.assassination.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.rogue.assassination.bar.height-(TRB.Data.settings.rogue.assassination.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.rogue.assassination.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.rogue.assassination.bar.height)
				if TRB.Data.settings.rogue.assassination.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.rogue.assassination.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.rogue.assassination.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.rogue.assassination.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.rogue.assassination)                
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.rogue.assassination)
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.assassination, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.assassination.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.rogue.assassination.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.rogue.assassination.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.assassination)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.rogue.assassination.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.thresholdWidth = value

			if GetSpecialization() == 1 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.rogue.assassination.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
		end)
			
		TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
		end)


		yCoord = yCoord - 30
		controls.comboPointPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Combo Points Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Combo Point Width"
		controls.comboPointWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), TRB.Data.settings.rogue.assassination.comboPoints.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.assassination.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.assassination.comboPoints.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.assassination.comboPoints.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.comboPointBorderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Combo Point Height"
		controls.comboPointHeight = TRB.UiFunctions.BuildSlider(parent, title, 1, sanityCheckValues.barMaxHeight, TRB.Data.settings.rogue.assassination.comboPoints.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointHeight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.assassination.comboPoints.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.assassination.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.assassination.comboPoints.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.comboPointBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.comboPointBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.comboPointBorderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)



		title = "Combo Points Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.comboPointHorizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.rogue.assassination.comboPoints.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointHorizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.xPos = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Combo Points Vertical Position (Relative)"
		controls.comboPointVertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.rogue.assassination.comboPoints.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointVertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.yPos = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)



		title = "Combo Point Border Width"
		yCoord = yCoord - 60
		controls.comboPointBorderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.rogue.assassination.comboPoints.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.comboPointBorderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.border = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)

				--TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.rogue.assassination)
			end

			local minsliderWidth = math.max(TRB.Data.settings.rogue.assassination.comboPoints.border*2, 1)
			local minsliderHeight = math.max(TRB.Data.settings.rogue.assassination.comboPoints.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.assassination)
			controls.comboPointHeight:SetMinMaxValues(minsliderHeight, scValues.comboPointsMaxHeight)
			controls.comboPointHeight.MinLabel:SetText(minsliderHeight)
			controls.comboPointWidth:SetMinMaxValues(minsliderWidth, scValues.comboPointsMaxWidth)
			controls.comboPointWidth.MinLabel:SetText(minsliderWidth)
		end)

		title = "Combo Points Spacing"
		controls.comboPointSpacing = TRB.UiFunctions.BuildSlider(parent, title, 0, TRB.Functions.RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), TRB.Data.settings.rogue.assassination.comboPoints.spacing, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.comboPoints.spacing = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

		yCoord = yCoord - 40        
        -- Create the dropdown, and configure its appearance
        controls.dropDown.comboPointsRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_comboPointsRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.comboPointsRelativeTo.label = TRB.UiFunctions.BuildSectionHeader(parent, "Relative Position of Combo Points to Energy Bar", xCoord, yCoord)
        controls.dropDown.comboPointsRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.comboPointsRelativeTo:SetPoint("TOPLEFT", xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.comboPointsRelativeTo, dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, TRB.Data.settings.rogue.assassination.comboPoints.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.comboPointsRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.comboPointsRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above - Left"] = "TOPLEFT"
            relativeTo["Above - Middle"] = "TOP"
            relativeTo["Above - Right"] = "TOPRIGHT"
            relativeTo["Below - Left"] = "BOTTOMLEFT"
            relativeTo["Below - Middle"] = "BOTTOM"
            relativeTo["Below - Right"] = "BOTTOMRIGHT"
            local relativeToList = {
                "Above - Left",
                "Above - Middle",
                "Above - Right",
                "Below - Left",
                "Below - Middle",
                "Below - Right"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == TRB.Data.settings.rogue.assassination.comboPoints.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.comboPointsRelativeTo:SetValue(newValue, newName)
            TRB.Data.settings.rogue.assassination.comboPoints.relativeTo = newValue
            TRB.Data.settings.rogue.assassination.comboPoints.relativeToName = newName
            UIDropDownMenu_SetText(controls.dropDown.comboPointsRelativeTo, newName)
            CloseDropDownMenus()

            if GetSpecialization() == 1 then
                TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
            end
        end


        controls.checkBoxes.comboPointsFullWidth = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_comboPointsFullWidth", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.comboPointsFullWidth
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Combo Points are full bar width?")
		f.tooltip = "Makes the Combo Point bars take up the same total width of the bar, spaced according to Combo Point Spacing (above). The horizontal position adjustment will be ignored and the width of Combo Point bars will be automatically calculated and will ignore the value set above."
		f:SetChecked(TRB.Data.settings.rogue.assassination.comboPoints.fullWidth)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.comboPoints.fullWidth = self:GetChecked()
            
			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		end)

        yCoord = yCoord - 60
        --[[
		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.rogue.assassination.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.thresholdWidth = value

			if GetSpecialization() == 1 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.rogue.assassination.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
		end)
			
		TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.assassination.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.assassination.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
		end)

        ]]






		--yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_EnergyBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.assassination.textures.resourceBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.resourceBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.resourceBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.assassination.textures.resourceBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.resourceBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.textures.resourceBar = newValue
			TRB.Data.settings.rogue.assassination.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.rogue.assassination.textures.textureLock then
				TRB.Data.settings.rogue.assassination.textures.castingBar = newValue
				TRB.Data.settings.rogue.assassination.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.rogue.assassination.textures.passiveBar = newValue
				TRB.Data.settings.rogue.assassination.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.resourceBar)
				if TRB.Data.settings.rogue.assassination.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.assassination.textures.castingBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.castingBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.castingBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.assassination.textures.castingBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.castingBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.textures.castingBar = newValue
			TRB.Data.settings.rogue.assassination.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.rogue.assassination.textures.textureLock then
				TRB.Data.settings.rogue.assassination.textures.resourceBar = newValue
				TRB.Data.settings.rogue.assassination.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.assassination.textures.passiveBar = newValue
				TRB.Data.settings.rogue.assassination.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
				if TRB.Data.settings.rogue.assassination.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.rogue.assassination.textures.passiveBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.passiveBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.passiveBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.assassination.textures.passiveBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.passiveBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.textures.passiveBar = newValue
			TRB.Data.settings.rogue.assassination.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.rogue.assassination.textures.textureLock then
				TRB.Data.settings.rogue.assassination.textures.resourceBar = newValue
				TRB.Data.settings.rogue.assassination.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.assassination.textures.castingBar = newValue
				TRB.Data.settings.rogue.assassination.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
				if TRB.Data.settings.rogue.assassination.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.assassination.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.rogue.assassination.textures.textureLock then
				TRB.Data.settings.rogue.assassination.textures.passiveBar = TRB.Data.settings.rogue.assassination.textures.resourceBar
				TRB.Data.settings.rogue.assassination.textures.passiveBarName = TRB.Data.settings.rogue.assassination.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.assassination.textures.passiveBarName)
				TRB.Data.settings.rogue.assassination.textures.castingBar = TRB.Data.settings.rogue.assassination.textures.resourceBar
				TRB.Data.settings.rogue.assassination.textures.castingBarName = TRB.Data.settings.rogue.assassination.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.assassination.textures.castingBarName)

				if GetSpecialization() == 1 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.assassination.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.rogue.assassination.textures.borderName)
		UIDropDownMenu_JustifyText(controls.dropDown.borderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.borderTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("border")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Border Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.assassination.textures.border
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.borderTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.textures.border = newValue
			TRB.Data.settings.rogue.assassination.textures.borderName = newName

			if GetSpecialization() == 1 then
				if TRB.Data.settings.rogue.assassination.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.rogue.assassination.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.rogue.assassination.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.rogue.assassination.textures.backgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.backgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.backgroundTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("background")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Background Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.assassination.textures.background
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.backgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.textures.background = newValue
			TRB.Data.settings.rogue.assassination.textures.backgroundName = newName

			if GetSpecialization() == 1 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.rogue.assassination.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.rogue.assassination.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 50

        --[[
		title = "Beastial Wrath Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.rogue.assassination.colors.bar.flashAlpha, 0.01, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.colors.bar.flashAlpha = value
		end)

		title = "Beastial Wrath Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.rogue.assassination.colors.bar.flashPeriod, 0.05, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40]]

		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.assassination.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.assassination.displayBar.alwaysShow = true
			TRB.Data.settings.rogue.assassination.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.assassination.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Energy < 120")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Energy < 120, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.assassination.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.assassination.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.assassination.displayBar.notZeroShow = true
			TRB.Data.settings.rogue.assassination.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.rogue.assassination.displayBar.alwaysShow) and (not TRB.Data.settings.rogue.assassination.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.assassination.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.assassination.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.assassination.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.rogue.assassination.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.rogue.assassination.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.assassination.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.assassination.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.showPassive = self:GetChecked()
		end)

        --[[
		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Beastial Wrath is usable")
		f.tooltip = "This will flash the bar when Beastial Wrath can be cast."
		f:SetChecked(TRB.Data.settings.rogue.assassination.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.esThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Border color when Beastial Wrath is usable")
		f.tooltip = "This will change the bar's border color (as configured below) when Beastial Wrath is usable."
		f:SetChecked(TRB.Data.settings.rogue.assassination.colors.bar.beastialWrathEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.colors.bar.beastialWrathEnabled = self:GetChecked()
		end)
        ]]

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Energy", TRB.Data.settings.rogue.assassination.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.rogue.assassination.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from Passive Sources", TRB.Data.settings.rogue.assassination.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    
					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

        --[[
		controls.colors.borderBeastialWrath = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when you can use Beastial Wrath", TRB.Data.settings.rogue.assassination.colors.bar.borderBeastialWrath, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderBeastialWrath
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.borderBeastialWrath, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.borderBeastialWrath = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.frenzyUse = TRB.UiFunctions.BuildColorPicker(parent, "Energy when Barbed Shot should be used", TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse, 275, 25, xCoord, yCoord)
		f = controls.colors.frenzyUse
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.frenzyUse.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
        ]]

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.rogue.assassination.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

        --[[
		yCoord = yCoord - 30
		controls.colors.frenzyHold = TRB.UiFunctions.BuildColorPicker(parent, "Energy when Barbed Shot charges should be held", TRB.Data.settings.rogue.assassination.colors.bar.frenzyHold, 275, 25, xCoord, yCoord)
		f = controls.colors.frenzyHold
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.frenzyHold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.frenzyHold.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.assassination.colors.bar.frenzyHold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)]]

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Energy threshold line", TRB.Data.settings.rogue.assassination.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Energy threshold line", TRB.Data.settings.rogue.assassination.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.rogue.assassination.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.rogue.assassination.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.rogue.assassination)
		end)

		controls.checkBoxes.ambushThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_ambush", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ambushThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ambush")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ambush."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.ambush.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.ambush.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cheap Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Cheap Shot."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonVialThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crimson Vial")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crimson Vial."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.crimsonVial.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.crimsonVial.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.distractThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_distract", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.distractThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Distract")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Distract."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.distract.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.distract.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.feintThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_feint", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feintThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Feint")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Feint."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.feint.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.feint.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.kidneyShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_kidneyShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.kidneyShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kidney Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kidney Shot."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.kidneyShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.kidneyShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sapThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sap")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sap. Only visible when in Stealth."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.sap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.sap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.shiv.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.envenomThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_envenom", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.envenomThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Envenom")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Envenom."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.envenom.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.envenom.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.fanOfKnivesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_fanOfKnives", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fanOfKnivesThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fan of Knives")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Fan of Knives."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.fanOfKnives.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.fanOfKnives.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.garroteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_garrote", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.garroteThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Garrote")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Garrote."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.garrote.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.garrote.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.mutilateThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_mutilate", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mutilateThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Mutilate")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Mutilate."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.mutilate.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.mutilate.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.poisonedKnifeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_poisonedKnife", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.poisonedKnifeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Poisoned Knife")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Poisoned Knife."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.poisonedKnife.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.poisonedKnife.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ruptureThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_Threshold_Option_rupture", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ruptureThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rupture")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Rupture."
		f:SetChecked(TRB.Data.settings.rogue.assassination.thresholds.rupture.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.thresholds.rupture.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current energy is above the overcapping maximum Energy as configured below."
		f:SetChecked(TRB.Data.settings.rogue.assassination.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 120, TRB.Data.settings.rogue.assassination.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
	end

	local function AssassinationConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.assassination
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Assassination_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Font & Text).", 4, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.assassination.displayText.left.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.displayText.left.fontFace = newValue
			TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.rogue.assassination.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.left.fontFace, TRB.Data.settings.rogue.assassination.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.middle.fontFace, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.right.fontFace, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.assassination.displayText.middle.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.displayText.middle.fontFace = newValue
			TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
				TRB.Data.settings.rogue.assassination.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.assassination.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.middle.fontFace, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.left.fontFace, TRB.Data.settings.rogue.assassination.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.right.fontFace, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.assassination.displayText.right.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontRight:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.displayText.right.fontFace = newValue
			TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
				TRB.Data.settings.rogue.assassination.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.right.fontFace, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.left.fontFace, TRB.Data.settings.rogue.assassination.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.middle.fontFace, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.assassination.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.rogue.assassination.displayText.fontFaceLock then
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFace = TRB.Data.settings.rogue.assassination.displayText.left.fontFace
				TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName = TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.assassination.displayText.middle.fontFaceName)
				TRB.Data.settings.rogue.assassination.displayText.right.fontFace = TRB.Data.settings.rogue.assassination.displayText.left.fontFace
				TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName = TRB.Data.settings.rogue.assassination.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.assassination.displayText.right.fontFaceName)

				if GetSpecialization() == 1 then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.middle.fontFace, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.right.fontFace, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.assassination.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.displayText.left.fontSize = value

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.left.fontFace, TRB.Data.settings.rogue.assassination.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.assassination.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.rogue.assassination.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.rogue.assassination.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.rogue.assassination.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.rogue.assassination.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.rogue.assassination.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.rogue.assassination.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.rogue.assassination.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.displayText.middle.fontSize = value

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.middle.fontFace, TRB.Data.settings.rogue.assassination.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.assassination.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.displayText.right.fontSize = value

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.assassination.displayText.right.fontFace, TRB.Data.settings.rogue.assassination.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.assassination.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Energy Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Current Energy", TRB.Data.settings.rogue.assassination.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.current, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.currentEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.assassination.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		
		controls.colors.passiveEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Energy", TRB.Data.settings.rogue.assassination.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.passiveEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.assassination.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", TRB.Data.settings.rogue.assassination.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.overThreshold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.assassination.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Current Energy is above overcap threshold", TRB.Data.settings.rogue.assassination.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.text.overcap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcapenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.assassination.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.rogue.assassination.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(TRB.Data.settings.rogue.assassination.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.assassination.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
	end

	local function AssassinationConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.assassination
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Audio & Tracking).", 4, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

        --[[
		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.rogue.assassination.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.assassination.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.rogue.assassination.audio.killShot.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.assassination.audio.killShot.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.killShotAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.audio.killShot.sound = newValue
			TRB.Data.settings.rogue.assassination.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
		f:SetChecked(TRB.Data.settings.rogue.assassination.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.assassination.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)
        ]]

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.rogue.assassination.audio.overcap.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.assassination.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.audio.overcap.sound = newValue
			TRB.Data.settings.rogue.assassination.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end

        --[[
		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Energy and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.rogue.assassination.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.assassination.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.rogue.assassination.audio.flayersMark.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.flayersMarkAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.flayersMarkAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else  
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.assassination.audio.flayersMark.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.flayersMarkAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.audio.flayersMark.sound = newValue
			TRB.Data.settings.rogue.assassination.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Energy."
		f:SetChecked(TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Assassination_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.nesingwarysTrappingApparatusAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.nesingwarysTrappingApparatusAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.nesingwarysTrappingApparatusAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end
        ]]


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.rogue.assassination.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.assassination.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if TRB.Data.settings.rogue.assassination.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			TRB.Data.settings.rogue.assassination.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
		controls.energyGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.rogue.assassination.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			TRB.Data.settings.rogue.assassination.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
		controls.energyGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.assassination.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.assassination.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls
	end
    
	local function AssassinationConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.assassination
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Rogue_Assassination_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Assassination_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (Bar Text).", 4, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.assassination.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.assassination.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.assassination.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.assassination.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.assassination.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.assassination.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function AssassinationConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.assassination or {}
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.assassinationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Assassination", UIParent)
		interfaceSettingsFrame.assassinationDisplayPanel.name = "Assassination Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.assassinationDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.assassinationDisplayPanel)

		parent = interfaceSettingsFrame.assassinationDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Assassination Rogue", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.assassinationRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Assassination_assassinationRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.assassinationRogueEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Assassination Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.assassination)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.assassination = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)
		end)

		TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.assassinationRogueEnabled, TRB.Data.settings.core.enabled.rogue.assassination, true)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Assassination_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Assassination_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Assassination Rogue (All).", 4, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Assassination_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Rogue_Assassination_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.assassination = controls

		AssassinationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		AssassinationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		AssassinationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		AssassinationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		AssassinationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Outlaw Option Menus

	]]

	local function OutlawConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.outlaw = OutlawResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.outlaw.displayText = OutlawLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.outlaw.displayText = OutlawLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Rogue_Outlaw_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Outlaw Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.outlaw.displayText = OutlawLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions.BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Outlaw_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
	end

	local function OutlawConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.outlaw
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.rogue.outlaw.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.outlaw.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.outlaw)

		controls.buttons.exportButton_Rogue_Outlaw_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Bar Display).", 4, 2, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.rogue.outlaw.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.outlaw.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.outlaw.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.outlaw.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 2 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.rogue.outlaw)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.outlaw, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.outlaw.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.rogue.outlaw.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.outlaw.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.outlaw.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.outlaw.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 2 then				
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.rogue.outlaw)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.rogue.outlaw.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.bar.xPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.outlaw.bar.xPos, TRB.Data.settings.rogue.outlaw.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.rogue.outlaw.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.bar.yPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.outlaw.bar.xPos, TRB.Data.settings.rogue.outlaw.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.rogue.outlaw.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.bar.border = value

			if GetSpecialization() == 2 then
				barContainerFrame:SetWidth(TRB.Data.settings.rogue.outlaw.bar.width-(TRB.Data.settings.rogue.outlaw.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.rogue.outlaw.bar.height-(TRB.Data.settings.rogue.outlaw.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.rogue.outlaw.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.rogue.outlaw.bar.height)
				if TRB.Data.settings.rogue.outlaw.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.rogue.outlaw.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.rogue.outlaw.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.rogue.outlaw.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.rogue.outlaw)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.outlaw, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.outlaw.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.rogue.outlaw.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.rogue.outlaw.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.outlaw)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.rogue.outlaw.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.thresholdWidth = value

			if GetSpecialization() == 2 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.rogue.outlaw.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.outlaw.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.outlaw.bar.dragAndDrop)
		end)

		TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.outlaw.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.outlaw.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.outlaw.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_EnergyBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.outlaw.textures.resourceBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.resourceBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.resourceBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.outlaw.textures.resourceBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.resourceBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.textures.resourceBar = newValue
			TRB.Data.settings.rogue.outlaw.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.rogue.outlaw.textures.textureLock then
				TRB.Data.settings.rogue.outlaw.textures.castingBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.rogue.outlaw.textures.passiveBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.resourceBar)
				if TRB.Data.settings.rogue.outlaw.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.outlaw.textures.castingBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.castingBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.castingBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.outlaw.textures.castingBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.castingBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.textures.castingBar = newValue
			TRB.Data.settings.rogue.outlaw.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.rogue.outlaw.textures.textureLock then
				TRB.Data.settings.rogue.outlaw.textures.resourceBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.outlaw.textures.passiveBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
				if TRB.Data.settings.rogue.outlaw.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.rogue.outlaw.textures.passiveBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.passiveBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.passiveBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.outlaw.textures.passiveBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.passiveBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.textures.passiveBar = newValue
			TRB.Data.settings.rogue.outlaw.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.rogue.outlaw.textures.textureLock then
				TRB.Data.settings.rogue.outlaw.textures.resourceBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.outlaw.textures.castingBar = newValue
				TRB.Data.settings.rogue.outlaw.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
				if TRB.Data.settings.rogue.outlaw.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.rogue.outlaw.textures.textureLock then
				TRB.Data.settings.rogue.outlaw.textures.passiveBar = TRB.Data.settings.rogue.outlaw.textures.resourceBar
				TRB.Data.settings.rogue.outlaw.textures.passiveBarName = TRB.Data.settings.rogue.outlaw.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.outlaw.textures.passiveBarName)
				TRB.Data.settings.rogue.outlaw.textures.castingBar = TRB.Data.settings.rogue.outlaw.textures.resourceBar
				TRB.Data.settings.rogue.outlaw.textures.castingBarName = TRB.Data.settings.rogue.outlaw.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.outlaw.textures.castingBarName)

				if GetSpecialization() == 2 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.outlaw.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.rogue.outlaw.textures.borderName)
		UIDropDownMenu_JustifyText(controls.dropDown.borderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.borderTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("border")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Border Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.outlaw.textures.border
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.borderTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.textures.border = newValue
			TRB.Data.settings.rogue.outlaw.textures.borderName = newName

			if GetSpecialization() == 2 then
				if TRB.Data.settings.rogue.outlaw.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.rogue.outlaw.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.rogue.outlaw.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.rogue.outlaw.textures.backgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.backgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.backgroundTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("background")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Background Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.outlaw.textures.background
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.backgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.textures.background = newValue
			TRB.Data.settings.rogue.outlaw.textures.backgroundName = newName

			if GetSpecialization() == 2 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.rogue.outlaw.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.rogue.outlaw.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.rogue.outlaw.colors.bar.flashAlpha, 0.01, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.rogue.outlaw.colors.bar.flashPeriod, 0.05, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow = true
			TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Energy < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Energy < 100, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow = true
			TRB.Data.settings.rogue.outlaw.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow) and (not TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.outlaw.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.rogue.outlaw.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Energy", TRB.Data.settings.rogue.outlaw.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.rogue.outlaw.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from hardcasting builder abilities", TRB.Data.settings.rogue.outlaw.colors.bar.casting, 275, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    castingFrame:SetStatusBarColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast builder will overcap Energy", TRB.Data.settings.rogue.outlaw.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.spending = TRB.UiFunctions.BuildColorPicker(parent, "Energy loss from hardcasting spender abilities", TRB.Data.settings.rogue.outlaw.colors.bar.spending, 275, 25, xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.spending.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.steadyEnergy = TRB.UiFunctions.BuildColorPicker(parent, "Border when Steady Energy is expiring or not up (per settings)", TRB.Data.settings.rogue.outlaw.colors.bar.borderSteadyEnergy, 275, 25, xCoord2, yCoord)
		f = controls.colors.steadyEnergy
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.borderSteadyEnergy, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.steadyEnergy.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.bar.borderSteadyEnergy = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from Passive Sources", TRB.Data.settings.rogue.outlaw.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    
					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.trueshot = TRB.UiFunctions.BuildColorPicker(parent, "Energy while Trueshot is active", TRB.Data.settings.rogue.outlaw.colors.bar.trueshot, 275, 25, xCoord2, yCoord)
		f = controls.colors.trueshot
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.trueshot, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.trueshot.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.trueshot = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.rogue.outlaw.colors.bar.background, 275, 25, xCoord, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.trueshotEnding = TRB.UiFunctions.BuildColorPicker(parent, "Energy when Trueshot is ending", TRB.Data.settings.rogue.outlaw.colors.bar.trueshotEnding, 275, 25, xCoord2, yCoord)
		f = controls.colors.trueshotEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.trueshotEnding, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.eclipse1GCD.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.bar.trueshotEnding = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Energy threshold line", TRB.Data.settings.rogue.outlaw.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Energy threshold line", TRB.Data.settings.rogue.outlaw.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.rogue.outlaw.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.rogue.outlaw)
		end)

		controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Aimed Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Aimed Shot. If there are 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.aimedShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot/Chimera Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Arcane Shot or Chimera Shot."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.crimsonVialThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_crimsonVial", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.crimsonVialThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("CrimsonVial (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use CrimsonVial. Only visible if talented in to CrimsonVial. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.crimsonVial.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.crimsonVial.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.burstingShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_burstingShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.burstingShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Bursting Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Bursting Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.burstingShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.burstingShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.explosiveShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Explosive Shot (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Explosive Shot. Only visible if talented in to Explosive Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.explosiveShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.explosiveShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sapThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sap", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sapThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Sap")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Sap."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.sap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.sap.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.shiv.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Serpent Sting. Only visible if talented in to Serpent Sting."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.serpentSting.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.fanOfKnivesThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_Threshold_Option_fanOfKnives", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fanOfKnivesThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fan of Knives (if Rae'shalare, Death's Whisper equipped")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Fan of Knives. Only visible when Rae'shalare, Death's Whisper is equipped. If on cooldown will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.thresholds.fanOfKnives.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.thresholds.fanOfKnives.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "End of Trueshot Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfTrueshot = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfTrueshot
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Trueshot")
		f.tooltip = "Changes the bar color when Trueshot is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.endOfTrueshot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.endOfTrueshot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfTrueshotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Trueshot ends."
		if TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode = "gcd"
		end)

		title = "Trueshot GCDs - 0.75sec Floor"
		controls.endOfTrueshotGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0.5, 20, TRB.Data.settings.rogue.outlaw.endOfTrueshot.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfTrueshotGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.endOfTrueshot.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfTrueshotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Trueshot ends."
		if TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(true)
			TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode = "time"
		end)

		title = "Trueshot Time Remaining (sec)"
		controls.endOfTrueshotTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.outlaw.endOfTrueshot.timeMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfTrueshotTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.endOfTrueshot.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Steady Energy Expiration Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.steadyEnergy = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_steadyEnergy_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.steadyEnergy
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar border when your Steady Energy buff is close to expiring or not up (if talented)")
		f.tooltip = "Changes the bar border color when your Steady Energy buff is not up or is expiring in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.steadyEnergy.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.steadyEnergy.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.steadyEnergyModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_steadyEnergy_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.steadyEnergyModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs left on Steady Energy buff")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar border color based on how many GCDs remain until Steady Energy will end."
		if TRB.Data.settings.rogue.outlaw.steadyEnergy.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.steadyEnergyModeGCDs:SetChecked(true)
			controls.checkBoxes.steadyEnergyModeTime:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.steadyEnergy.mode = "gcd"
		end)

		title = "Steady Energy GCDs - 0.75sec Floor"
		controls.steadyEnergyGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 30, TRB.Data.settings.rogue.outlaw.steadyEnergy.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.steadyEnergyGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.steadyEnergy.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.steadyEnergyModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_steadyEnergy_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.steadyEnergyModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time left on Steady Energy buff")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar border color based on how many seconds remain until Steady Energy will end."
		if TRB.Data.settings.rogue.outlaw.steadyEnergy.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.steadyEnergyModeGCDs:SetChecked(false)
			controls.checkBoxes.steadyEnergyModeTime:SetChecked(true)
			TRB.Data.settings.rogue.outlaw.steadyEnergy.mode = "time"
		end)

		title = "Steady Energy Time Remaining (sec)"
		controls.steadyEnergyTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.rogue.outlaw.steadyEnergy.timeMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.steadyEnergyTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.steadyEnergy.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current energy is above or a hardcast spell will result in overcapping maximum Energy as configured below."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 100, TRB.Data.settings.rogue.outlaw.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
	end

	local function OutlawConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.outlaw
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Outlaw_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Font & Text).", 4, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.outlaw.displayText.left.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.displayText.left.fontFace = newValue
			TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.left.fontFace, TRB.Data.settings.rogue.outlaw.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.right.fontFace, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace = newValue
			TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
				TRB.Data.settings.rogue.outlaw.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.left.fontFace, TRB.Data.settings.rogue.outlaw.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.right.fontFace, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.outlaw.displayText.right.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontRight:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.displayText.right.fontFace = newValue
			TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
				TRB.Data.settings.rogue.outlaw.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.right.fontFace, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.left.fontFace, TRB.Data.settings.rogue.outlaw.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.rogue.outlaw.displayText.fontFaceLock then
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace = TRB.Data.settings.rogue.outlaw.displayText.left.fontFace
				TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName = TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.outlaw.displayText.middle.fontFaceName)
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFace = TRB.Data.settings.rogue.outlaw.displayText.left.fontFace
				TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName = TRB.Data.settings.rogue.outlaw.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.outlaw.displayText.right.fontFaceName)

				if GetSpecialization() == 2 then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.right.fontFace, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.outlaw.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.displayText.left.fontSize = value

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.left.fontFace, TRB.Data.settings.rogue.outlaw.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.rogue.outlaw.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.rogue.outlaw.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.rogue.outlaw.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.rogue.outlaw.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.rogue.outlaw.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize = value

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.middle.fontFace, TRB.Data.settings.rogue.outlaw.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.displayText.right.fontSize = value

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.outlaw.displayText.right.fontFace, TRB.Data.settings.rogue.outlaw.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.outlaw.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Energy Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Current Energy", TRB.Data.settings.rogue.outlaw.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.current, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.currentEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.castingEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from hardcasting builder abilities", TRB.Data.settings.rogue.outlaw.colors.text.casting, 275, 25, xCoord2, yCoord)
		f = controls.colors.castingEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.castingEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)


		yCoord = yCoord - 30
		controls.colors.passiveEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Energy", TRB.Data.settings.rogue.outlaw.colors.text.passive, 300, 25, xCoord, yCoord)
		f = controls.colors.passiveEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.spendingEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Energy loss from hardcasting spender abilities", TRB.Data.settings.rogue.outlaw.colors.text.spending, 275, 25, xCoord2, yCoord)
		f = controls.colors.spendingEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.spendingEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", TRB.Data.settings.rogue.outlaw.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.overThreshold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Hardcasting builder ability will overcap Energy", TRB.Data.settings.rogue.outlaw.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.overcap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcapenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.outlaw.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current hardcast spell will result in overcapping maximum Energy."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions.BuildSectionHeader(parent, "DoT Count Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up colors counters ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.dots.up, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions.BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.text.dots.down, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.outlaw.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.outlaw.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
	end

	local function OutlawConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.outlaw
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Audio & Tracking).", 4, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.aimedShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_aimedShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Aimed Shot will cap charges")
		f.tooltip = "Play an audio cue when Aimed Shot will cap charges. The timeframe is the current cast time of Aimed shot plus either GCDs or Time as configured below."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.aimedShot.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.aimedShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_aimedShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.aimedShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.aimedShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, TRB.Data.settings.rogue.outlaw.audio.aimedShot.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.aimedShotAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.aimedShotAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.aimedShot.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.aimedShotAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		
		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_AS_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of GCDs before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(true)
			controls.checkBoxes.aimedShotModeTime:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode = "gcd"
		end)

		title = "GCDs - 0.75sec Floor"
		controls.aimedShotGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 6, TRB.Data.settings.rogue.outlaw.audio.aimedShot.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.aimedShotGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_AS_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of seconds before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(false)
			controls.checkBoxes.aimedShotModeTime:SetChecked(true)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode = "time"
		end)

		title = "Time (sec)"
		controls.aimedShotTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 12, TRB.Data.settings.rogue.outlaw.audio.aimedShot.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.aimedShotTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.audio.aimedShot.time = value
		end)



		yCoord = yCoord - 50
		controls.checkBoxes.lockAndLoadAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_lockAndLoad_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockAndLoadAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Lock and Load proc (if talented)")
		f.tooltip = "Play an audio cue when a Lock and Load proc occurs."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.lockAndLoadAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_lockAndLoad_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.lockAndLoadAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.lockAndLoadAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.lockAndLoadAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.lockAndLoadAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.lockAndLoadAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.rogue.outlaw.audio.killShot.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.killShot.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.killShotAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.killShot.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.rogue.outlaw.audio.overcap.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.overcap.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Energy and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.rogue.outlaw.audio.flayersMark.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.flayersMarkAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.flayersMarkAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.flayersMark.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.flayersMarkAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.flayersMark.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Energy."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.nesingwarysTrappingApparatusAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.nesingwarysTrappingApparatusAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.nesingwarysTrappingApparatusAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.secretsOfTheUnblinkingVigilAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_secretsOfTheUnblinkingVigil_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secretsOfTheUnblinkingVigilAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Secrets of the Unblinking Vigil proc")
		f.tooltip = "Play an audio cue when you get a Secrets of the Unblinking Vigil proc that allows your next Aimed Shot to cost 0 Energy."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.secretsOfTheUnblinkingVigilAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Outlaw_secretsOfTheUnblinkingVigilAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.secretsOfTheUnblinkingVigilAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.secretsOfTheUnblinkingVigilAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.sound = newValue
			TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.rogue.outlaw.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.outlaw.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD."
		if TRB.Data.settings.rogue.outlaw.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			TRB.Data.settings.rogue.outlaw.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
		controls.energyGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.rogue.outlaw.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if TRB.Data.settings.rogue.outlaw.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			TRB.Data.settings.rogue.outlaw.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
		controls.energyGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.outlaw.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.outlaw.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls
	end
    
	local function OutlawConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.outlaw
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Rogue_Outlaw_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Outlaw_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (Bar Text).", 4, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.outlaw.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.outlaw.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.outlaw.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.outlaw.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.outlaw.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.outlaw.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function OutlawConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.outlaw or {}
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.outlawDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Outlaw", UIParent)
		interfaceSettingsFrame.outlawDisplayPanel.name = "Outlaw Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.outlawDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.outlawDisplayPanel)

		parent = interfaceSettingsFrame.outlawDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Outlaw Rogue", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.outlawRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Outlaw_outlawRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.outlawRogueEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Outlaw Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.outlaw)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.outlaw = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)
		end)

		TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.outlawRogueEnabled, TRB.Data.settings.core.enabled.rogue.outlaw, true)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Outlaw_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Outlaw_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Outlaw Rogue (All).", 4, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Outlaw_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Rogue_Outlaw_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.outlaw = controls

		OutlawConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		OutlawConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		OutlawConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		OutlawConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		OutlawConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Subtlety Options Menus

	]]

    
	local function SubtletyConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.subtlety = SubtletyResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.subtlety.displayText = SubtletyLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.subtlety.displayText = SubtletyLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Rogue_Subtlety_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Subtlety Rogue settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.rogue.subtlety.displayText = SubtletyLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions.BuildButton(parent, "Reset to Defaults", xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Simple)", xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Narrow Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions.BuildButton(parent, "Reset Bar Text (Full Advanced)", xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Rogue_Subtlety_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
	end

	local function SubtletyConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.subtlety
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.rogue.subtlety.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.subtlety.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.subtlety)

		controls.buttons.exportButton_Rogue_Subtlety_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Bar Display).", 4, 3, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.rogue.subtlety.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.subtlety.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.subtlety.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.subtlety.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.rogue.subtlety)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.subtlety, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.subtlety.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.rogue.subtlety.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.rogue.subtlety.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.rogue.subtlety.bar.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = TRB.Data.settings.rogue.subtlety.bar.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)
			controls.borderWidth.EditBox:SetText(borderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.rogue.subtlety)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.rogue.subtlety.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.bar.xPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.subtlety.bar.xPos, TRB.Data.settings.rogue.subtlety.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.rogue.subtlety.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.bar.yPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.rogue.subtlety.bar.xPos, TRB.Data.settings.rogue.subtlety.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.rogue.subtlety.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.bar.border = value

			if GetSpecialization() == 3 then
				barContainerFrame:SetWidth(TRB.Data.settings.rogue.subtlety.bar.width-(TRB.Data.settings.rogue.subtlety.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.rogue.subtlety.bar.height-(TRB.Data.settings.rogue.subtlety.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.rogue.subtlety.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.rogue.subtlety.bar.height)
				if TRB.Data.settings.rogue.subtlety.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.rogue.subtlety.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.rogue.subtlety.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.rogue.subtlety.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.rogue.subtlety)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["energy"] ~= nil and TRB.Data.spells[k]["energy"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.subtlety, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.rogue.subtlety.thresholdWidth, -TRB.Data.spells[k]["energy"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.rogue.subtlety.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.rogue.subtlety.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.rogue.subtlety)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.rogue.subtlety.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.thresholdWidth = value
			if GetSpecialization() == 3 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.rogue.subtlety.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.subtlety.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.subtlety.bar.dragAndDrop)
		end)

		TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay)

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay = self:GetChecked()

			TRB.UiFunctions.ToggleCheckboxEnabled(controls.checkBoxes.lockPosition, not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay)

			barContainerFrame:SetMovable((not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.subtlety.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.rogue.subtlety.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.rogue.subtlety.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.rogue.subtlety, TRB.Frames.barContainerFrame)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_EnergyBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.subtlety.textures.resourceBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.resourceBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.resourceBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.subtlety.textures.resourceBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.resourceBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.textures.resourceBar = newValue
			TRB.Data.settings.rogue.subtlety.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.rogue.subtlety.textures.textureLock then
				TRB.Data.settings.rogue.subtlety.textures.castingBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.rogue.subtlety.textures.passiveBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.resourceBar)
				if TRB.Data.settings.rogue.subtlety.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.subtlety.textures.castingBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.castingBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.castingBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.subtlety.textures.castingBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.castingBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.textures.castingBar = newValue
			TRB.Data.settings.rogue.subtlety.textures.castingBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.rogue.subtlety.textures.textureLock then
				TRB.Data.settings.rogue.subtlety.textures.resourceBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.subtlety.textures.passiveBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.castingBar)
				if TRB.Data.settings.rogue.subtlety.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.passiveBar)
				end
			end
			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.rogue.subtlety.textures.passiveBarName)
		UIDropDownMenu_JustifyText(controls.dropDown.passiveBarTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.passiveBarTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("statusbar")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("statusbar")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Status Bar Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.subtlety.textures.passiveBar
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.passiveBarTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.textures.passiveBar = newValue
			TRB.Data.settings.rogue.subtlety.textures.passiveBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.rogue.subtlety.textures.textureLock then
				TRB.Data.settings.rogue.subtlety.textures.resourceBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.rogue.subtlety.textures.castingBar = newValue
				TRB.Data.settings.rogue.subtlety.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.passiveBar)
				if TRB.Data.settings.rogue.subtlety.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.castingBar)
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.resourceBar)
				end
			end
			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.rogue.subtlety.textures.textureLock then
				TRB.Data.settings.rogue.subtlety.textures.passiveBar = TRB.Data.settings.rogue.subtlety.textures.resourceBar
				TRB.Data.settings.rogue.subtlety.textures.passiveBarName = TRB.Data.settings.rogue.subtlety.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.rogue.subtlety.textures.passiveBarName)
				TRB.Data.settings.rogue.subtlety.textures.castingBar = TRB.Data.settings.rogue.subtlety.textures.resourceBar
				TRB.Data.settings.rogue.subtlety.textures.castingBarName = TRB.Data.settings.rogue.subtlety.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.rogue.subtlety.textures.castingBarName)

				if GetSpecialization() == 3 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.rogue.subtlety.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.rogue.subtlety.textures.borderName)
		UIDropDownMenu_JustifyText(controls.dropDown.borderTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.borderTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("border")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("border")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Border Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.subtlety.textures.border
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.borderTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.textures.border = newValue
			TRB.Data.settings.rogue.subtlety.textures.borderName = newName

			if GetSpecialization() == 3 then
				if TRB.Data.settings.rogue.subtlety.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.rogue.subtlety.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.rogue.subtlety.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.rogue.subtlety.textures.backgroundName)
		UIDropDownMenu_JustifyText(controls.dropDown.backgroundTexture, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.backgroundTexture, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local textures = TRB.Details.addonData.libs.SharedMedia:HashTable("background")
			local texturesList = TRB.Details.addonData.libs.SharedMedia:List("background")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(textures) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Background Textures " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(texturesList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = textures[v]
						info.checked = textures[v] == TRB.Data.settings.rogue.subtlety.textures.background
						info.func = self.SetValue
						info.arg1 = textures[v]
						info.arg2 = v
						info.icon = textures[v]
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the texture
		function controls.dropDown.backgroundTexture:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.textures.background = newValue
			TRB.Data.settings.rogue.subtlety.textures.backgroundName = newName

			if GetSpecialization() == 3 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.rogue.subtlety.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.rogue.subtlety.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.rogue.subtlety.colors.bar.flashAlpha, 0.01, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.rogue.subtlety.colors.bar.flashPeriod, 0.05, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow = true
			TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Energy < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Energy < 100, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow = true
			TRB.Data.settings.rogue.subtlety.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow) and (not TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow = false
			TRB.Data.settings.rogue.subtlety.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.rogue.subtlety.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Energy", TRB.Data.settings.rogue.subtlety.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.rogue.subtlety.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from Passive Sources", TRB.Data.settings.rogue.subtlety.colors.bar.passive, 525, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    
					controls.colors.passive.Texture:SetColorTexture(r, g, b, 1-a)
					passiveFrame:SetStatusBarColor(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.rogue.subtlety.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30

		controls.colors.spending = TRB.UiFunctions.BuildColorPicker(parent, "Energy loss from hardcasting spender abilities", TRB.Data.settings.rogue.subtlety.colors.bar.spending, 275, 25, xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.spending.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		--[[
		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Energy gain from hardcasting builder abilities", TRB.Data.settings.rogue.subtlety.colors.bar.casting, 275, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    castingFrame:SetStatusBarColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast builder will overcap Energy", TRB.Data.settings.rogue.subtlety.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.subtlety.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		]]

		controls.colors.coordinatedAssault = TRB.UiFunctions.BuildColorPicker(parent, "Energy while Coordinated Assault is active", TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssault, 275, 25, xCoord2, yCoord)
		f = controls.colors.coordinatedAssault
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssault, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.coordinatedAssault.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssault = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.coordinatedAssaultEnding = TRB.UiFunctions.BuildColorPicker(parent, "Energy when Coordinated Assault is ending", TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssaultEnding, 275, 25, xCoord2, yCoord)
		f = controls.colors.coordinatedAssaultEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssaultEnding, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.eclipse1GCD.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssaultEnding = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Energy threshold line", TRB.Data.settings.rogue.subtlety.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Energy threshold line", TRB.Data.settings.rogue.subtlety.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.rogue.subtlety.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.rogue.subtlety)
		end)



		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Arcane Shot."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cheapShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_cheapShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cheapShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.cheapShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.cheapShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.carveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_carve", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.carveThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Carve / Butchery (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Carve or Butchery (if talented). If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.carve.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.carve.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chakramsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_chakrams", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chakramsThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chakrams (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Chakrams. Only visible if talented in to Chakrams. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.chakrams.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.chakrams.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.raptorStrikeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Raptor Strike / Mongoose Bite (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Raptor Strike or Mongoose Bite."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.raptorStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.raptorStrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.shivThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_shiv", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shivThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shiv")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shiv."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.shiv.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.shiv.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.sliceAndDiceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_sliceAndDice", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sliceAndDiceThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Slice and Dice")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Slice and Dice."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.sliceAndDice.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.sliceAndDice.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Serpent Sting."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.serpentSting.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.wingClipThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Wing Clip")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Wing Clip."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.thresholds.wingClip.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.thresholds.wingClip.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "End of Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfCoordinatedAssault = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_EOCA_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssault
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Coordinated Assault")
		f.tooltip = "Changes the bar color when Coordinated Assault is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfCoordinatedAssaultModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_EOCA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Coordinated Assault ends."
		if TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(false)
			TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode = "gcd"
		end)

		title = "Coordinated Assault GCDs - 0.75sec Floor"
		controls.endOfCoordinatedAssaultGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0.5, 20, TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfCoordinatedAssaultGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfCoordinatedAssaultModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_EOCA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Coordinated Assault ends."
		if TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(true)
			TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode = "time"
		end)

		title = "Coordinated Assault Time Remaining (sec)"
		controls.endOfCoordinatedAssaultTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.timeMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfCoordinatedAssaultTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current energy is above the overcapping maximum Energy as configured below."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 100, TRB.Data.settings.rogue.subtlety.overcapThreshold, 1, 1,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
	end

	local function SubtletyConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.subtlety
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Subtlety_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Font & Text).", 4, 3, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontLeft, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontLeft, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.subtlety.displayText.left.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontLeft:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.displayText.left.fontFace = newValue
			TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.left.fontFace, TRB.Data.settings.rogue.subtlety.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.right.fontFace, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontMiddle, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontMiddle, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontMiddle:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace = newValue
			TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
				TRB.Data.settings.rogue.subtlety.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.left.fontFace, TRB.Data.settings.rogue.subtlety.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.right.fontFace, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName)
		UIDropDownMenu_JustifyText(controls.dropDown.fontRight, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.fontRight, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
			local fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(fonts) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Fonts " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(fontsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = fonts[v]
						info.checked = fonts[v] == TRB.Data.settings.rogue.subtlety.displayText.right.fontFace
						info.func = self.SetValue
						info.arg1 = fonts[v]
						info.arg2 = v
						info.fontObject = CreateFont(v)
						info.fontObject:SetFont(fonts[v], 12, "OUTLINE")
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		function controls.dropDown.fontRight:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.displayText.right.fontFace = newValue
			TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
				TRB.Data.settings.rogue.subtlety.displayText.left.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace = newValue
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.right.fontFace, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.left.fontFace, TRB.Data.settings.rogue.subtlety.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.rogue.subtlety.displayText.fontFaceLock then
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace = TRB.Data.settings.rogue.subtlety.displayText.left.fontFace
				TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName = TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.rogue.subtlety.displayText.middle.fontFaceName)
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFace = TRB.Data.settings.rogue.subtlety.displayText.left.fontFace
				TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName = TRB.Data.settings.rogue.subtlety.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.rogue.subtlety.displayText.right.fontFaceName)

				if GetSpecialization() == 3 then
					middleTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.right.fontFace, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.subtlety.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.left.fontFace, TRB.Data.settings.rogue.subtlety.displayText.left.fontSize, "OUTLINE")
			if TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.rogue.subtlety.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.rogue.subtlety.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.rogue.subtlety.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.left, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.leftText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.rogue.subtlety.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.middle, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.middleText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.rogue.subtlety.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.right, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.rightText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize = value

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.middle.fontFace, TRB.Data.settings.rogue.subtlety.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.displayText.right.fontSize = value

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.rogue.subtlety.displayText.right.fontFace, TRB.Data.settings.rogue.subtlety.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.rogue.subtlety.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Energy Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Current Energy", TRB.Data.settings.rogue.subtlety.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.current, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.currentEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.spendingEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Energy loss from hardcasting spender abilities", TRB.Data.settings.rogue.subtlety.colors.text.spending, 275, 25, xCoord2, yCoord)
		f = controls.colors.spendingEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    --Text doesn't care about Alpha, but the color picker does!
                    a = 0.0
        
                    controls.colors.spendingEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passiveEnergyText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Energy", TRB.Data.settings.rogue.subtlety.colors.text.passive, 300, 25, xCoord, yCoord)
		f = controls.colors.passiveEnergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.passive, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.passiveEnergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.subtlety.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", TRB.Data.settings.rogue.subtlety.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.overThreshold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.thresholdenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.subtlety.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapenergyText = TRB.UiFunctions.BuildColorPicker(parent, "Current Energy is above overcap threshold", TRB.Data.settings.rogue.subtlety.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapenergyText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.overcap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end
					--Text doesn't care about Alpha, but the color picker does!
					a = 0.0

					controls.colors.overcapenergyText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.rogue.subtlety.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy or a hardcast spell will result in overcapping maximum Energy."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions.BuildSectionHeader(parent, "DoT Count Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up colors counters ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.rogue.subtlety.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.dots.up, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.rogue.subtlety.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.dots.pandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions.BuildColorPicker(parent, "DoT is not active on current target", TRB.Data.settings.rogue.subtlety.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.text.dots.down, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.rogue.subtlety.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.subtlety.hastePrecision, 1, 0,
										sliderWidth, sliderHeight, xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
	end

	local function SubtletyConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.subtlety
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		local title = ""

		local dropdownWidth = 225
		local sliderWidth = 260
		local sliderHeight = 20

		controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Audio & Tracking).", 4, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.subtlety.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.rogue.subtlety.audio.killShot.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.killShotAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.killShotAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.subtlety.audio.killShot.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.killShotAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.audio.killShot.sound = newValue
			TRB.Data.settings.rogue.subtlety.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.subtlety.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.rogue.subtlety.audio.overcap.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.subtlety.audio.overcap.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.overcapAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.audio.overcap.sound = newValue
			TRB.Data.settings.rogue.subtlety.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Energy and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.subtlety.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.rogue.subtlety.audio.flayersMark.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.flayersMarkAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.flayersMarkAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.subtlety.audio.flayersMark.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.flayersMarkAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.audio.flayersMark.sound = newValue
			TRB.Data.settings.rogue.subtlety.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Energy."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Rogue_Subtlety_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.nesingwarysTrappingApparatusAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.nesingwarysTrappingApparatusAudio, function(self, level, menuList)
			local entries = 25
			local info = UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
				for i=0, menus-1 do
					info.hasArrow = true
					info.notCheckable = true
					info.text = "Sounds " .. i+1
					info.menuList = i
					UIDropDownMenu_AddButton(info)
				end
			else
				local start = entries * menuList

				for k, v in pairs(soundsList) do
					if k > start and k <= start + entries then
						info.text = v
						info.value = sounds[v]
						info.checked = sounds[v] == TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.nesingwarysTrappingApparatusAudio:SetValue(newValue, newName)
			TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.rogue.subtlety.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.rogue.subtlety.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation from GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD."
		if TRB.Data.settings.rogue.subtlety.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			TRB.Data.settings.rogue.subtlety.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
		controls.energyGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.rogue.subtlety.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if TRB.Data.settings.rogue.subtlety.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			TRB.Data.settings.rogue.subtlety.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
		controls.energyGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.rogue.subtlety.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.rogue.subtlety.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls
	end
    
	local function SubtletyConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.subtlety
		local yCoord = 5
		local f = nil

		local maxOptionsWidth = 580

		local xPadding = 10
		local xPadding2 = 30
		local xCoord = 5
		local xCoord2 = 290
		local xOffset1 = 50
		local xOffset2 = xCoord2 + xOffset1

		TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Rogue_Subtlety_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Rogue_Subtlety_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (Bar Text).", 4, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.subtlety.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.subtlety.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.subtlety)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.subtlety.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.subtlety.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.subtlety)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.rogue.subtlety.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.rogue.subtlety.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.subtlety)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function SubtletyConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.subtlety or {}
		local yCoord = 0
		local f = nil
		local xPadding = 10
		local xPadding2 = 30
		local xMax = 550
		local xCoord = 0
		local xCoord2 = 325
		local xOffset1 = 50
		local xOffset2 = 275

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}		
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.subtletyDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Rogue_Subtlety", UIParent)
		interfaceSettingsFrame.subtletyDisplayPanel.name = "Subtlety Rogue"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.subtletyDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.subtletyDisplayPanel)

		parent = interfaceSettingsFrame.subtletyDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Subtlety Rogue", xCoord+xPadding, yCoord-5)
	
		controls.checkBoxes.subtletyRogueEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Rogue_Subtlety_subtletyRogueEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.subtletyRogueEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Subtlety Rogue specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.rogue.subtlety)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.rogue.subtlety = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)
		end)

		TRB.UiFunctions.ToggleCheckboxOnOff(controls.checkBoxes.subtletyRogueEnabled, TRB.Data.settings.core.enabled.rogue.subtlety, true)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Rogue_Subtlety_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Rogue_Subtlety_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Subtlety Rogue (All).", 4, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Rogue_Subtlety_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Rogue_Subtlety_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		tabsheets[1].selected = true
		tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.subtlety = controls

		SubtletyConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		SubtletyConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		SubtletyConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		SubtletyConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		SubtletyConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	local function ConstructOptionsPanel(specCache)
		TRB.Options.ConstructOptionsPanel()
		AssassinationConstructOptionsPanel(specCache.assassination)
		--OutlawConstructOptionsPanel(specCache.outlaw)
		--SubtletyConstructOptionsPanel(specCache.subtlety)
	end
	TRB.Options.Rogue.ConstructOptionsPanel = ConstructOptionsPanel
end