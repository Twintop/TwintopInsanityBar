local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
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

	TRB.Options.Hunter = {}
	TRB.Options.Hunter.BeastMastery = {}
	TRB.Options.Hunter.Marksmanship = {}
	TRB.Options.Hunter.Survival = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.survival = {}

	local function BeastMasteryLoadDefaultBarTextSimpleSettings()
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
				text="{$frenzyStacks}[$frenzyTime ($frenzyStacks)]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function BeastMasteryLoadDefaultBarTextAdvancedSettings()
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
				text="{$frenzyStacks}[#frenzy$frenzyTime - $frenzyStacks#frenzy]||n{$flayersMarkTime}[#flayersMark $flayersMarkTime #flayersMark]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$barbedShotFocus}[#barbedShot$barbedShotFocus+]{$regen}[$regen+]$focus",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function BeastMasteryLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			thresholdWidth=2,
			overcapThreshold=120,
			thresholds = {
					arcaneShot = {
						enabled = false, -- 1
					},
					aMurderOfCrows = {
						enabled = true, -- 2
					},
					barrage = {
						enabled = true, -- 3
					},
					cobraShot = {
						enabled = true, -- 4
					},
					killCommand = {
						enabled = true, -- 5
					},
					killShot = {
						enabled = true, -- 6
					},
					multiShot = {
						enabled = true, -- 7
					},
					revivePet = {
						enabled = false, -- 8
					},
					scareBeast = {
						enabled = false, -- 9
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
					right="FFFFFFFF"
				},
				bar = {
					border="FFAB5124",
					borderOvercap="FFFF0000",
					borderBeastialWrath="FF005500",
					background="66000000",
					base="FFFF8040",
					frenzyUse="FF00B60E",
					frenzyHold="FFFF0000",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF005500",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					overcapEnabled=true,
					beastialWrathEnabled=true
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
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
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

		settings.displayText = BeastMasteryLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function BeastMasteryResetSettings()
		local settings = BeastMasteryLoadDefaultSettings()
		return settings
	end



	local function MarksmanshipLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function MarksmanshipLoadDefaultBarTextAdvancedSettings()
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
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$focus",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function MarksmanshipLoadDefaultSettings()
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
				barrage = {
					enabled = true, -- 4
				},
				killShot = {
					enabled = true, -- 5
				},
				multiShot = {
					enabled = true, -- 6
				},
				aMurderOfCrows = {
					enabled = true, -- 7
				},
				explosiveShot = {
					enabled = false, -- 8
				},
				scareBeast = {
					enabled = false, -- 9
				},
				burstingShot = {
					enabled = false, -- 10
				},
				revivePet = {
					enabled = false, -- 11
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
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn",
					mode="gcd",
					gcds=1,
					time=1.5
				},
				lockAndLoad={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				overcap={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				secretsOfTheUnblinkingVigil={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
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

		settings.displayText = MarksmanshipLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function MarksmanshipResetSettings()
		local settings = MarksmanshipLoadDefaultSettings()
		return settings
	end



	local function SurvivalLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$focus",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function SurvivalLoadDefaultBarTextAdvancedSettings()
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
				text = "{$casting}[#casting$casting+]{$toeFocus}[#termsOfEngagement$toeFocus+]{$regen}[$regen+]$focus",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function SurvivalLoadDefaultSettings()
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
					scareBeast = {
						enabled = false, -- 3
					},
					revivePet = {
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
					aMurderOfCrows = {
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
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
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

		settings.displayText = SurvivalLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function SurvivalResetSettings()
		local settings = SurvivalLoadDefaultSettings()
		return settings
	end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.hunter.beastMastery = BeastMasteryLoadDefaultSettings()
		settings.hunter.marksmanship = MarksmanshipLoadDefaultSettings()
		settings.hunter.survival = SurvivalLoadDefaultSettings()
		return settings
	end
    TRB.Options.Hunter.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Beast Mastery Option Menus

	]]

	local function BeastMasteryConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
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

		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to it's default configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.beastMastery = BeastMasteryResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.beastMastery.displayText = BeastMasteryLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.beastMastery.displayText = BeastMasteryLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.beastMastery.displayText = BeastMasteryLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_BeastMastery_ResetButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(150)
		f:SetHeight(30)
		f:SetText("Reset to Defaults")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimpleButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Simple)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Narrow Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced")
		end)
		]]
        
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Full Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.hunter.beastMastery.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.beastMastery.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.beastMastery)

		controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Display).", 3, 1, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.hunter.beastMastery.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.beastMastery.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.beastMastery.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.hunter.beastMastery)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.beastMastery, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.beastMastery.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.hunter.beastMastery.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.beastMastery.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.beastMastery.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 1 then
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.hunter.beastMastery)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.hunter.beastMastery.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.bar.xPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.beastMastery.bar.xPos, TRB.Data.settings.hunter.beastMastery.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.hunter.beastMastery.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.bar.yPos = value

			if GetSpecialization() == 1 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.beastMastery.bar.xPos, TRB.Data.settings.hunter.beastMastery.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.hunter.beastMastery.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.bar.border = value

			if GetSpecialization() == 1 then
				barContainerFrame:SetWidth(TRB.Data.settings.hunter.beastMastery.bar.width-(TRB.Data.settings.hunter.beastMastery.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.hunter.beastMastery.bar.height-(TRB.Data.settings.hunter.beastMastery.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.hunter.beastMastery.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.hunter.beastMastery.bar.height)
				if TRB.Data.settings.hunter.beastMastery.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.hunter.beastMastery.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.hunter.beastMastery.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.hunter.beastMastery.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.hunter.beastMastery)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.beastMastery, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.beastMastery.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.hunter.beastMastery.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.hunter.beastMastery.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.beastMastery)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.hunter.beastMastery.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.thresholdWidth = value

			if GetSpecialization() == 1 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.hunter.beastMastery.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop)
		end)

		if TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay then
			controls.checkBoxes.lockPosition:Disable()
			getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
		end

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			if TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay then				
				controls.checkBoxes.lockPosition:Disable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)				
			else
				controls.checkBoxes.lockPosition:Enable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(1, 1, 1)
			end

			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.beastMastery.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.beastMastery.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.hunter.beastMastery)
		end)




		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FocusBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.beastMastery.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.beastMastery.textures.resourceBar
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
			TRB.Data.settings.hunter.beastMastery.textures.resourceBar = newValue
			TRB.Data.settings.hunter.beastMastery.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
				TRB.Data.settings.hunter.beastMastery.textures.castingBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.hunter.beastMastery.textures.passiveBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.resourceBar)
				if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.beastMastery.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.beastMastery.textures.castingBar
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
			TRB.Data.settings.hunter.beastMastery.textures.castingBar = newValue
			TRB.Data.settings.hunter.beastMastery.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
				TRB.Data.settings.hunter.beastMastery.textures.resourceBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.beastMastery.textures.passiveBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
				if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.hunter.beastMastery.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.beastMastery.textures.passiveBar
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
			TRB.Data.settings.hunter.beastMastery.textures.passiveBar = newValue
			TRB.Data.settings.hunter.beastMastery.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
				TRB.Data.settings.hunter.beastMastery.textures.resourceBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.beastMastery.textures.castingBar = newValue
				TRB.Data.settings.hunter.beastMastery.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 1 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
				if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.hunter.beastMastery.textures.textureLock then
				TRB.Data.settings.hunter.beastMastery.textures.passiveBar = TRB.Data.settings.hunter.beastMastery.textures.resourceBar
				TRB.Data.settings.hunter.beastMastery.textures.passiveBarName = TRB.Data.settings.hunter.beastMastery.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.beastMastery.textures.passiveBarName)
				TRB.Data.settings.hunter.beastMastery.textures.castingBar = TRB.Data.settings.hunter.beastMastery.textures.resourceBar
				TRB.Data.settings.hunter.beastMastery.textures.castingBarName = TRB.Data.settings.hunter.beastMastery.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.beastMastery.textures.castingBarName)

				if GetSpecialization() == 1 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.beastMastery.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.hunter.beastMastery.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.beastMastery.textures.border
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
			TRB.Data.settings.hunter.beastMastery.textures.border = newValue
			TRB.Data.settings.hunter.beastMastery.textures.borderName = newName

			if GetSpecialization() == 1 then
				if TRB.Data.settings.hunter.beastMastery.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.hunter.beastMastery.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.hunter.beastMastery.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.hunter.beastMastery.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.beastMastery.textures.background
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
			TRB.Data.settings.hunter.beastMastery.textures.background = newValue
			TRB.Data.settings.hunter.beastMastery.textures.backgroundName = newName

			if GetSpecialization() == 1 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.hunter.beastMastery.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.hunter.beastMastery.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 50

		title = "Beastial Wrath Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.hunter.beastMastery.colors.bar.flashAlpha, 0.01, 2,
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
			TRB.Data.settings.hunter.beastMastery.colors.bar.flashAlpha = value
		end)

		title = "Beastial Wrath Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0.05, 2, TRB.Data.settings.hunter.beastMastery.colors.bar.flashPeriod, 0.05, 2,
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
			TRB.Data.settings.hunter.beastMastery.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow = true
			TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 120")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 120, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow = true
			TRB.Data.settings.hunter.beastMastery.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow) and (not TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.beastMastery.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.bar.showPassive = self:GetChecked()
		end)

		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Beastial Wrath is usable")
		f.tooltip = "This will flash the bar when Beastial Wrath can be cast."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.esThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esThresholdShow
		f:SetPoint("TOPLEFT", xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Border color when Beastial Wrath is usable")
		f.tooltip = "This will change the bar's border color (as configured below) when Beastial Wrath is usable."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.colors.bar.beastialWrathEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.colors.bar.beastialWrathEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Focus", TRB.Data.settings.hunter.beastMastery.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.hunter.beastMastery.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from Passive Sources", TRB.Data.settings.hunter.beastMastery.colors.bar.passive, 275, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.passive, true)
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
                    TRB.Data.settings.hunter.beastMastery.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderBeastialWrath = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when you can use Beastial Wrath", TRB.Data.settings.hunter.beastMastery.colors.bar.borderBeastialWrath, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderBeastialWrath
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.borderBeastialWrath, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.bar.borderBeastialWrath = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.frenzyUse = TRB.UiFunctions.BuildColorPicker(parent, "Focus when Barbed Shot should be used", TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse, 275, 25, xCoord, yCoord)
		f = controls.colors.frenzyUse
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.frenzyUse.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.hunter.beastMastery.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.frenzyHold = TRB.UiFunctions.BuildColorPicker(parent, "Focus when Barbed Shot charges should be held", TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyHold, 275, 25, xCoord, yCoord)
		f = controls.colors.frenzyHold
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyHold, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.frenzyHold.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyHold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Focus threshold line", TRB.Data.settings.hunter.beastMastery.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Focus threshold line", TRB.Data.settings.hunter.beastMastery.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.hunter.beastMastery)
		end)

		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.barrageThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Barrage (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Barrage. Only visible if talented in to Barrage. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.barrage.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.barrage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cobraShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_cobraShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cobraShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cobra Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Cobra Shot."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.cobraShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.cobraShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killCommandThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Command")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Command."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.killCommand.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.killCommand.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.multiShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Multi-Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Multi-Shot."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.multiShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.multiShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above the overcapping maximum Focus as configured below."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 120, TRB.Data.settings.hunter.beastMastery.overcapThreshold, 1, 1,
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
			TRB.Data.settings.hunter.beastMastery.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
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

		controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Font & Text).", 3, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace
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
			TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace = newValue
			TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_fFontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace
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
			TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace = newValue
			TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
				TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace
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
			TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace = newValue
			TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
				TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.hunter.beastMastery.displayText.fontFaceLock then
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace = TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace
				TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName = TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFaceName)
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace = TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace
				TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName = TRB.Data.settings.hunter.beastMastery.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.beastMastery.displayText.right.fontFaceName)

				if GetSpecialization() == 1 then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize = value

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.left.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.hunter.beastMastery.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.hunter.beastMastery.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.left, true)
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
                    TRB.Data.settings.hunter.beastMastery.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.hunter.beastMastery.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.middle, true)
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
                    TRB.Data.settings.hunter.beastMastery.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.hunter.beastMastery.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.right, true)
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
                    TRB.Data.settings.hunter.beastMastery.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize = value

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.middle.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize = value

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.beastMastery.displayText.right.fontFace, TRB.Data.settings.hunter.beastMastery.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.beastMastery.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Current Focus", TRB.Data.settings.hunter.beastMastery.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.current, true)
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
        
                    controls.colors.currentFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.beastMastery.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		
		controls.colors.passiveFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Focus", TRB.Data.settings.hunter.beastMastery.colors.text.passive, 275, 25, xCoord2, yCoord)
		f = controls.colors.passiveFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.passive, true)
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

					controls.colors.passiveFocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.beastMastery.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", TRB.Data.settings.hunter.beastMastery.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.overThreshold, true)
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

					controls.colors.thresholdfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.beastMastery.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Current Focus is above overcap threshold", TRB.Data.settings.hunter.beastMastery.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.text.overcap, true)
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

					controls.colors.overcapfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.beastMastery.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current focus is above the overcapping maximum Focus value."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.beastMastery.hastePrecision, 1, 0,
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
			TRB.Data.settings.hunter.beastMastery.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
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

		controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Audio & Tracking).", 3, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.beastMastery.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.hunter.beastMastery.audio.killShot.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.beastMastery.audio.killShot.sound
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
			TRB.Data.settings.hunter.beastMastery.audio.killShot.sound = newValue
			TRB.Data.settings.hunter.beastMastery.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.beastMastery.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.hunter.beastMastery.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.beastMastery.audio.overcap.sound
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
			TRB.Data.settings.hunter.beastMastery.audio.overcap.sound = newValue
			TRB.Data.settings.hunter.beastMastery.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.beastMastery.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.hunter.beastMastery.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.beastMastery.audio.flayersMark.sound
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
			TRB.Data.settings.hunter.beastMastery.audio.flayersMark.sound = newValue
			TRB.Data.settings.hunter.beastMastery.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.sound
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
			TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		--[[
		yCoord = yCoord - 60
		controls.checkBoxes.secretsOfTheUnblinkingVigilAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_secretsOfTheUnblinkingVigil_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secretsOfTheUnblinkingVigilAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Secrets of the Unblinking Vigil proc")
		f.tooltip = "Play an audio cue when you get a Secrets of the Unblinking Vigil proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.secretsOfTheUnblinkingVigilAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_secretsOfTheUnblinkingVigilAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.secretsOfTheUnblinkingVigilAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.sound
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
			TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.sound = newValue
			TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		]]


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.hunter.beastMastery.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.beastMastery.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD length."
		if TRB.Data.settings.hunter.beastMastery.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			TRB.Data.settings.hunter.beastMastery.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.hunter.beastMastery.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if TRB.Data.settings.hunter.beastMastery.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			TRB.Data.settings.hunter.beastMastery.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.beastMastery.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.beastMastery.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end
    
	local function BeastMasteryConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
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
		controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Text).", 3, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.beastMastery.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.beastMastery.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.beastMastery)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.beastMastery.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.beastMastery.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.beastMastery)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.beastMastery.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.beastMastery.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.beastMastery)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function BeastMasteryConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.beastMastery or {}
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

		interfaceSettingsFrame.beastMasteryDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_BeastMastery", UIParent)
		interfaceSettingsFrame.beastMasteryDisplayPanel.name = "Beast Mastery Hunter"
		interfaceSettingsFrame.beastMasteryDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.beastMasteryDisplayPanel)

		parent = interfaceSettingsFrame.beastMasteryDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Beast Mastery Hunter", xCoord+xPadding, yCoord-5)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (All).", 3, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Hunter_BeastMastery_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1
		parent.tabsheets[1].selected = true
		parent.tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls

		BeastMasteryConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		BeastMasteryConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		BeastMasteryConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		BeastMasteryConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		BeastMasteryConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Marksmanship Option Menus

	]]

	local function MarksmanshipConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
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

		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to it's default configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.marksmanship = MarksmanshipResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.marksmanship.displayText = MarksmanshipLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.marksmanship.displayText = MarksmanshipLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.marksmanship.displayText = MarksmanshipLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Marksmanship_ResetButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(150)
		f:SetHeight(30)
		f:SetText("Reset to Defaults")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimpleButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Simple)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Narrow Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced")
		end)
		]]
        
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Full Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.hunter.marksmanship.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.marksmanship.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.marksmanship)

		controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Display).", 3, 2, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.hunter.marksmanship.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.marksmanship.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.marksmanship.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 2 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.hunter.marksmanship)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.marksmanship, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.marksmanship.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.hunter.marksmanship.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.marksmanship.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.marksmanship.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 2 then				
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.hunter.marksmanship)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.hunter.marksmanship.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.bar.xPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.marksmanship.bar.xPos, TRB.Data.settings.hunter.marksmanship.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.hunter.marksmanship.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.bar.yPos = value

			if GetSpecialization() == 2 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.marksmanship.bar.xPos, TRB.Data.settings.hunter.marksmanship.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.hunter.marksmanship.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.bar.border = value

			if GetSpecialization() == 2 then
				barContainerFrame:SetWidth(TRB.Data.settings.hunter.marksmanship.bar.width-(TRB.Data.settings.hunter.marksmanship.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.hunter.marksmanship.bar.height-(TRB.Data.settings.hunter.marksmanship.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.hunter.marksmanship.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.hunter.marksmanship.bar.height)
				if TRB.Data.settings.hunter.marksmanship.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.hunter.marksmanship.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.hunter.marksmanship.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.hunter.marksmanship.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.hunter.marksmanship)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.marksmanship, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.marksmanship.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.hunter.marksmanship.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.hunter.marksmanship.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.marksmanship)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.hunter.marksmanship.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.thresholdWidth = value

			if GetSpecialization() == 2 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.hunter.marksmanship.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop)
		end)

		if TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay then
			controls.checkBoxes.lockPosition:Disable()
			getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
		end

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			if TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay then				
				controls.checkBoxes.lockPosition:Disable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)				
			else
				controls.checkBoxes.lockPosition:Enable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(1, 1, 1)
			end

			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.marksmanship.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.marksmanship.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.hunter.marksmanship)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FocusBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.marksmanship.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.marksmanship.textures.resourceBar
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
			TRB.Data.settings.hunter.marksmanship.textures.resourceBar = newValue
			TRB.Data.settings.hunter.marksmanship.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
				TRB.Data.settings.hunter.marksmanship.textures.castingBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.hunter.marksmanship.textures.passiveBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.resourceBar)
				if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.marksmanship.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.marksmanship.textures.castingBar
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
			TRB.Data.settings.hunter.marksmanship.textures.castingBar = newValue
			TRB.Data.settings.hunter.marksmanship.textures.castingBarName = newName
			castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
				TRB.Data.settings.hunter.marksmanship.textures.resourceBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.marksmanship.textures.passiveBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.passiveBarName = newName
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
				if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.hunter.marksmanship.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.marksmanship.textures.passiveBar
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
			TRB.Data.settings.hunter.marksmanship.textures.passiveBar = newValue
			TRB.Data.settings.hunter.marksmanship.textures.passiveBarName = newName
			passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
				TRB.Data.settings.hunter.marksmanship.textures.resourceBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.resourceBarName = newName
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.resourceBar)
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.marksmanship.textures.castingBar = newValue
				TRB.Data.settings.hunter.marksmanship.textures.castingBarName = newName
				castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 2 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
				if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.resourceBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.hunter.marksmanship.textures.textureLock then
				TRB.Data.settings.hunter.marksmanship.textures.passiveBar = TRB.Data.settings.hunter.marksmanship.textures.resourceBar
				TRB.Data.settings.hunter.marksmanship.textures.passiveBarName = TRB.Data.settings.hunter.marksmanship.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.marksmanship.textures.passiveBarName)
				TRB.Data.settings.hunter.marksmanship.textures.castingBar = TRB.Data.settings.hunter.marksmanship.textures.resourceBar
				TRB.Data.settings.hunter.marksmanship.textures.castingBarName = TRB.Data.settings.hunter.marksmanship.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.marksmanship.textures.castingBarName)

				if GetSpecialization() == 2 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.marksmanship.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.hunter.marksmanship.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.marksmanship.textures.border
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
			TRB.Data.settings.hunter.marksmanship.textures.border = newValue
			TRB.Data.settings.hunter.marksmanship.textures.borderName = newName

			if GetSpecialization() == 2 then
				if TRB.Data.settings.hunter.marksmanship.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.hunter.marksmanship.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.hunter.marksmanship.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.hunter.marksmanship.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.marksmanship.textures.background
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
			TRB.Data.settings.hunter.marksmanship.textures.background = newValue
			TRB.Data.settings.hunter.marksmanship.textures.backgroundName = newName

			if GetSpecialization() == 2 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.hunter.marksmanship.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.hunter.marksmanship.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.hunter.marksmanship.colors.bar.flashAlpha, 0.01, 2,
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
			TRB.Data.settings.hunter.marksmanship.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.hunter.marksmanship.colors.bar.flashPeriod, 0.05, 2,
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
			TRB.Data.settings.hunter.marksmanship.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow = true
			TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 100, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow = true
			TRB.Data.settings.hunter.marksmanship.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow) and (not TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.marksmanship.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Focus", TRB.Data.settings.hunter.marksmanship.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.hunter.marksmanship.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from hardcasting builder abilities", TRB.Data.settings.hunter.marksmanship.colors.bar.casting, 275, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    castingFrame:SetStatusBarColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast builder will overcap Focus", TRB.Data.settings.hunter.marksmanship.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.marksmanship.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.spending = TRB.UiFunctions.BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", TRB.Data.settings.hunter.marksmanship.colors.bar.spending, 275, 25, xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.spending.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.hunter.marksmanship.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from Passive Sources", TRB.Data.settings.hunter.marksmanship.colors.bar.passive, 525, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true)
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
                    TRB.Data.settings.hunter.marksmanship.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.trueshot = TRB.UiFunctions.BuildColorPicker(parent, "Focus while Trueshot is active", TRB.Data.settings.hunter.marksmanship.colors.bar.trueshot, 275, 25, xCoord2, yCoord)
		f = controls.colors.trueshot
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.trueshot, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.trueshot.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.bar.trueshot = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30

		controls.colors.trueshotEnding = TRB.UiFunctions.BuildColorPicker(parent, "Focus when Trueshot is ending", TRB.Data.settings.hunter.marksmanship.colors.bar.trueshotEnding, 275, 25, xCoord2, yCoord)
		f = controls.colors.trueshotEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.trueshotEnding, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.eclipse1GCD.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.marksmanship.colors.bar.trueshotEnding = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Focus threshold line", TRB.Data.settings.hunter.marksmanship.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Focus threshold line", TRB.Data.settings.hunter.marksmanship.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.hunter.marksmanship)
		end)

		controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Aimed Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Aimed Shot. If there are 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.aimedShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot/Chimera Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot or Chimera Shot."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.barrageThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Barrage (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Barrage. Only visible if talented in to Barrage. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.barrage.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.barrage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.burstingShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_burstingShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.burstingShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Bursting Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Bursting Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.burstingShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.burstingShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.explosiveShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Explosive Shot (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Explosive Shot. Only visible if talented in to Explosive Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.explosiveShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.explosiveShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.multiShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Multi-Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Multi-Shot."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.multiShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.multiShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Serpent Sting. Only visible if talented in to Serpent Sting."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.thresholds.serpentSting.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "End of Trueshot Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfTrueshot = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfTrueshot
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Trueshot")
		f.tooltip = "Changes the bar color when Trueshot is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.endOfTrueshot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.endOfTrueshot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfTrueshotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Trueshot ends."
		if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode = "gcd"
		end)

		title = "Trueshot GCDs - 0.75sec Floor"
		controls.endOfTrueshotGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0.5, 20, TRB.Data.settings.hunter.marksmanship.endOfTrueshot.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfTrueshotGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.endOfTrueshot.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfTrueshotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Trueshot ends."
		if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(true)
			TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode = "time"
		end)

		title = "Trueshot Time Remaining (sec)"
		controls.endOfTrueshotTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.marksmanship.endOfTrueshot.timeMax, 0.25, 2,
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
			TRB.Data.settings.hunter.marksmanship.endOfTrueshot.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above or a hardcast spell will result in overcapping maximum Focus as configured below."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 100, TRB.Data.settings.hunter.marksmanship.overcapThreshold, 1, 1,
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
			TRB.Data.settings.hunter.marksmanship.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
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

		controls.buttons.exportButton_Hunter_Marksmanship_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Font & Text).", 3, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace
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
			TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace = newValue
			TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_fFontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace
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
			TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace = newValue
			TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
				TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace
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
			TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace = newValue
			TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
				TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.hunter.marksmanship.displayText.fontFaceLock then
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace = TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace
				TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName = TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFaceName)
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace = TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace
				TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName = TRB.Data.settings.hunter.marksmanship.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.marksmanship.displayText.right.fontFaceName)

				if GetSpecialization() == 2 then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize = value

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.left.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.hunter.marksmanship.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.hunter.marksmanship.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.left, true)
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
                    TRB.Data.settings.hunter.marksmanship.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.hunter.marksmanship.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.middle, true)
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
                    TRB.Data.settings.hunter.marksmanship.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.hunter.marksmanship.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.right, true)
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
                    TRB.Data.settings.hunter.marksmanship.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize = value

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.middle.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize = value

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.marksmanship.displayText.right.fontFace, TRB.Data.settings.hunter.marksmanship.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.marksmanship.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Current Focus", TRB.Data.settings.hunter.marksmanship.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.current, true)
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
        
                    controls.colors.currentFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.castingFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from hardcasting builder abilities", TRB.Data.settings.hunter.marksmanship.colors.text.casting, 275, 25, xCoord2, yCoord)
		f = controls.colors.castingFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.casting, true)
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
        
                    controls.colors.castingFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)


		yCoord = yCoord - 30
		controls.colors.passiveFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Focus", TRB.Data.settings.hunter.marksmanship.colors.text.passive, 300, 25, xCoord, yCoord)
		f = controls.colors.passiveFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.passive, true)
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

					controls.colors.passiveFocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.marksmanship.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.spendingFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", TRB.Data.settings.hunter.marksmanship.colors.text.spending, 275, 25, xCoord2, yCoord)
		f = controls.colors.spendingFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.spending, true)
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
        
                    controls.colors.spendingFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold, true)
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

					controls.colors.thresholdfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Hardcasting builder ability will overcap Focus", TRB.Data.settings.hunter.marksmanship.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.overcap, true)
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

					controls.colors.overcapfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.marksmanship.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current hardcast spell will result in overcapping maximum Focus."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions.BuildSectionHeader(parent, "DoT Count Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up colors counters ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.hunter.marksmanship.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.dots.up, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.hunter.marksmanship.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.dots.pandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions.BuildColorPicker(parent, "DoT is not active oncurrent target", TRB.Data.settings.hunter.marksmanship.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.text.dots.down, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.marksmanship.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.marksmanship.hastePrecision, 1, 0,
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
			TRB.Data.settings.hunter.marksmanship.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
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

		controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Audio & Tracking).", 3, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.aimedShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_aimedShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Aimed Shot will cap charges")
		f.tooltip = "Play an audio cue when Aimed Shot will cap charges. The timeframe is the current cast time of Aimed shot plus either GCDs or Time as configured below."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.aimedShot.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.aimedShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_aimedShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.aimedShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.aimedShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, TRB.Data.settings.hunter.marksmanship.audio.aimedShot.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		
		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of GCDs before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(true)
			controls.checkBoxes.aimedShotModeTime:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode = "gcd"
		end)

		title = "GCDs - 0.75sec Floor"
		controls.aimedShotGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 6, TRB.Data.settings.hunter.marksmanship.audio.aimedShot.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.aimedShotGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of seconds before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(false)
			controls.checkBoxes.aimedShotModeTime:SetChecked(true)
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode = "time"
		end)

		title = "Time (sec)"
		controls.aimedShotTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 12, TRB.Data.settings.hunter.marksmanship.audio.aimedShot.time, 0.25, 2,
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
			TRB.Data.settings.hunter.marksmanship.audio.aimedShot.time = value
		end)



		yCoord = yCoord - 50
		controls.checkBoxes.lockAndLoadAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockAndLoadAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Lock and Load proc (if talented)")
		f.tooltip = "Play an audio cue when a Lock and Load proc occurs."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.lockAndLoadAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.lockAndLoadAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.lockAndLoadAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.hunter.marksmanship.audio.killShot.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.killShot.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.killShot.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.hunter.marksmanship.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.overcap.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.overcap.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.hunter.marksmanship.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.flayersMark.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.flayersMark.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.secretsOfTheUnblinkingVigilAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigil_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secretsOfTheUnblinkingVigilAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Secrets of the Unblinking Vigil proc")
		f.tooltip = "Play an audio cue when you get a Secrets of the Unblinking Vigil proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.secretsOfTheUnblinkingVigilAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigilAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.secretsOfTheUnblinkingVigilAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.sound
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
			TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.sound = newValue
			TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.hunter.marksmanship.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.marksmanship.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD."
		if TRB.Data.settings.hunter.marksmanship.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			TRB.Data.settings.hunter.marksmanship.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.hunter.marksmanship.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			TRB.Data.settings.hunter.marksmanship.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.marksmanship.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.marksmanship.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end
    
	local function MarksmanshipConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
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
		controls.buttons.exportButton_Hunter_Marksmanship_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Text).", 3, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.marksmanship.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.marksmanship.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.marksmanship.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.marksmanship.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
		end)


		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.marksmanship.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.marksmanship.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function MarksmanshipConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.marksmanship or {}
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

		interfaceSettingsFrame.marksmanshipDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Marksmanship", UIParent)
		interfaceSettingsFrame.marksmanshipDisplayPanel.name = "Marksmanship Hunter"
		interfaceSettingsFrame.marksmanshipDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.marksmanshipDisplayPanel)

		parent = interfaceSettingsFrame.marksmanshipDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Marksmanship Hunter", xCoord+xPadding, yCoord-5)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (All).", 3, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Hunter_Marksmanship_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1
		parent.tabsheets[1].selected = true
		parent.tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls

		MarksmanshipConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		MarksmanshipConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		MarksmanshipConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		MarksmanshipConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		MarksmanshipConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Survival Options Menus

	]]

    
	local function SurvivalConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
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

		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to it's default configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.survival = SurvivalResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (simple) configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.survival.displayText = SurvivalLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (advanced) configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.survival.displayText = SurvivalLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to it's default (narrow advanced) configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.hunter.survival.displayText = SurvivalLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Survival_ResetButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(150)
		f:SetHeight(30)
		f:SetText("Reset to Defaults")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions.BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Survival_ResetBarTextSimpleButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Simple)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Survival_ResetBarTextNarrowAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord2, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Narrow Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextNarrowAdvanced")
		end)
		]]
        
		controls.resetButton = CreateFrame("Button", "TwintopResourceBar_Hunter_Survival_ResetBarTextAdvancedButton", parent)
		f = controls.resetButton
		f:SetPoint("TOPLEFT", parent, "TOPLEFT", xCoord, yCoord)
		f:SetWidth(250)
		f:SetHeight(30)
		f:SetText("Reset Bar Text (Full Advanced)")
		f:SetNormalFontObject("GameFontNormal")
		f.ntex = f:CreateTexture()
		f.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		f.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ntex:SetAllPoints()
		f:SetNormalTexture(f.ntex)
		f.htex = f:CreateTexture()
		f.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		f.htex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.htex:SetAllPoints()
		f:SetHighlightTexture(f.htex)
		f.ptex = f:CreateTexture()
		f.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		f.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		f.ptex:SetAllPoints()
		f:SetPushedTexture(f.ptex)
		f:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
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

		local maxBorderHeight = math.min(math.floor(TRB.Data.settings.hunter.survival.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.survival.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.survival)

		controls.buttons.exportButton_Hunter_Survival_BarDisplay = TRB.UiFunctions.BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Display).", 3, 3, true, false, false, false, false)
		end)

		controls.barPositionSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Position and Size", 0, yCoord)

		yCoord = yCoord - 40
		title = "Bar Width"
		controls.width = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, TRB.Data.settings.hunter.survival.bar.width, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.width:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.bar.width = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.survival.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.survival.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarWidth(TRB.Data.settings.hunter.survival)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.survival, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.survival.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end
		end)

		title = "Bar Height"
		controls.height = TRB.UiFunctions.BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, TRB.Data.settings.hunter.survival.bar.height, 1, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.height:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.bar.height = value

			local maxBorderSize = math.min(math.floor(TRB.Data.settings.hunter.survival.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(TRB.Data.settings.hunter.survival.bar.width / TRB.Data.constants.borderWidthFactor))
			controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.borderWidth.MaxLabel:SetText(maxBorderSize)

			if GetSpecialization() == 3 then
				TRB.Functions.UpdateBarHeight(TRB.Data.settings.hunter.survival)
			end
		end)

		title = "Bar Horizontal Position"
		yCoord = yCoord - 60
		controls.horizontal = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), TRB.Data.settings.hunter.survival.bar.xPos, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.horizontal:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.bar.xPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.survival.bar.xPos, TRB.Data.settings.hunter.survival.bar.yPos)
			end
		end)

		title = "Bar Vertical Position"
		controls.vertical = TRB.UiFunctions.BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), TRB.Data.settings.hunter.survival.bar.yPos, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.vertical:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.bar.yPos = value

			if GetSpecialization() == 3 then
				barContainerFrame:ClearAllPoints()
				barContainerFrame:SetPoint("CENTER", UIParent)
				barContainerFrame:SetPoint("CENTER", TRB.Data.settings.hunter.survival.bar.xPos, TRB.Data.settings.hunter.survival.bar.yPos)
			end
		end)

		title = "Bar Border Width"
		yCoord = yCoord - 60
		controls.borderWidth = TRB.UiFunctions.BuildSlider(parent, title, 0, maxBorderHeight, TRB.Data.settings.hunter.survival.bar.border, 1, 2,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.borderWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.bar.border = value

			if GetSpecialization() == 3 then
				barContainerFrame:SetWidth(TRB.Data.settings.hunter.survival.bar.width-(TRB.Data.settings.hunter.survival.bar.border*2))
				barContainerFrame:SetHeight(TRB.Data.settings.hunter.survival.bar.height-(TRB.Data.settings.hunter.survival.bar.border*2))
				barBorderFrame:SetWidth(TRB.Data.settings.hunter.survival.bar.width)
				barBorderFrame:SetHeight(TRB.Data.settings.hunter.survival.bar.height)
				if TRB.Data.settings.hunter.survival.bar.border < 1 then
					barBorderFrame:SetBackdrop({
						edgeFile = TRB.Data.settings.hunter.survival.textures.border,
						tile = true,
						tileSize = 4,
						edgeSize = 1,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Hide()
				else
					barBorderFrame:SetBackdrop({ 
						edgeFile = TRB.Data.settings.hunter.survival.textures.border,
						tile = true,
						tileSize=4,
						edgeSize=TRB.Data.settings.hunter.survival.bar.border,
						insets = {0, 0, 0, 0}
					})
					barBorderFrame:Show()
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.border, true))

				TRB.Functions.SetBarMinMaxValues(TRB.Data.settings.hunter.survival)

				for k, v in pairs(TRB.Data.spells) do
					if TRB.Data.spells[k] ~= nil and TRB.Data.spells[k]["id"] ~= nil and TRB.Data.spells[k]["focus"] ~= nil and TRB.Data.spells[k]["focus"] < 0 and TRB.Data.spells[k]["thresholdId"] ~= nil then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.survival, resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]], resourceFrame, TRB.Data.settings.hunter.survival.thresholdWidth, -TRB.Data.spells[k]["focus"], TRB.Data.character.maxResource)                
						TRB.Frames.resourceFrame.thresholds[TRB.Data.spells[k]["thresholdId"]]:Show()
					end
				end
			end

			local minsliderWidth = math.max(TRB.Data.settings.hunter.survival.bar.border*2, 120)
			local minsliderHeight = math.max(TRB.Data.settings.hunter.survival.bar.border*2, 1)

			local scValues = TRB.Functions.GetSanityCheckValues(TRB.Data.settings.hunter.survival)
			controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
			controls.height.MinLabel:SetText(minsliderHeight)
			controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
			controls.width.MinLabel:SetText(minsliderWidth)
		end)

		title = "Threshold Line Width"
		controls.thresholdWidth = TRB.UiFunctions.BuildSlider(parent, title, 1, 10, TRB.Data.settings.hunter.survival.thresholdWidth, 1, 2,
									sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.thresholdWidth:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.thresholdWidth = value
			if GetSpecialization() == 3 then
				for x = 1, TRB.Functions.TableLength(resourceFrame.thresholds) do
					resourceFrame.thresholds[x]:SetWidth(TRB.Data.settings.hunter.survival.thresholdWidth)
				end
			end
		end)

		yCoord = yCoord - 40

		--NOTE: the order of these checkboxes is reversed!

		controls.checkBoxes.lockPosition = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_dragAndDrop", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockPosition
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Drag & Drop Movement Enabled")
		f.tooltip = "Disable Drag & Drop functionality of the bar to keep it from accidentally being moved.\n\nWhen 'Pin to Personal Resource Display' is checked, this value is ignored and cannot be changed."
		f:SetChecked(TRB.Data.settings.hunter.survival.bar.dragAndDrop)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.bar.dragAndDrop = self:GetChecked()
			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.survival.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.survival.bar.dragAndDrop)
		end)

		if TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay then
			controls.checkBoxes.lockPosition:Disable()
			getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)
		end

		controls.checkBoxes.pinToPRD = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_pinToPRD", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.pinToPRD
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Pin to Personal Resource Display")
		f.tooltip = "Pins the bar to the Blizzard Personal Resource Display. Adjust the Horizontal and Vertical positions above to offset it from PRD. When enabled, Drag & Drop positioning is not allowed. If PRD is not enabled, will behave as if you didn't have this enabled.\n\nNOTE: This will also be the position (relative to the center of the screen, NOT the PRD) that it shows when out of combat/the PRD is not displayed! It is recommended you set 'Bar Display' to 'Only show bar in combat' if you plan to pin it to your PRD."
		f:SetChecked(TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay = self:GetChecked()
			
			if TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay then				
				controls.checkBoxes.lockPosition:Disable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(0.5, 0.5, 0.5)				
			else
				controls.checkBoxes.lockPosition:Enable()
				getglobal(controls.checkBoxes.lockPosition:GetName().."Text"):SetTextColor(1, 1, 1)
			end

			barContainerFrame:SetMovable((not TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.survival.bar.dragAndDrop)
			barContainerFrame:EnableMouse((not TRB.Data.settings.hunter.survival.bar.pinToPersonalResourceDisplay) and TRB.Data.settings.hunter.survival.bar.dragAndDrop)
			TRB.Functions.RepositionBar(TRB.Data.settings.hunter.survival)
		end)



		yCoord = yCoord - 30
		controls.textBarTexturesSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Textures", 0, yCoord)
		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.resourceBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FocusBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.resourceBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Main Bar Texture", xCoord, yCoord)
		controls.dropDown.resourceBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.resourceBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.resourceBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.survival.textures.resourceBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.survival.textures.resourceBar
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
			TRB.Data.settings.hunter.survival.textures.resourceBar = newValue
			TRB.Data.settings.hunter.survival.textures.resourceBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
			if TRB.Data.settings.hunter.survival.textures.textureLock then
				TRB.Data.settings.hunter.survival.textures.castingBar = newValue
				TRB.Data.settings.hunter.survival.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
				TRB.Data.settings.hunter.survival.textures.passiveBar = newValue
				TRB.Data.settings.hunter.survival.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.resourceBar)
				if TRB.Data.settings.hunter.survival.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.castingBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.passiveBar)
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.castingBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_CastBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.castingBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Casting Bar Texture", xCoord2, yCoord)
		controls.dropDown.castingBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.castingBarTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.castingBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.survival.textures.castingBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.survival.textures.castingBar
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
			TRB.Data.settings.hunter.survival.textures.castingBar = newValue
			TRB.Data.settings.hunter.survival.textures.castingBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			if TRB.Data.settings.hunter.survival.textures.textureLock then
				TRB.Data.settings.hunter.survival.textures.resourceBar = newValue
				TRB.Data.settings.hunter.survival.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.survival.textures.passiveBar = newValue
				TRB.Data.settings.hunter.survival.textures.passiveBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.castingBar)
				if TRB.Data.settings.hunter.survival.textures.textureLock then
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.resourceBar)
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.passiveBar)
				end
			end
			CloseDropDownMenus()
		end


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.passiveBarTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_PassiveBarTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.passiveBarTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Bar Texture", xCoord, yCoord)
		controls.dropDown.passiveBarTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.passiveBarTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.passiveBarTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, TRB.Data.settings.hunter.survival.textures.passiveBarName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.survival.textures.passiveBar
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
			TRB.Data.settings.hunter.survival.textures.passiveBar = newValue
			TRB.Data.settings.hunter.survival.textures.passiveBarName = newName
			UIDropDownMenu_SetText(controls.dropDown.passiveBarTexture, newName)
			if TRB.Data.settings.hunter.survival.textures.textureLock then
				TRB.Data.settings.hunter.survival.textures.resourceBar = newValue
				TRB.Data.settings.hunter.survival.textures.resourceBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, newName)
				TRB.Data.settings.hunter.survival.textures.castingBar = newValue
				TRB.Data.settings.hunter.survival.textures.castingBarName = newName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, newName)
			end

			if GetSpecialization() == 3 then
				passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.passiveBar)
				if TRB.Data.settings.hunter.survival.textures.textureLock then
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.castingBar)
					resourceFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.resourceBar)
				end
			end
			CloseDropDownMenus()
		end

		controls.checkBoxes.textureLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB1_TEXTURE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.textureLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same texture for all bars")
		f.tooltip = "This will lock the texture for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.survival.textures.textureLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.textures.textureLock = self:GetChecked()
			if TRB.Data.settings.hunter.survival.textures.textureLock then
				TRB.Data.settings.hunter.survival.textures.passiveBar = TRB.Data.settings.hunter.survival.textures.resourceBar
				TRB.Data.settings.hunter.survival.textures.passiveBarName = TRB.Data.settings.hunter.survival.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.resourceBarTexture, TRB.Data.settings.hunter.survival.textures.passiveBarName)
				TRB.Data.settings.hunter.survival.textures.castingBar = TRB.Data.settings.hunter.survival.textures.resourceBar
				TRB.Data.settings.hunter.survival.textures.castingBarName = TRB.Data.settings.hunter.survival.textures.resourceBarName
				UIDropDownMenu_SetText(controls.dropDown.castingBarTexture, TRB.Data.settings.hunter.survival.textures.castingBarName)

				if GetSpecialization() == 3 then
					passiveFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.passiveBar)
					castingFrame:SetStatusBarTexture(TRB.Data.settings.hunter.survival.textures.castingBar)
				end
			end
		end)


		yCoord = yCoord - 60

		-- Create the dropdown, and configure its appearance
		controls.dropDown.borderTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_BorderTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.borderTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Border Texture", xCoord, yCoord)
		controls.dropDown.borderTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.borderTexture:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.borderTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.borderTexture, TRB.Data.settings.hunter.survival.textures.borderName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.survival.textures.border
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
			TRB.Data.settings.hunter.survival.textures.border = newValue
			TRB.Data.settings.hunter.survival.textures.borderName = newName

			if GetSpecialization() == 3 then
				if TRB.Data.settings.hunter.survival.bar.border < 1 then
					barBorderFrame:SetBackdrop({ })
				else
					barBorderFrame:SetBackdrop({ edgeFile = TRB.Data.settings.hunter.survival.textures.border,
												tile = true,
												tileSize=4,
												edgeSize=TRB.Data.settings.hunter.survival.bar.border,
												insets = {0, 0, 0, 0}
												})
				end
				barBorderFrame:SetBackdropColor(0, 0, 0, 0)
				barBorderFrame:SetBackdropBorderColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.border, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.borderTexture, newName)
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.backgroundTexture = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_BackgroundTexture", parent, "UIDropDownMenuTemplate")
		controls.dropDown.backgroundTexture.label = TRB.UiFunctions.BuildSectionHeader(parent, "Background (Empty Bar) Texture", xCoord2, yCoord)
		controls.dropDown.backgroundTexture.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.backgroundTexture:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.backgroundTexture, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, TRB.Data.settings.hunter.survival.textures.backgroundName)
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
						info.checked = textures[v] == TRB.Data.settings.hunter.survival.textures.background
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
			TRB.Data.settings.hunter.survival.textures.background = newValue
			TRB.Data.settings.hunter.survival.textures.backgroundName = newName

			if GetSpecialization() == 3 then
				barContainerFrame:SetBackdrop({ 
					bgFile = TRB.Data.settings.hunter.survival.textures.background,
					tile = true,
					tileSize = TRB.Data.settings.hunter.survival.bar.width,
					edgeSize = 1,
					insets = {0, 0, 0, 0}
				})
				barContainerFrame:SetBackdropColor (TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.background, true))
			end

			UIDropDownMenu_SetText(controls.dropDown.backgroundTexture, newName)
			CloseDropDownMenus()
		end


		yCoord = yCoord - 70
		controls.barDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions.BuildSlider(parent, title, 0, 1, TRB.Data.settings.hunter.survival.colors.bar.flashAlpha, 0.01, 2,
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
			TRB.Data.settings.hunter.survival.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions.BuildSlider(parent, title, 0, 2, TRB.Data.settings.hunter.survival.colors.bar.flashPeriod, 0.05, 2,
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
			TRB.Data.settings.hunter.survival.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.survival.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.survival.displayBar.alwaysShow = true
			TRB.Data.settings.hunter.survival.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.survival.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 100, hidden otherwise when out of combat."
		f:SetChecked(TRB.Data.settings.hunter.survival.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.survival.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.survival.displayBar.notZeroShow = true
			TRB.Data.settings.hunter.survival.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not TRB.Data.settings.hunter.survival.displayBar.alwaysShow) and (not TRB.Data.settings.hunter.survival.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			TRB.Data.settings.hunter.survival.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.survival.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.survival.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(TRB.Data.settings.hunter.survival.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			TRB.Data.settings.hunter.survival.displayBar.alwaysShow = false
			TRB.Data.settings.hunter.survival.displayBar.notZeroShow = false
			TRB.Data.settings.hunter.survival.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(TRB.Data.settings.hunter.survival.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(TRB.Data.settings.hunter.survival.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions.BuildColorPicker(parent, "Focus", TRB.Data.settings.hunter.survival.colors.bar.base, 300, 25, xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
                local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.base, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
                    controls.colors.base.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.base = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.border = TRB.UiFunctions.BuildColorPicker(parent, "Resource Bar's border", TRB.Data.settings.hunter.survival.colors.bar.border, 225, 25, xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.border, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.border.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.border = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barBorderFrame:SetBackdropBorderColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from Passive Sources", TRB.Data.settings.hunter.survival.colors.bar.passive, 525, 25, xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true)
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
                    TRB.Data.settings.hunter.survival.colors.bar.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.background = TRB.UiFunctions.BuildColorPicker(parent, "Unfilled bar background", TRB.Data.settings.hunter.survival.colors.bar.background, 275, 25, xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.background, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.background.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.background = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    barContainerFrame:SetBackdropColor(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30

		controls.colors.spending = TRB.UiFunctions.BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", TRB.Data.settings.hunter.survival.colors.bar.spending, 275, 25, xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.spending, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.spending.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		--[[
		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions.BuildColorPicker(parent, "Focus gain from hardcasting builder abilities", TRB.Data.settings.hunter.survival.colors.bar.casting, 275, 25, xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.casting, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.casting.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.casting = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                    castingFrame:SetStatusBarColor(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.borderOvercap = TRB.UiFunctions.BuildColorPicker(parent, "Bar border color when your current hardcast builder will overcap Focus", TRB.Data.settings.hunter.survival.colors.bar.borderOvercap, 275, 25, xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.borderOvercap, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.borderOvercap.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.survival.colors.bar.borderOvercap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)
		]]

		controls.colors.coordinatedAssault = TRB.UiFunctions.BuildColorPicker(parent, "Focus while Coordinated Assault is active", TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssault, 275, 25, xCoord2, yCoord)
		f = controls.colors.coordinatedAssault
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssault, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.coordinatedAssault.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssault = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.coordinatedAssaultEnding = TRB.UiFunctions.BuildColorPicker(parent, "Focus when Coordinated Assault is ending", TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssaultEnding, 275, 25, xCoord2, yCoord)
		f = controls.colors.coordinatedAssaultEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssaultEnding, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
					local r, g, b, a
					if color then
						r, g, b, a = unpack(color)
					else
						r, g, b = ColorPickerFrame:GetColorRGB()
						a = OpacitySliderFrame:GetValue()
					end

					controls.colors.eclipse1GCD.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssaultEnding = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 40

		controls.barColorsSection = TRB.UiFunctions.BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		yCoord = yCoord - 25

		controls.colors.thresholdUnder = TRB.UiFunctions.BuildColorPicker(parent, "Under minimum required Focus threshold line", TRB.Data.settings.hunter.survival.colors.threshold.under, 275, 25, xCoord2, yCoord)
		f = controls.colors.thresholdUnder
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.threshold.under, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnder.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.threshold.under = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdOver = TRB.UiFunctions.BuildColorPicker(parent, "Over minimum required Focus threshold line", TRB.Data.settings.hunter.survival.colors.threshold.over, 275, 25, xCoord2, yCoord-30)
		f = controls.colors.thresholdOver
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.threshold.over, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdOver.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.threshold.over = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.thresholdUnusable = TRB.UiFunctions.BuildColorPicker(parent, "Ability is unusable threshold line", TRB.Data.settings.hunter.survival.colors.threshold.unusable, 275, 25, xCoord2, yCoord-60)
		f = controls.colors.thresholdUnusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.threshold.unusable, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.thresholdUnusable.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.threshold.unusable = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(TRB.Data.settings.hunter.survival.bar.thresholdOverlapBorder)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.bar.thresholdOverlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(TRB.Data.settings.hunter.survival)
		end)



		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.carveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_carve", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.carveThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Carve / Butchery (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Carve or Butchery (if talented). If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.carve.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.carve.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chakramsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_chakrams", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chakramsThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chakrams (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Chakrams. Only visible if talented in to Chakrams. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.chakrams.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.chakrams.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.raptorStrikeThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Raptor Strike / Mongoose Bite (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Raptor Strike or Mongoose Bite."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.raptorStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.raptorStrike.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Serpent Sting."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.serpentSting.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.wingClipThresholdShow
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Wing Clip")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Wing Clip."
		f:SetChecked(TRB.Data.settings.hunter.survival.thresholds.wingClip.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.thresholds.wingClip.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "End of Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfCoordinatedAssault = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssault
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Coordinated Assault")
		f.tooltip = "Changes the bar color when Coordinated Assault is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfCoordinatedAssaultModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Coordinated Assault ends."
		if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(false)
			TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode = "gcd"
		end)

		title = "Coordinated Assault GCDs - 0.75sec Floor"
		controls.endOfCoordinatedAssaultGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0.5, 20, TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.gcdsMax, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.endOfCoordinatedAssaultGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfCoordinatedAssaultModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Coordinated Assault ends."
		if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(true)
			TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode = "time"
		end)

		title = "Coordinated Assault Time Remaining (sec)"
		controls.endOfCoordinatedAssaultTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.timeMax, 0.25, 2,
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
			TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above the overcapping maximum Focus as configured below."
		f:SetChecked(TRB.Data.settings.hunter.survival.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions.BuildSlider(parent, title, 0, 100, TRB.Data.settings.hunter.survival.overcapThreshold, 1, 1,
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
			TRB.Data.settings.hunter.survival.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
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

		controls.buttons.exportButton_Hunter_Survival_FontAndText = TRB.UiFunctions.BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Font & Text).", 3, 3, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions.BuildSectionHeader(parent, "Left Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, TRB.Data.settings.hunter.survival.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.survival.displayText.left.fontFace
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
			TRB.Data.settings.hunter.survival.displayText.left.fontFace = newValue
			TRB.Data.settings.hunter.survival.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
				TRB.Data.settings.hunter.survival.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				TRB.Data.settings.hunter.survival.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.left.fontFace, TRB.Data.settings.hunter.survival.displayText.left.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.middle.fontFace, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.right.fontFace, TRB.Data.settings.hunter.survival.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_fFontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions.BuildSectionHeader(parent, "Middle Bar Font Face", xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.survival.displayText.middle.fontFace
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
			TRB.Data.settings.hunter.survival.displayText.middle.fontFace = newValue
			TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
				TRB.Data.settings.hunter.survival.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.survival.displayText.right.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.middle.fontFace, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.left.fontFace, TRB.Data.settings.hunter.survival.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.right.fontFace, TRB.Data.settings.hunter.survival.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions.BuildSectionHeader(parent, "Right Bar Font Face", xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.survival.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == TRB.Data.settings.hunter.survival.displayText.right.fontFace
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
			TRB.Data.settings.hunter.survival.displayText.right.fontFace = newValue
			TRB.Data.settings.hunter.survival.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
				TRB.Data.settings.hunter.survival.displayText.left.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				TRB.Data.settings.hunter.survival.displayText.middle.fontFace = newValue
				TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.right.fontFace, TRB.Data.settings.hunter.survival.displayText.right.fontSize, "OUTLINE")
				if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.left.fontFace, TRB.Data.settings.hunter.survival.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.middle.fontFace, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(TRB.Data.settings.hunter.survival.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.displayText.fontFaceLock = self:GetChecked()
			if TRB.Data.settings.hunter.survival.displayText.fontFaceLock then
				TRB.Data.settings.hunter.survival.displayText.middle.fontFace = TRB.Data.settings.hunter.survival.displayText.left.fontFace
				TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName = TRB.Data.settings.hunter.survival.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, TRB.Data.settings.hunter.survival.displayText.middle.fontFaceName)
				TRB.Data.settings.hunter.survival.displayText.right.fontFace = TRB.Data.settings.hunter.survival.displayText.left.fontFace
				TRB.Data.settings.hunter.survival.displayText.right.fontFaceName = TRB.Data.settings.hunter.survival.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, TRB.Data.settings.hunter.survival.displayText.right.fontFaceName)

				if GetSpecialization() == 3 then
					middleTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.middle.fontFace, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.right.fontFace, TRB.Data.settings.hunter.survival.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.survival.displayText.left.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.left.fontFace, TRB.Data.settings.hunter.survival.displayText.left.fontSize, "OUTLINE")
			if TRB.Data.settings.hunter.survival.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(TRB.Data.settings.hunter.survival.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.displayText.fontSizeLock = self:GetChecked()
			if TRB.Data.settings.hunter.survival.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(TRB.Data.settings.hunter.survival.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(TRB.Data.settings.hunter.survival.displayText.left.fontSize)
			end
		end)

		controls.colors.leftText = TRB.UiFunctions.BuildColorPicker(parent, "Left Text", TRB.Data.settings.hunter.survival.colors.text.left,
														250, 25, xCoord2, yCoord-30)
		f = controls.colors.leftText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.left, true)
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
                    TRB.Data.settings.hunter.survival.colors.text.left = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.middleText = TRB.UiFunctions.BuildColorPicker(parent, "Middle Text", TRB.Data.settings.hunter.survival.colors.text.middle,
														225, 25, xCoord2, yCoord-70)
		f = controls.colors.middleText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.middle, true)
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
                    TRB.Data.settings.hunter.survival.colors.text.middle = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.rightText = TRB.UiFunctions.BuildColorPicker(parent, "Right Text", TRB.Data.settings.hunter.survival.colors.text.right,
														225, 25, xCoord2, yCoord-110)
		f = controls.colors.rightText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.right, true)
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
                    TRB.Data.settings.hunter.survival.colors.text.right = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.displayText.middle.fontSize = value

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.middle.fontFace, TRB.Data.settings.hunter.survival.displayText.middle.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.survival.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions.BuildSlider(parent, title, 6, 72, TRB.Data.settings.hunter.survival.displayText.right.fontSize, 1, 0,
									sliderWidth, sliderHeight, xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.displayText.right.fontSize = value

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(TRB.Data.settings.hunter.survival.displayText.right.fontFace, TRB.Data.settings.hunter.survival.displayText.right.fontSize, "OUTLINE")
			end

			if TRB.Data.settings.hunter.survival.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.currentFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Current Focus", TRB.Data.settings.hunter.survival.colors.text.current, 300, 25, xCoord, yCoord)
		f = controls.colors.currentFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.current, true)
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
        
                    controls.colors.currentFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.text.current = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.spendingFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", TRB.Data.settings.hunter.survival.colors.text.spending, 275, 25, xCoord2, yCoord)
		f = controls.colors.spendingFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.spending, true)
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
        
                    controls.colors.spendingFocusText.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.text.spending = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.passiveFocusText = TRB.UiFunctions.BuildColorPicker(parent, "Passive Focus", TRB.Data.settings.hunter.survival.colors.text.passive, 300, 25, xCoord, yCoord)
		f = controls.colors.passiveFocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.passive, true)
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

					controls.colors.passiveFocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.survival.colors.text.passive = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30
		controls.colors.thresholdfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", TRB.Data.settings.hunter.survival.colors.text.overThreshold, 300, 25, xCoord, yCoord)
		f = controls.colors.thresholdfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.overThreshold, true)
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

					controls.colors.thresholdfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.survival.colors.text.overThreshold = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		controls.colors.overcapfocusText = TRB.UiFunctions.BuildColorPicker(parent, "Current Focus is above overcap threshold", TRB.Data.settings.hunter.survival.colors.text.overcap, 300, 25, xCoord2, yCoord)
		f = controls.colors.overcapfocusText
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.overcap, true)
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

					controls.colors.overcapfocusText.Texture:SetColorTexture(r, g, b, 1-a)
					TRB.Data.settings.hunter.survival.colors.text.overcap = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
				end)
			end
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", xCoord+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(TRB.Data.settings.hunter.survival.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", xCoord2+xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current focus or a hardcast spell will result in overcapping maximum Focus."
		f:SetChecked(TRB.Data.settings.hunter.survival.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions.BuildSectionHeader(parent, "DoT Count Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up colors counters ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(TRB.Data.settings.hunter.survival.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dotUp = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target", TRB.Data.settings.hunter.survival.colors.text.dots.up, 550, 25, xCoord, yCoord-30)
		f = controls.colors.dotUp
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.dots.up, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotUp.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.text.dots.up = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotPandemic = TRB.UiFunctions.BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", TRB.Data.settings.hunter.survival.colors.text.dots.pandemic, 550, 25, xCoord, yCoord-60)
		f = controls.colors.dotPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.dots.pandemic, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotPandemic.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.text.dots.pandemic = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)

		controls.colors.dotDown = TRB.UiFunctions.BuildColorPicker(parent, "DoT is not active oncurrent target", TRB.Data.settings.hunter.survival.colors.text.dots.down, 550, 25, xCoord, yCoord-90)
		f = controls.colors.dotDown
		f:SetScript("OnMouseDown", function(self, button, ...)
			if button == "LeftButton" then
				local r, g, b, a = TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.text.dots.down, true)
				TRB.UiFunctions.ShowColorPicker(r, g, b, 1-a, function(color)
                    local r, g, b, a
                    if color then
                        r, g, b, a = unpack(color)
                    else
                        r, g, b = ColorPickerFrame:GetColorRGB()
                        a = OpacitySliderFrame:GetValue()
                    end
        
                    controls.colors.dotDown.Texture:SetColorTexture(r, g, b, 1-a)
                    TRB.Data.settings.hunter.survival.colors.text.dots.down = TRB.Functions.ConvertColorDecimalToHex(r, g, b, 1-a)
                end)
			end
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.survival.hastePrecision, 1, 0,
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
			TRB.Data.settings.hunter.survival.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
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

		controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.UiFunctions.BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Audio & Tracking).", 3, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(TRB.Data.settings.hunter.survival.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.audio.killShot.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.survival.audio.killShot.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.survival.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, TRB.Data.settings.hunter.survival.audio.killShot.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.survival.audio.killShot.sound
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
			TRB.Data.settings.hunter.survival.audio.killShot.sound = newValue
			TRB.Data.settings.hunter.survival.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.survival.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(TRB.Data.settings.hunter.survival.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.audio.overcap.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.survival.audio.overcap.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.survival.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, TRB.Data.settings.hunter.survival.audio.overcap.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.survival.audio.overcap.sound
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
			TRB.Data.settings.hunter.survival.audio.overcap.sound = newValue
			TRB.Data.settings.hunter.survival.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.survival.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if Venthyr)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(TRB.Data.settings.hunter.survival.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.audio.flayersMark.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.survival.audio.flayersMark.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.survival.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, TRB.Data.settings.hunter.survival.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.survival.audio.flayersMark.sound
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
			TRB.Data.settings.hunter.survival.audio.flayersMark.sound = newValue
			TRB.Data.settings.hunter.survival.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.survival.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.enabled then
				PlaySoundFile(TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.sound
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
			TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.sound = newValue
			TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
			PlaySoundFile(TRB.Data.settings.hunter.survival.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions.BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(TRB.Data.settings.hunter.survival.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.hunter.survival.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation from GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD."
		if TRB.Data.settings.hunter.survival.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			TRB.Data.settings.hunter.survival.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions.BuildSlider(parent, title, 0, 15, TRB.Data.settings.hunter.survival.generation.gcds, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if TRB.Data.settings.hunter.survival.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			TRB.Data.settings.hunter.survival.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions.BuildSlider(parent, title, 0, 10, TRB.Data.settings.hunter.survival.generation.time, 0.25, 2,
										sliderWidth, sliderHeight, xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			local min, max = self:GetMinMaxValues()
			if value > max then
				value = max
			elseif value < min then
				value = min
			end

			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			TRB.Data.settings.hunter.survival.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end
    
	local function SurvivalConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
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
		controls.buttons.exportButton_Hunter_Survival_BarText = TRB.UiFunctions.BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Text).", 3, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Left Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.survival.displayText.left.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.survival.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Middle Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.survival.displayText.middle.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.survival.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions.BuildLabel(parent, "Right Text", xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions.BuildTextBox(parent, TRB.Data.settings.hunter.survival.displayText.right.text,
														500, 440, 24, xCoord+100, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			TRB.Data.settings.hunter.survival.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
		end)

		yCoord = yCoord - 30
		TRB.Options.CreateBarTextInstructions(cache, parent, xCoord, yCoord)
	end

	local function SurvivalConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.survival or {}
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

		interfaceSettingsFrame.survivalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Survival", UIParent)
		interfaceSettingsFrame.survivalDisplayPanel.name = "Survival Hunter"
		interfaceSettingsFrame.survivalDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.survivalDisplayPanel)

		parent = interfaceSettingsFrame.survivalDisplayPanel

		controls.textSection = TRB.UiFunctions.BuildSectionHeader(parent, "Survival Hunter", xCoord+xPadding, yCoord-5)

		controls.buttons.importButton = TRB.UiFunctions.BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_Survival_All = TRB.UiFunctions.BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (All).", 3, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions.CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions.CreateTabFrameContainer("TwintopResourceBar_Hunter_Survival_LayoutPanel" .. i, parent)
			tabsheets[i]:Hide()
			tabsheets[i]:SetPoint("TOPLEFT", 10, yCoord)
		end

		tabsheets[1]:Show()
		parent.tabs = tabs
		parent.tabsheets = tabsheets
		parent.lastTab = tabsheets[1]
		parent.lastTabId = 1
		parent.tabsheets[1].selected = true
		parent.tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)

		SurvivalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		SurvivalConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		SurvivalConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		SurvivalConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		SurvivalConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	local function ConstructOptionsPanel(specCache)
		TRB.Options.ConstructOptionsPanel()
		BeastMasteryConstructOptionsPanel(specCache.beastMastery)
		MarksmanshipConstructOptionsPanel(specCache.marksmanship)
		SurvivalConstructOptionsPanel(specCache.survival)
	end
	TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel
end