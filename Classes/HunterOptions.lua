local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
	local oUi = TRB.Data.constants.optionsUi
	
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
			overcapThreshold=120,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
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
				},
				wailingArrow = {
					enabled = true, -- 10
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
					unusable="FFFF0000",
					special="FFFF00FF"
				}
			},
			displayText = {},
			audio = {
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
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
			overcapThreshold=100,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
				aimedShot = {
					enabled = true, -- 1
				},
				arcaneShot = {
					enabled = true, -- 2
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
				},
				wailingArrow = {
					enabled = true, -- 12
				},
				chimaeraShot = {
					enabled = true -- 13
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
			steadyFocus = {
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
					borderSteadyFocus="FFFFFF00",
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
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn",
					mode="gcd",
					gcds=1,
					time=1.5
				},
				lockAndLoad={
					name = "Lock and Load Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				overcap={
					name = "Overcap",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				secretsOfTheUnblinkingVigil={
					name = "Secrets of the Unblinking Vigil Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
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
			overcapThreshold=100,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "TOP",
					relativeToName = "Above",
					enabled=true,
					xPos=0,
					yPos=-12,
					width=24,
					height=24
				},
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
					enabled = true, -- 6
				},
				butchery = {
					enabled = true, -- 7
				},
				raptorStrike = {
					enabled = true, -- 8
				},
				mongooseBite = {
					enabled = true, -- 9
				},
				serpentSting = {
					enabled = false, -- 10
				},
				aMurderOfCrows = {
					enabled = true, -- 11
				},
				chakrams = {
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
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				killShot={
					name = "Kill Shot Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				flayersMark={
					name = "Flayer's Mark Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
				nesingwarysTrappingApparatus={
					name = "Nesingwary's Trapping Apparatus Proc",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
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

				local spec = TRB.Data.settings.hunter.beastMastery

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = BeastMasteryResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BeastMasteryLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BeastMasteryLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Beast Mastery Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BeastMasteryLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_BeastMastery_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.beastMastery

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Display).", 3, 1, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 3, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 3, 1, yCoord, false)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 50

		title = "Beastial Wrath Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashAlpha = value
		end)

		title = "Beastial Wrath Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions:BuildSlider(parent, title, 0.05, 2, spec.colors.bar.flashPeriod, 0.05, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(spec.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = true
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 120")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 120, hidden otherwise when out of combat."
		f:SetChecked(spec.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = true
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(spec.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Beastial Wrath is usable")
		f.tooltip = "This will flash the bar when Beastial Wrath can be cast."
		f:SetChecked(spec.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.esThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Border color when Beastial Wrath is usable")
		f.tooltip = "This will change the bar's border color (as configured below) when Beastial Wrath is usable."
		f:SetChecked(spec.colors.bar.beastialWrathEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.beastialWrathEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Focus", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Focus gain from Passive Sources", spec.colors.bar.passive, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)

		controls.colors.borderBeastialWrath = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when you can use Beastial Wrath", spec.colors.bar.borderBeastialWrath, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderBeastialWrath
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderBeastialWrath")
		end)

		yCoord = yCoord - 30
		controls.colors.frenzyUse = TRB.UiFunctions:BuildColorPicker(parent, "Focus when Barbed Shot should be used", spec.colors.bar.frenzyUse, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.frenzyUse
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "frenzyUse")
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.colors.frenzyHold = TRB.UiFunctions:BuildColorPicker(parent, "Focus when Barbed Shot charges should be held", spec.colors.bar.frenzyHold, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.frenzyHold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "frenzyHold")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Focus threshold line", spec.colors.threshold.under, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Focus threshold line", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.UiFunctions:BuildColorPicker(parent, "(T28) Cobra Shot's damage is buffed", spec.colors.threshold.special, 275, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot."
		f:SetChecked(spec.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.barrageThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Barrage (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Barrage. Only visible if talented in to Barrage. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.barrage.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.barrage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.cobraShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_cobraShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cobraShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Cobra Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Cobra Shot."
		f:SetChecked(spec.thresholds.cobraShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cobraShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killCommandThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killCommand", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killCommandThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Command")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Command."
		f:SetChecked(spec.thresholds.killCommand.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.killCommand.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.multiShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Multi-Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Multi-Shot."
		f:SetChecked(spec.thresholds.multiShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.multiShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(spec.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(spec.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.wailingArrowThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Wailing Arrow (if Rae'shalare, Death's Whisper equipped")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Wailing Arrow. Only visible when Rae'shalare, Death's Whisper is equipped. If on cooldown will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.wailingArrow.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.wailingArrow.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", oUi.xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, oUi.dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, spec.thresholds.icons.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above"] = "TOP"
            relativeTo["Middle"] = "CENTER"
            relativeTo["Below"] = "BOTTOM"
            local relativeToList = {
                "Above",
                "Middle",
                "Below"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == spec.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            spec.thresholds.icons.relativeTo = newValue
            spec.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end
		
		--NOTE: the order of these checkboxes is reversed!
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for any abilities currently on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(spec.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.enabled = self:GetChecked()
			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)
			
			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.xPos = value

			if GetSpecialization() == 1 then
				TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.border = value

			local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 1 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above the overcapping maximum Focus as configured below."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 120, spec.overcapThreshold, 1, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.beastMastery

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_BeastMastery_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Font & Text).", 3, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, spec.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.left.fontFace
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
			spec.displayText.left.fontFace = newValue
			spec.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", oUi.xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.middle.fontFace
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
			spec.displayText.middle.fontFace = newValue
			spec.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.right.fontFace
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
			spec.displayText.right.fontFace = newValue
			spec.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(spec.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontFaceLock = self:GetChecked()
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = spec.displayText.left.fontFace
				spec.displayText.middle.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
				spec.displayText.right.fontFace = spec.displayText.left.fontFace
				spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)

				if GetSpecialization() == 1 then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.left.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.left.fontSize = value

			if GetSpecialization() == 1 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(spec.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontSizeLock = self:GetChecked()
			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(spec.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(spec.displayText.left.fontSize)
			end
		end)

		controls.colors.text = {}

		controls.colors.text.left = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", spec.colors.text.left,
														250, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.text.left
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "left")
		end)

		controls.colors.text.middle = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", spec.colors.text.middle,
														225, 25, oUi.xCoord2, yCoord-70)
		f = controls.colors.text.middle
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "middle")
		end)

		controls.colors.text.right = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", spec.colors.text.right,
														225, 25, oUi.xCoord2, yCoord-110)
		f = controls.colors.text.right
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "right")
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.middle.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.middle.fontSize = value

			if GetSpecialization() == 1 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.right.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.right.fontSize = value

			if GetSpecialization() == 1 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)
		
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Focus", spec.colors.text.passive, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current focus is above the overcapping maximum Focus value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end

	local function BeastMasteryConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.beastMastery

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Audio & Tracking).", 3, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(spec.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.killShot.enabled = self:GetChecked()

			if spec.audio.killShot.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
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
						info.checked = sounds[v] == spec.audio.killShot.sound
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
			spec.audio.killShot.sound = newValue
			spec.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
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
						info.checked = sounds[v] == spec.audio.overcap.sound
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
			spec.audio.overcap.sound = newValue
			spec.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if |cFFFF4040Venthyr|r)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(spec.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.flayersMark.enabled = self:GetChecked()

			if spec.audio.flayersMark.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, spec.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == spec.audio.flayersMark.sound
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
			spec.audio.flayersMark.sound = newValue
			spec.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(spec.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if spec.audio.nesingwarysTrappingApparatus.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_BeastMastery_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, spec.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == spec.audio.nesingwarysTrappingApparatus.sound
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
			spec.audio.nesingwarysTrappingApparatus.sound = newValue
			spec.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD length."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.beastMastery = controls
	end
    
	local function BeastMasteryConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.beastMastery

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.beastMastery
		local yCoord = 5
		local f = nil
		local namePrefix = "Hunter_BeastMastery"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Hunter_BeastMastery_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (Bar Text).", 3, 1, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function BeastMasteryConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.beastMastery or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.beastMasteryDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_BeastMastery", UIParent)
		interfaceSettingsFrame.beastMasteryDisplayPanel.name = "Beast Mastery Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.beastMasteryDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.beastMasteryDisplayPanel)

		parent = interfaceSettingsFrame.beastMasteryDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Beast Mastery Hunter", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.beastMasteryHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_BeastMastery_beastMasteryHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.beastMasteryHunterEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Beast Mastery Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.hunter.beastMastery)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.hunter.beastMastery = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.beastMasteryHunterEnabled, TRB.Data.settings.core.enabled.hunter.beastMastery, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.beastMasteryHunterEnabled, TRB.Data.settings.core.enabled.hunter.beastMastery, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_BeastMastery_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_BeastMastery_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Beast Mastery Hunter (All).", 3, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_BeastMastery_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Hunter_BeastMastery_LayoutPanel" .. i, parent)
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

				local spec = TRB.Data.settings.hunter.marksmanship

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = MarksmanshipResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MarksmanshipLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MarksmanshipLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Marksmanship Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MarksmanshipLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}]]

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Marksmanship_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.marksmanship

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Display).", 3, 2, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 3, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 3, 2, yCoord, false)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions:BuildSlider(parent, title, 0, 2, spec.colors.bar.flashPeriod, 0.05, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(spec.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = true
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 100, hidden otherwise when out of combat."
		f:SetChecked(spec.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = true
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(spec.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Focus", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Focus gain from hardcasting builder abilities", spec.colors.bar.casting, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 2)
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when your current hardcast builder will overcap Focus", spec.colors.bar.borderOvercap, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)

		yCoord = yCoord - 30
		controls.colors.spending = TRB.UiFunctions:BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", spec.colors.bar.spending, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)

		controls.colors.borderSteadyFocus = TRB.UiFunctions:BuildColorPicker(parent, "Border when Steady Focus is expiring or not up (per settings)", spec.colors.bar.borderSteadyFocus, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderSteadyFocus
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderSteadyFocus")
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Focus gain from Passive Sources", spec.colors.bar.passive, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)

		controls.colors.trueshot = TRB.UiFunctions:BuildColorPicker(parent, "Focus while Trueshot is active", spec.colors.bar.trueshot, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.trueshot
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "trueshot")
		end)

		yCoord = yCoord - 30

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		controls.colors.trueshotEnding = TRB.UiFunctions:BuildColorPicker(parent, "Focus when Trueshot is ending", spec.colors.bar.trueshotEnding, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.trueshotEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "trueshotEnding")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Focus threshold line", spec.colors.threshold.under, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Focus threshold line", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.aimedShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aimedShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Aimed Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Aimed Shot. If there are 0 charges available, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.aimedShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot/Chimera Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot or Chimera Shot."
		f:SetChecked(spec.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.arcaneShot.enabled = self:GetChecked()
			spec.thresholds.chimaeraShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.barrageThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_barrage", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.barrageThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Barrage (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Barrage. Only visible if talented in to Barrage. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.barrage.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.barrage.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.burstingShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_burstingShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.burstingShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Bursting Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Bursting Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.burstingShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.burstingShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.explosiveShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_explosiveShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.explosiveShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Explosive Shot (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Explosive Shot. Only visible if talented in to Explosive Shot. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.explosiveShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.explosiveShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.multiShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_multiShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.multiShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Multi-Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Multi-Shot."
		f:SetChecked(spec.thresholds.multiShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.multiShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(spec.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(spec.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Serpent Sting. Only visible if talented in to Serpent Sting."
		f:SetChecked(spec.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.serpentSting.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.wailingArrowThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_Threshold_Option_wailingArrow", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.wailingArrowThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Wailing Arrow (if Rae'shalare, Death's Whisper equipped")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Wailing Arrow. Only visible when Rae'shalare, Death's Whisper is equipped. If on cooldown will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.wailingArrow.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.wailingArrow.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 30

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", oUi.xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, oUi.dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, spec.thresholds.icons.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above"] = "TOP"
            relativeTo["Middle"] = "CENTER"
            relativeTo["Below"] = "BOTTOM"
            local relativeToList = {
                "Above",
                "Middle",
                "Below"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == spec.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            spec.thresholds.icons.relativeTo = newValue
            spec.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(spec)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end
		
		--NOTE: the order of these checkboxes is reversed!
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for any abilities currently on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(spec.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.enabled = self:GetChecked()
			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)
			
			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.xPos = value

			if GetSpecialization() == 2 then
				TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.border = value

			local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 2 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Trueshot Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfTrueshot = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfTrueshot
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Trueshot")
		f.tooltip = "Changes the bar color when Trueshot is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfTrueshot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfTrueshot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfTrueshotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Trueshot ends."
		if spec.endOfTrueshot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(false)
			spec.endOfTrueshot.mode = "gcd"
		end)

		title = "Trueshot GCDs - 0.75sec Floor"
		controls.endOfTrueshotGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 20, spec.endOfTrueshot.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfTrueshotGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfTrueshot.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfTrueshotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfTrueshotModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Trueshot ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Trueshot ends."
		if spec.endOfTrueshot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfTrueshotModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfTrueshotModeTime:SetChecked(true)
			spec.endOfTrueshot.mode = "time"
		end)

		title = "Trueshot Time Remaining (sec)"
		controls.endOfTrueshotTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.endOfTrueshot.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfTrueshotTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfTrueshot.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Steady Focus Expiration Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.steadyFocus = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.steadyFocus
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar border when your Steady Focus buff is close to expiring or not up (if talented)")
		f.tooltip = "Changes the bar border color when your Steady Focus buff is not up or is expiring in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.steadyFocus.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.steadyFocus.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.steadyFocusModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.steadyFocusModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs left on Steady Focus buff")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar border color based on how many GCDs remain until Steady Focus will end."
		if spec.steadyFocus.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.steadyFocusModeGCDs:SetChecked(true)
			controls.checkBoxes.steadyFocusModeTime:SetChecked(false)
			spec.steadyFocus.mode = "gcd"
		end)

		title = "Steady Focus GCDs - 0.75sec Floor"
		controls.steadyFocusGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 30, spec.steadyFocus.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.steadyFocusGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.steadyFocus.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.steadyFocusModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_steadyFocus_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.steadyFocusModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time left on Steady Focus buff")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar border color based on how many seconds remain until Steady Focus will end."
		if spec.steadyFocus.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.steadyFocusModeGCDs:SetChecked(false)
			controls.checkBoxes.steadyFocusModeTime:SetChecked(true)
			spec.steadyFocus.mode = "time"
		end)

		title = "Steady Focus Time Remaining (sec)"
		controls.steadyFocusTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.steadyFocus.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.steadyFocusTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.steadyFocus.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above or a hardcast spell will result in overcapping maximum Focus as configured below."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 100, spec.overcapThreshold, 1, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.marksmanship

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_Marksmanship_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Font & Text).", 3, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, spec.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.left.fontFace
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
			spec.displayText.left.fontFace = newValue
			spec.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", oUi.xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.middle.fontFace
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
			spec.displayText.middle.fontFace = newValue
			spec.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.right.fontFace
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
			spec.displayText.right.fontFace = newValue
			spec.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(spec.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontFaceLock = self:GetChecked()
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = spec.displayText.left.fontFace
				spec.displayText.middle.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
				spec.displayText.right.fontFace = spec.displayText.left.fontFace
				spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)

				if GetSpecialization() == 2 then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.left.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.left.fontSize = value

			if GetSpecialization() == 2 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(spec.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontSizeLock = self:GetChecked()
			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(spec.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(spec.displayText.left.fontSize)
			end
		end)

		controls.colors.text = {}

		controls.colors.text.left = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", spec.colors.text.left,
														250, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.text.left
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "left")
		end)

		controls.colors.text.middle = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", spec.colors.text.middle,
														225, 25, oUi.xCoord2, yCoord-70)
		f = controls.colors.text.middle
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "middle")
		end)

		controls.colors.text.right = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", spec.colors.text.right,
														225, 25, oUi.xCoord2, yCoord-110)
		f = controls.colors.text.right
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "right")
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.middle.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.middle.fontSize = value

			if GetSpecialization() == 2 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.right.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.right.fontSize = value

			if GetSpecialization() == 2 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.UiFunctions:BuildColorPicker(parent, "Focus gain from hardcasting builder abilities", spec.colors.text.casting, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Focus", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		controls.colors.text.spending = TRB.UiFunctions:BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", spec.colors.text.spending, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current hardcast spell will result in overcapping maximum Focus."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.UiFunctions:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end

	local function MarksmanshipConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.marksmanship

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Audio & Tracking).", 3, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.aimedShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_aimedShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aimedShotAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Aimed Shot will cap charges")
		f.tooltip = "Play an audio cue when Aimed Shot will cap charges. The timeframe is the current cast time of Aimed shot plus either GCDs or Time as configured below."
		f:SetChecked(spec.audio.aimedShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.aimedShot.enabled = self:GetChecked()

			if spec.audio.aimedShot.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.aimedShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_aimedShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.aimedShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.aimedShotAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, spec.audio.aimedShot.soundName)
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
						info.checked = sounds[v] == spec.audio.aimedShot.sound
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
			spec.audio.aimedShot.sound = newValue
			spec.audio.aimedShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.aimedShotAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		
		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of GCDs before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.audio.aimedShot.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(true)
			controls.checkBoxes.aimedShotModeTime:SetChecked(false)
			spec.audio.aimedShot.mode = "gcd"
		end)

		title = "GCDs - 0.75sec Floor"
		controls.aimedShotGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 6, spec.audio.aimedShot.gcds, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.aimedShotGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.audio.aimedShot.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.aimedShotModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_AS_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.aimedShotModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Number of seconds before capping")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		if spec.audio.aimedShot.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.aimedShotModeGCDs:SetChecked(false)
			controls.checkBoxes.aimedShotModeTime:SetChecked(true)
			spec.audio.aimedShot.mode = "time"
		end)

		title = "Time (sec)"
		controls.aimedShotTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 12, spec.audio.aimedShot.time, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.aimedShotTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.audio.aimedShot.time = value
		end)



		yCoord = yCoord - 50
		controls.checkBoxes.lockAndLoadAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.lockAndLoadAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Lock and Load proc (if talented)")
		f.tooltip = "Play an audio cue when a Lock and Load proc occurs."
		f:SetChecked(spec.audio.lockAndLoad.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.lockAndLoad.enabled = self:GetChecked()

			if spec.audio.lockAndLoad.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.lockAndLoadAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_lockAndLoad_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.lockAndLoadAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.lockAndLoadAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, spec.audio.lockAndLoad.soundName)
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
						info.checked = sounds[v] == spec.audio.lockAndLoad.sound
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
			spec.audio.lockAndLoad.sound = newValue
			spec.audio.lockAndLoad.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.lockAndLoadAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(spec.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.killShot.enabled = self:GetChecked()

			if spec.audio.killShot.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
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
						info.checked = sounds[v] == spec.audio.killShot.sound
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
			spec.audio.killShot.sound = newValue
			spec.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
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
						info.checked = sounds[v] == spec.audio.overcap.sound
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
			spec.audio.overcap.sound = newValue
			spec.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if |cFFFF4040Venthyr|r)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(spec.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.flayersMark.enabled = self:GetChecked()

			if spec.audio.flayersMark.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, spec.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == spec.audio.flayersMark.sound
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
			spec.audio.flayersMark.sound = newValue
			spec.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(spec.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if spec.audio.nesingwarysTrappingApparatus.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, spec.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == spec.audio.nesingwarysTrappingApparatus.sound
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
			spec.audio.nesingwarysTrappingApparatus.sound = newValue
			spec.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.secretsOfTheUnblinkingVigilAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigil_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.secretsOfTheUnblinkingVigilAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Secrets of the Unblinking Vigil proc")
		f.tooltip = "Play an audio cue when you get a Secrets of the Unblinking Vigil proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(spec.audio.secretsOfTheUnblinkingVigil.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.secretsOfTheUnblinkingVigil.enabled = self:GetChecked()

			if spec.audio.secretsOfTheUnblinkingVigil.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.secretsOfTheUnblinkingVigilAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Marksmanship_secretsOfTheUnblinkingVigilAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.secretsOfTheUnblinkingVigilAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.secretsOfTheUnblinkingVigilAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, spec.audio.secretsOfTheUnblinkingVigil.soundName)
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
						info.checked = sounds[v] == spec.audio.secretsOfTheUnblinkingVigil.sound
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
			spec.audio.secretsOfTheUnblinkingVigil.sound = newValue
			spec.audio.secretsOfTheUnblinkingVigil.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.secretsOfTheUnblinkingVigilAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.marksmanship = controls
	end
    
	local function MarksmanshipConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.marksmanship

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.marksmanship
		local yCoord = 5
		local f = nil
		local namePrefix = "Hunter_Marksmanship"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Hunter_Marksmanship_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (Bar Text).", 3, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)


		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function MarksmanshipConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.marksmanship or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.marksmanshipDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Marksmanship", UIParent)
		interfaceSettingsFrame.marksmanshipDisplayPanel.name = "Marksmanship Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.marksmanshipDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.marksmanshipDisplayPanel)

		parent = interfaceSettingsFrame.marksmanshipDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Marksmanship Hunter", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.marksmanshipHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_marksmanshipHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.marksmanshipHunterEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Marksmanship Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.hunter.marksmanship)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.hunter.marksmanship = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.marksmanshipHunterEnabled, TRB.Data.settings.core.enabled.hunter.marksmanship, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.marksmanshipHunterEnabled, TRB.Data.settings.core.enabled.hunter.marksmanship, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_Marksmanship_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_Marksmanship_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Marksmanship Hunter (All).", 3, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Marksmanship_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Hunter_Marksmanship_LayoutPanel" .. i, parent)
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

				local spec = TRB.Data.settings.hunter.survival

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.survival
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = SurvivalResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = SurvivalLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Survival Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = SurvivalLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Hunter_Survival_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.survival

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Hunter_Survival_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Display).", 3, 3, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 3, 3, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 3, 3, yCoord, false)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		--[[yCoord = yCoord - 50

		title = "Earth Shock/EQ Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashAlpha = value
		end)

		title = "Earth Shock/EQ Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions:BuildSlider(parent, title, 0, 2, spec.colors.bar.flashPeriod, 0.05, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashPeriod = value
		end)]]

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show Resource Bar")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar always visible on your UI, even when out of combat."
		f:SetChecked(spec.displayBar.alwaysShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(true)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = true
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Focus < 100")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Focus < 100, hidden otherwise when out of combat."
		f:SetChecked(spec.displayBar.notZeroShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(true)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = true
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show Resource Bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow))
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(true)
			controls.checkBoxes.neverShow:SetChecked(false)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = false
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show Resource Bar (run in background)")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar never display but still run in the background to update the global variable."
		f:SetChecked(spec.displayBar.neverShow)
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.alwaysShow:SetChecked(false)
			controls.checkBoxes.notZeroShow:SetChecked(false)
			controls.checkBoxes.combatShow:SetChecked(false)
			controls.checkBoxes.neverShow:SetChecked(true)
			spec.displayBar.alwaysShow = false
			spec.displayBar.notZeroShow = false
			spec.displayBar.neverShow = true
			TRB.Functions.HideResourceBar()
		end)

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 60

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Focus", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Focus gain from Passive Sources", spec.colors.bar.passive, 525, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 30

		controls.colors.spending = TRB.UiFunctions:BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", spec.colors.bar.spending, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)

		controls.colors.coordinatedAssault = TRB.UiFunctions:BuildColorPicker(parent, "Focus while Coordinated Assault is active", spec.colors.bar.coordinatedAssault, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.coordinatedAssault
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "coordinatedAssault")
		end)

		yCoord = yCoord - 30
		controls.colors.coordinatedAssaultEnding = TRB.UiFunctions:BuildColorPicker(parent, "Focus when Coordinated Assault is ending", spec.colors.bar.coordinatedAssaultEnding, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.coordinatedAssaultEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "coordinatedAssaultEnding")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Focus threshold line", spec.colors.threshold.under, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Focus threshold line", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)



		controls.checkBoxes.arcaneShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_arcaneShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.arcaneShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Arcane Shot")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Arcane Shot."
		f:SetChecked(spec.thresholds.arcaneShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.arcaneShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.aMurderOfCrowsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_aMurderOfCrows", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.aMurderOfCrowsThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("A Murder of Crows (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use A Murder of Crows. Only visible if talented in to A Murder of Crows. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.aMurderOfCrows.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.aMurderOfCrows.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.carveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_carve", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.carveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Carve / Butchery (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Carve or Butchery (if talented). If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.carve.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.carve.enabled = self:GetChecked()
			spec.thresholds.butchery.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chakramsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_chakrams", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chakramsThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chakrams (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Chakrams. Only visible if talented in to Chakrams. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.chakrams.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chakrams.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.killShotThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_killShot", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Kill Shot (if usable)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Kill Shot. Only visible when the current target is in Kill Shot health range or Flayer's Mark (Venthyr) buff is active. If on cooldown or has 0 charges available, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.killShot.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.raptorStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_raptorStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.raptorStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Raptor Strike / Mongoose Bite (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Raptor Strike or Mongoose Bite."
		f:SetChecked(spec.thresholds.raptorStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.raptorStrike.enabled = self:GetChecked()
			spec.thresholds.mongooseBite.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.revivePetThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_revivePet", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.revivePetThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Revive Pet")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Revive Pet."
		f:SetChecked(spec.thresholds.revivePet.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.revivePet.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.scareBeastThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_scareBeast", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.scareBeastThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Scare Beast")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Scare Beast."
		f:SetChecked(spec.thresholds.scareBeast.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.scareBeast.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.serpentStingThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_serpentSting", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.serpentStingThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Serpent Sting")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Serpent Sting."
		f:SetChecked(spec.thresholds.serpentSting.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.serpentSting.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.wingClipThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_Threshold_Option_wingClip", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.wingClipThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Wing Clip")
		f.tooltip = "This will show the vertical line on the bar denoting how much Focus is required to use Wing Clip."
		f:SetChecked(spec.thresholds.wingClip.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.wingClip.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
        controls.dropDown.thresholdIconRelativeTo.label = TRB.UiFunctions:BuildSectionHeader(parent, "Relative Position of Threshold Line Icons", oUi.xCoord, yCoord)
        controls.dropDown.thresholdIconRelativeTo.label.font:SetFontObject(GameFontNormal)
        controls.dropDown.thresholdIconRelativeTo:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
        UIDropDownMenu_SetWidth(controls.dropDown.thresholdIconRelativeTo, oUi.dropdownWidth)
        UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, spec.thresholds.icons.relativeToName)
        UIDropDownMenu_JustifyText(controls.dropDown.thresholdIconRelativeTo, "LEFT")

        -- Create and bind the initialization function to the dropdown menu
        UIDropDownMenu_Initialize(controls.dropDown.thresholdIconRelativeTo, function(self, level, menuList)
            local entries = 25
            local info = UIDropDownMenu_CreateInfo()
            local relativeTo = {}
            relativeTo["Above"] = "TOP"
            relativeTo["Middle"] = "CENTER"
            relativeTo["Below"] = "BOTTOM"
            local relativeToList = {
                "Above",
                "Middle",
                "Below"
            }

            for k, v in pairs(relativeToList) do
                info.text = v
                info.value = relativeTo[v]
                info.checked = relativeTo[v] == spec.thresholds.icons.relativeTo
                info.func = self.SetValue
                info.arg1 = relativeTo[v]
                info.arg2 = v
                UIDropDownMenu_AddButton(info, level)
            end
        end)

        function controls.dropDown.thresholdIconRelativeTo:SetValue(newValue, newName)
            spec.thresholds.icons.relativeTo = newValue
            spec.thresholds.icons.relativeToName = newName
			
			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(spec)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end
		
		--NOTE: the order of these checkboxes is reversed!
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for any abilities currently on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(spec.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.enabled = self:GetChecked()
			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)
			
			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)

		yCoord = yCoord - 80
		title = "Threshold Icon Width"
		controls.thresholdIconWidth = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.width, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.width = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)
		end)

		title = "Threshold Icon Height"
		controls.thresholdIconHeight = TRB.UiFunctions:BuildSlider(parent, title, 1, 128, spec.thresholds.icons.height, 1, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconHeight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.height = value

			local maxBorderSize = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))
			local borderSize = spec.thresholds.icons.border
		
			if maxBorderSize < borderSize then
				maxBorderSize = borderSize
			end

			controls.thresholdIconBorderWidth:SetMinMaxValues(0, maxBorderSize)
			controls.thresholdIconBorderWidth.MaxLabel:SetText(maxBorderSize)
			controls.thresholdIconBorderWidth.EditBox:SetText(borderSize)				
		end)


		title = "Threshold Icon Horizontal Position (Relative)"
		yCoord = yCoord - 60
		controls.thresholdIconHorizontal = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), spec.thresholds.icons.xPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconHorizontal:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.xPos = value

			if GetSpecialization() == 3 then
				TRB.Functions.RepositionBar(spec, TRB.Frames.barContainerFrame)
			end
		end)

		title = "Threshold Icon Vertical Position (Relative)"
		controls.thresholdIconVertical = TRB.UiFunctions:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), spec.thresholds.icons.yPos, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.thresholdIconVertical:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.yPos = value
		end)

		local maxIconBorderHeight = math.min(math.floor(spec.thresholds.icons.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.thresholds.icons.width / TRB.Data.constants.borderWidthFactor))

		title = "Threshold Icon Border Width"
		yCoord = yCoord - 60
		controls.thresholdIconBorderWidth = TRB.UiFunctions:BuildSlider(parent, title, 0, maxIconBorderHeight, spec.thresholds.icons.border, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.thresholdIconBorderWidth:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.icons.border = value

			local minsliderWidth = math.max(spec.thresholds.icons.border*2, 1)
			local minsliderHeight = math.max(spec.thresholds.icons.border*2, 1)

			controls.thresholdIconHeight:SetMinMaxValues(minsliderHeight, 128)
			controls.thresholdIconHeight.MinLabel:SetText(minsliderHeight)
			controls.thresholdIconWidth:SetMinMaxValues(minsliderWidth, 128)
			controls.thresholdIconWidth.MinLabel:SetText(minsliderWidth)

			if GetSpecialization() == 3 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)


		yCoord = yCoord - 60

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfCoordinatedAssault = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssault
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Coordinated Assault")
		f.tooltip = "Changes the bar color when Coordinated Assault is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfCoordinatedAssault.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfCoordinatedAssault.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfCoordinatedAssaultModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Coordinated Assault ends."
		if spec.endOfCoordinatedAssault.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(false)
			spec.endOfCoordinatedAssault.mode = "gcd"
		end)

		title = "Coordinated Assault GCDs - 0.75sec Floor"
		controls.endOfCoordinatedAssaultGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 20, spec.endOfCoordinatedAssault.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfCoordinatedAssaultGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfCoordinatedAssault.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfCoordinatedAssaultModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_EOCA_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfCoordinatedAssaultModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Coordinated Assault ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Coordinated Assault ends."
		if spec.endOfCoordinatedAssault.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfCoordinatedAssaultModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfCoordinatedAssaultModeTime:SetChecked(true)
			spec.endOfCoordinatedAssault.mode = "time"
		end)

		title = "Coordinated Assault Time Remaining (sec)"
		controls.endOfCoordinatedAssaultTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.endOfCoordinatedAssault.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfCoordinatedAssaultTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfCoordinatedAssault.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current focus is above the overcapping maximum Focus as configured below."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 100, spec.overcapThreshold, 1, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.survival

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_Survival_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Font & Text).", 3, 3, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FontLeft", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontLeft.label = TRB.UiFunctions:BuildSectionHeader(parent, "Left Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontLeft.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontLeft:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontLeft, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontLeft, spec.displayText.left.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.left.fontFace
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
			spec.displayText.left.fontFace = newValue
			spec.displayText.left.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FontMiddle", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontMiddle.label = TRB.UiFunctions:BuildSectionHeader(parent, "Middle Bar Font Face", oUi.xCoord2, yCoord)
		controls.dropDown.fontMiddle.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontMiddle:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontMiddle, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.middle.fontFace
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
			spec.displayText.middle.fontFace = newValue
			spec.displayText.middle.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_FontRight", parent, "UIDropDownMenuTemplate")
		controls.dropDown.fontRight.label = TRB.UiFunctions:BuildSectionHeader(parent, "Right Bar Font Face", oUi.xCoord, yCoord)
		controls.dropDown.fontRight.label.font:SetFontObject(GameFontNormal)
		controls.dropDown.fontRight:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		UIDropDownMenu_SetWidth(controls.dropDown.fontRight, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
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
						info.checked = fonts[v] == spec.displayText.right.fontFace
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
			spec.displayText.right.fontFace = newValue
			spec.displayText.right.fontFaceName = newName
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontFaceLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font face for all text")
		f.tooltip = "This will lock the font face for text for each part of the bar to be the same."
		f:SetChecked(spec.displayText.fontFaceLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontFaceLock = self:GetChecked()
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = spec.displayText.left.fontFace
				spec.displayText.middle.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
				spec.displayText.right.fontFace = spec.displayText.left.fontFace
				spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
				UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)

				if GetSpecialization() == 3 then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end
		end)


		yCoord = yCoord - 70
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Size and Colors", 0, yCoord)

		title = "Left Bar Text Font Size"
		yCoord = yCoord - 50
		controls.fontSizeLeft = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.left.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeLeft:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.left.fontSize = value
			leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fontSizeLock
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use the same font size for all text")
		f.tooltip = "This will lock the font sizes for each part of the bar to be the same size."
		f:SetChecked(spec.displayText.fontSizeLock)
		f:SetScript("OnClick", function(self, ...)
			spec.displayText.fontSizeLock = self:GetChecked()
			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(spec.displayText.left.fontSize)
				controls.fontSizeRight:SetValue(spec.displayText.left.fontSize)
			end
		end)

		controls.colors.text = {}

		controls.colors.text.left = TRB.UiFunctions:BuildColorPicker(parent, "Left Text", spec.colors.text.left,
														250, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.text.left
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "left")
		end)

		controls.colors.text.middle = TRB.UiFunctions:BuildColorPicker(parent, "Middle Text", spec.colors.text.middle,
														225, 25, oUi.xCoord2, yCoord-70)
		f = controls.colors.text.middle
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "middle")
		end)

		controls.colors.text.right = TRB.UiFunctions:BuildColorPicker(parent, "Right Text", spec.colors.text.right,
														225, 25, oUi.xCoord2, yCoord-110)
		f = controls.colors.text.right
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "right")
		end)

		title = "Middle Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeMiddle = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.middle.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeMiddle:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.middle.fontSize = value

			if GetSpecialization() == 3 then
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		title = "Right Bar Text Font Size"
		yCoord = yCoord - 60
		controls.fontSizeRight = TRB.UiFunctions:BuildSlider(parent, title, 6, 72, spec.displayText.right.fontSize, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.fontSizeRight:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.displayText.right.fontSize = value

			if GetSpecialization() == 3 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Focus Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.spending = TRB.UiFunctions:BuildColorPicker(parent, "Focus loss from hardcasting spender abilities", spec.colors.text.spending, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "spending")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Focus", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Focus to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Current Focus is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Focus text color when your current focus or a hardcast spell will result in overcapping maximum Focus."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($ssCount) will change based on whether or not the DoT is on the current target."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.up = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target", spec.colors.text.dots.up, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.up
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "up")
		end)

		controls.colors.dots.pandemic = TRB.UiFunctions:BuildColorPicker(parent, "DoT is active on current target but within Pandemic refresh range", spec.colors.text.dots.pandemic, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.pandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "pandemic")
		end)

		controls.colors.dots.down = TRB.UiFunctions:BuildColorPicker(parent, "DoT is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)
		

		yCoord = yCoord - 130
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Decimal Precision", 0, yCoord)

		yCoord = yCoord - 50
		title = "Haste / Crit / Mastery / Vers Decimal Precision"
		controls.hastePrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.hastePrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.hastePrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			spec.hastePrecision = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end

	local function SurvivalConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.survival

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Hunter_Survival_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Audio & Tracking).", 3, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.killShotAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_killShot_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.killShotAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Kill Shot is usable")
		f.tooltip = "Play an audio cue when Kill Shot is usable and off of cooldown. If you also have Flayer's Mark proc audio enabled, that sound takes priority when a proc occurs."
		f:SetChecked(spec.audio.killShot.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.killShot.enabled = self:GetChecked()

			if spec.audio.killShot.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.killShotAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_killShot_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.killShotAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.killShotAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.killShotAudio, spec.audio.killShot.soundName)
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
						info.checked = sounds[v] == spec.audio.killShot.sound
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
			spec.audio.killShot.sound = newValue
			spec.audio.killShot.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.killShotAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Focus")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Focus."
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
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
						info.checked = sounds[v] == spec.audio.overcap.sound
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
			spec.audio.overcap.sound = newValue
			spec.audio.overcap.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.overcapAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.flayersMarkAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_flayersMark_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flayersMarkAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Flayer's Mark proc (if |cFFFF4040Venthyr|r)")
		f.tooltip = "Play an audio cue when you get a Flayer's Mark proc that allows you to cast Kill Shot for 0 Focus and above normal execute range enemy health."
		f:SetChecked(spec.audio.flayersMark.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.flayersMark.enabled = self:GetChecked()

			if spec.audio.flayersMark.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.flayersMarkAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_flayersMark_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.flayersMarkAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.flayersMarkAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, spec.audio.flayersMark.soundName)
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
						info.checked = sounds[v] == spec.audio.flayersMark.sound
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
			spec.audio.flayersMark.sound = newValue
			spec.audio.flayersMark.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.flayersMarkAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.nesingwarysTrappingApparatusAudio = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_nesingwarysTrappingApparatus_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.nesingwarysTrappingApparatusAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Nesingwary's Trapping Apparatus proc")
		f.tooltip = "Play an audio cue when you get a Nesingwary's Trapping Apparatus proc that allows your next Aimed Shot to cost 0 Focus."
		f:SetChecked(spec.audio.nesingwarysTrappingApparatus.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.nesingwarysTrappingApparatus.enabled = self:GetChecked()

			if spec.audio.nesingwarysTrappingApparatus.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.nesingwarysTrappingApparatusAudio = CreateFrame("FRAME", "TwintopResourceBar_Hunter_Survival_nesingwarysTrappingApparatusAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.nesingwarysTrappingApparatusAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.nesingwarysTrappingApparatusAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, spec.audio.nesingwarysTrappingApparatus.soundName)
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
						info.checked = sounds[v] == spec.audio.nesingwarysTrappingApparatus.sound
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
			spec.audio.nesingwarysTrappingApparatus.sound = newValue
			spec.audio.nesingwarysTrappingApparatus.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.nesingwarysTrappingApparatusAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Focus Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackFocusRegen = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_trackFocusRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackFocusRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track focus regen")
		f.tooltip = "Include focus regen in the passive bar and passive variables. Unchecking this will cause the following Passive Focus Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 40
		controls.checkBoxes.focusGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation from GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X GCDs, based on player's current GCD."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Focus GCDs - 0.75sec Floor"
		controls.focusGenerationGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.focusGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.focusGenerationModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Focus generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Focus generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.focusGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.focusGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Focus Over Time (sec)"
		controls.focusGenerationTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.focusGenerationTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls
	end
    
	local function SurvivalConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.hunter.survival

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.survival
		local yCoord = 5
		local f = nil
		local namePrefix = "Hunter_Survival"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Hunter_Survival_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Hunter_Survival_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (Bar Text).", 3, 3, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function SurvivalConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.survival or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}		
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.survivalDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Hunter_Survival", UIParent)
		interfaceSettingsFrame.survivalDisplayPanel.name = "Survival Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.survivalDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.survivalDisplayPanel)

		parent = interfaceSettingsFrame.survivalDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Survival Hunter", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.survivalHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Survival_survivalHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.survivalHunterEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Survival Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.hunter.survival)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.hunter.survival = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.survivalHunterEnabled, TRB.Data.settings.core.enabled.hunter.survival, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.survivalHunterEnabled, TRB.Data.settings.core.enabled.hunter.survival, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Hunter_Survival_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Hunter_Survival_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Survival Hunter (All).", 3, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Hunter_Survival_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Hunter_Survival_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.survival = controls

		SurvivalConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		SurvivalConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		SurvivalConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		SurvivalConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		SurvivalConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		BeastMasteryConstructOptionsPanel(specCache.beastMastery)
		MarksmanshipConstructOptionsPanel(specCache.marksmanship)
		SurvivalConstructOptionsPanel(specCache.survival)
	end
	TRB.Options.Hunter.ConstructOptionsPanel = ConstructOptionsPanel
end