local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
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

	TRB.Options.Druid = {}
	TRB.Options.Druid.Balance = {}
	TRB.Options.Druid.Feral = {}
	TRB.Options.Druid.Guardian = {}
	TRB.Options.Druid.Restoration = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.balance = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.feral = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.guardian = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = {}

	--[[ 
		Balance Defaults
	]]

	local function BalanceLoadDefaultBarTextSimpleSettings()
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
				text="{$eclipse}[$eclipseTime sec.]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$casting}[$casting + ]{$passive}[$passive + ]$astralPower",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function BalanceLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#sunfire $sunfireCount    {$talentStellarFlare}[#stellarFlare $stellarFlareCount    ]$haste% ($gcd)||n#moonfire $moonfireCount     {$talentStellarFlare}[          ]{$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$eclipse}[#eclipse $eclipseTime #eclipse]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$astralPower",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function BalanceLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			astralPowerPrecision=0,
			overcapThreshold=100,
			thresholds = {
				width = 2,
				overlapBorder=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "BOTTOM",
					relativeToName = "Below",
					enabled=true,
					xPos=0,
					yPos=12,
					width=24,
					height=24
				},
				starsurgeThresholdOnlyOverShow = false,
				starsurge = { -- 1
					enabled = true,
					showIcon = true
				},
				starsurge2 = { -- 2
					enabled = true,
					showIcon = true
				},
				starsurge3 = { -- 3
					enabled = true,
					showIcon = true
				},
				starfall = { -- 4
					enabled = true,
					showIcon = true
				},
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfEclipse = {
				enabled=true,
				celestialAlignmentOnly=false,
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
					current="FFFFB668",
					casting="FFFFFFFF",
					passive="FF00AA00",
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
					border="FFC16920",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFFF7C0A",
					lunar="FF144D72",
					solar="FFFFEE00",
					celestial="FF4A95CE",
					casting="FFFFFFFF",
					passive="FF006600",
					eclipse1GCD="FFFF0000",
					moonkinFormMissing="FFFF0000",
					flashAlpha=0.70,
					flashPeriod=0.5,
					flashEnabled=true,
					flashSsEnabled=true,
					overcapEnabled=true
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					starfallPandemic="FF8B0000"
				}
			},
			displayText = {},
			audio = {
				ssReady={
					name = "Starsurge Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				sfReady={
					name = "Starfall Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				onethsReady={
					name = "Oneth's Clear Vision Ready",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
					soundName="TRB: Boxing Arena Gong"
				},
				overcap={
					name = "Overcap",
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

		settings.displayText = BalanceLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function BalanceResetSettings()
		local settings = BalanceLoadDefaultSettings()
		return settings
	end


	--[[ 
		Feral Defaults
	]]

	local function FeralLoadDefaultBarTextSimpleSettings()
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
				text="{$casting}[$casting + ]{$passive}[$passive + ]$resource",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function FeralLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "#rake $rakeCount    #thrash $thrashCount||n#rip $ripCount    {$lunarInspiration}[#moonfire $moonfireCount]",
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
				text = "{$casting}[#casting$casting+]{$passive}[$passive+]$resource",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function FeralLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			overcapThreshold=120,
			thresholds = {
				width = 2,
				overlapBorder=true,
				bleedColors=true,
				icons = {
					showCooldown=true,
					border=2,
					relativeTo = "BOTTOM",
					relativeToName = "Below",
					enabled=true,
					xPos=0,
					yPos=12,
					width=24,
					height=24
				},
				-- Core Druid
				ferociousBite = {
					enabled = true, -- 1
				},
				shred = {
					enabled = true, -- 2
				},
				-- Feral
				maim = {
					enabled = false, -- 3
				},
				rake = {
					enabled = true, -- 4
				},
				rip = {
					enabled = true, -- 5
				},
				swipe = {
					enabled = false, -- 6
				},
				thrash = {
					enabled = true, -- 7
				},
				-- Talents
				moonfire = {
					enabled = true, -- 8
				},
				savageRoar = {
					enabled = true, -- 9
				},
				brutalSlash = {
					enabled = true, -- 10
				},
				primalWrath = {
					enabled = true, -- 11
				},
				bloodtalons = {
					enabled = false, -- 12
				},
				feralFrenzy = {
					enabled = true, -- 13
				},
				-- Extras
				ferociousBiteMinimum = {
					enabled = false -- 14
				},
				ferociousBiteMaximum = {
					enabled = true -- 15
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
            comboPoints = {
                width=25,
                height=13,
				xPos=0,
				yPos=4,
				border=1,
                spacing=14,
                relativeTo="TOP",
                relativeToName="Above - Middle",
                fullWidth=false
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
					right="FFFFFFFF",
					dots={
						enabled=true,
						same="FFFFFFFF",
						down="FFFF8888",
						worse="FFFF33BB",
						better="FF009955"
					}
				},
				bar = {
					border="FFFF7C0A",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFFFFF00",
					clearcasting="FF4A95CE",
					maxBite="FF009900",
					apexPredator="FFE75480",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF9F4500",
					overcapEnabled=true,
				},
				comboPoints = {
					border="FFFF7C0A",
					background="66000000",
					base="FFFFFF00",
					penultimate="FFFF9900",
					final="FFFF0000",
					sameColor=false
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
				apexPredatorsCraving={
					name = "Apex Predator's Craving Proc",
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
				textureLock=true,
				comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
				comboPointsBackgroundName="Blizzard Tooltip",
				comboPointsBorder="Interface\\Buttons\\WHITE8X8",
				comboPointsBorderName="1 Pixel",
				comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
				comboPointsBarName="Blizzard",
			}
		}
		settings.displayText = FeralLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function FeralResetSettings()
		local settings = FeralLoadDefaultSettings()
		return settings
	end

	
	-- Restoration
	local function RestorationLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$efflorescenceTime}[$efflorescenceTime]",
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

	local function RestorationLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$potionCooldown}[#psc $potionCooldown] ",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text = "{$efflorescenceTime}[#efflorescence $efflorescenceTime #efflorescence]",
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

	local function RestorationLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
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
				potionOfSpiritualClarity = {
					enabled = true, -- 1
				},
				spiritualRejuvenationPotion = {
					enabled = false, -- 2
				},
				spiritualManaPotion = {
					enabled = true, -- 3
				},
				soulfulManaPotion = {
					enabled = false, -- 4
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
					noEfflorescence="FFFF0000",
					innervate="FF00FF00",
					spending="FFFFFFFF",
					passive="FF8080FF",
					innervateBorderChange=true
				},
				threshold={
					unusable="FFFF0000",
					over="FF00FF00",
					mindbender="FF8080FF"
				}
			},
			displayText={},
			audio={
				innervate={
					name = "Innervate",
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

		settings.displayText = RestorationLoadDefaultBarTextSimpleSettings()
		return settings
	end

	local function RestorationResetSettings()
		local settings = RestorationLoadDefaultSettings()
		return settings
	end



    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.druid.balance = BalanceLoadDefaultSettings()
		settings.druid.feral = FeralLoadDefaultSettings()
		if TwintopInsanityBarSettings.core ~= nil and
			TwintopInsanityBarSettings.core.experimental ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs.druid ~= nil and 
			TwintopInsanityBarSettings.core.experimental.specs.druid.restoration then
			settings.druid.restoration = RestorationLoadDefaultSettings()
		end
		return settings
	end
    TRB.Options.Druid.LoadDefaultSettings = LoadDefaultSettings

	--[[

		Balance Option Menus

	]]

	local function BalanceConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.balance

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.balance
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Druid_Balance_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = BalanceResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BalanceLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BalanceLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Druid_Balance_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Balance Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = BalanceLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Druid_Balance_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Balance_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
	end

	local function BalanceConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.balance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.balance
		local yCoord = 5
		local f = nil

		local title = ""

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)
		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		controls.buttons.exportButton_Druid_Balance_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Balance_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Bar Display).", 11, 1, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 11, 1, yCoord)


		yCoord = yCoord - 30
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 11, 1, yCoord, false)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 50

		title = "Bar Flash Alpha"
		controls.flashAlpha = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, spec.colors.bar.flashAlpha, 0.01, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.flashAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashAlpha = value
		end)

		title = "Bar Flash Period (sec)"
		controls.flashPeriod = TRB.UiFunctions:BuildSlider(parent, title, 0, 2, spec.colors.bar.flashPeriod, 0.05, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.flashPeriod:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.colors.bar.flashPeriod = value
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_RB1_2", parent, "UIRadioButtonTemplate")
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

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Astral Power > 0")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Astral Power > 0 (or < 50 with Nature's Balance), hidden otherwise when out of combat."
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

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_RB1_4", parent, "UIRadioButtonTemplate")
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

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_RB1_5", parent, "UIRadioButtonTemplate")
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

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_CB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash bar when Moonkin Form is missing")
		f.tooltip = "This will flash the bar when Moonkin Form is missing while in combat."
		f:SetChecked(spec.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.flashSsEnabled = CreateFrame("CheckButton", "TwintopResourceBar_CB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashSsEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Flash bar when Starsurge is usable")
		f.tooltip = "This will flash the bar when Starsurge can be cast."
		f:SetChecked(spec.colors.bar.flashSsEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashSsEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 70

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Astral Power", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.solar = TRB.UiFunctions:BuildColorPicker(parent, "Eclipse (Solar) is Active", spec.colors.bar.solar, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.solar
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "solar")
		end)

		yCoord = yCoord - 30
		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 1)
		end)

		controls.colors.lunar = TRB.UiFunctions:BuildColorPicker(parent, "Eclipse (Lunar) is Active", spec.colors.bar.lunar, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.lunar
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "lunar")
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Astral Power from hardcasting spells", spec.colors.bar.casting, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
		end)

		controls.colors.celestial = TRB.UiFunctions:BuildColorPicker(parent, "Celestial Alignment / Incarnation: Chosen of Elune is Active", spec.colors.bar.celestial, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.celestial
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "celestial")
		end)

		yCoord = yCoord - 30

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when your current hardcast will overcap Astral Power", spec.colors.bar.borderOvercap, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)

		controls.colors.eclipse1GCD = TRB.UiFunctions:BuildColorPicker(parent, "Astral Power when Eclipse is ending", spec.colors.bar.eclipse1GCD, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.eclipse1GCD
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "eclipse1GCD")
		end)

		yCoord = yCoord - 30

		controls.colors.moonkinFormMissing = TRB.UiFunctions:BuildColorPicker(parent, "Moonkin Form missing when in combat", spec.colors.bar.moonkinFormMissing, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.moonkinFormMissing
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "moonkinFormMissing")
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Astral Power from Fury of Elune and Nature's Balance", spec.colors.bar.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)


		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Astral Power", spec.colors.threshold.under, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Astral Power", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.starfallPandemic = TRB.UiFunctions:BuildColorPicker(parent, "Starfall outside Pandemic refresh range or on cooldown w/Stellar Drift", spec.colors.threshold.starfallPandemic, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.starfallPandemic
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "starfallPandemic")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)


		controls.checkBoxes.sfThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starfallEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sfThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show Starfall threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast Starfall."
		f:SetChecked(spec.thresholds.starfall.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.starfall.enabled = self:GetChecked()

			if spec.thresholds.starfall.enabled then
				TRB.Frames.resourceFrame.thresholds[4]:Show()
			else
				TRB.Frames.resourceFrame.thresholds[4]:Hide()
			end
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ssThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show Starsurge threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast Starsurge."
		f:SetChecked(spec.thresholds.starsurge.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.starsurge.enabled = self:GetChecked()

			if spec.thresholds.starsurge.enabled then
				TRB.Frames.resourceFrame.thresholds[1]:Show()
			else
				TRB.Frames.resourceFrame.thresholds[1]:Hide()
			end
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.ssThreshold2Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge2Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssThreshold2Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show 2x Starsurge threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast two Starsurges in a row."
		f:SetChecked(spec.thresholds.starsurge2.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.starsurge2.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 20
		controls.checkBoxes.ssThreshold3Show = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurge3Enabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssThreshold3Show
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show 3x Starsurge threshold line")
		f.tooltip = "This will show the vertical line on the bar denoting how much Astral Power is required to cast three Starsurges in a row."
		f:SetChecked(spec.thresholds.starsurge3.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.starsurge3.enabled = self:GetChecked()
		end)
		yCoord = yCoord - 20
		controls.checkBoxes.ssThresholdOnlyOverShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_Threshold_starsurgeOnlyOver", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssThresholdOnlyOverShow
		f:SetPoint("TOPLEFT", oUi.xCoord+20, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Only show current + next threshold line?")
		f.tooltip = "This will only show Starsurge threshold lines if you already have enough Astral Power to cast it, or, if it is the next threshold you're approaching. Only triggers the next after the previous threshold line has been reached, even if it is not checked above!"
		f:SetChecked(spec.thresholds.starsurgeThresholdOnlyOverShow)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.starsurgeThresholdOnlyOverShow = self:GetChecked()
		end)

		yCoord = yCoord - 30

		
        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Druid_Balance_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
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
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for Starfall when it is on Cooldown (with the Stellar Flare talent)."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
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

				if spec.thresholds.icons.enabled then
					resourceFrame.thresholds[1].icon:Show()
					resourceFrame.thresholds[2].icon:Show()
					resourceFrame.thresholds[3].icon:Show()
					resourceFrame.thresholds[4].icon:Show()
				else
					resourceFrame.thresholds[1].icon:Hide()
					resourceFrame.thresholds[2].icon:Hide()
					resourceFrame.thresholds[3].icon:Hide()
					resourceFrame.thresholds[4].icon:Hide()
				end
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
						
			if GetSpecialization() == 1 then
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], "starsurge", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], "starsurge2", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], "starsurge3", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], "starfall", spec)
			end
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
						
			if GetSpecialization() == 1 then
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], "starsurge", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], "starsurge2", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], "starsurge3", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], "starfall", spec)
			end
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


		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Eclipse Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfEclipse = CreateFrame("CheckButton", "TRB_EOE_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfEclipse
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Eclipse")
		f.tooltip = "Changes the bar color when Eclipse is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfEclipse.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfEclipse.enabled = self:GetChecked()
		end)
		yCoord = yCoord - 20
		controls.checkBoxes.endOfEclipseOnly = CreateFrame("CheckButton", "TRB_EOE_CB_CAO", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfEclipseOnly
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Only change the bar color when in Celestial Alignment")
		f.tooltip = "Only changes the bar color when you are exiting an Eclipse from Celestial Alignment or Incarnation: Chosen of Elune."
		f:SetChecked(spec.endOfEclipse.celestialAlignmentOnly)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfEclipse.celestialAlignmentOnly = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfEclipseModeGCDs = CreateFrame("CheckButton", "TRB_EOE_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfEclipseModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Eclipse ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Eclipse ends."
		if spec.endOfEclipse.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfEclipseModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfEclipseModeTime:SetChecked(false)
			spec.endOfEclipse.mode = "gcd"
		end)

		title = "Eclipse GCDs - 0.75sec Floor"
		controls.endOfEclipseGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 15, spec.endOfEclipse.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfEclipseGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfEclipse.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfEclipseModeTime = CreateFrame("CheckButton", "TRB_EOE_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfEclipseModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Eclipse ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Eclipse ends."
		if spec.endOfEclipse.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfEclipseModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfEclipseModeTime:SetChecked(true)
			spec.endOfEclipse.mode = "time"
		end)

		title = "Eclipse Time Remaining (sec)"
		controls.endOfEclipseTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 20, spec.endOfEclipse.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfEclipseTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfEclipse.timeMax = value
		end)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current hardcast spell will result in overcapping maximum Astral Power."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 100, spec.overcapThreshold, 0.5, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
	end

	local function BalanceConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.balance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.balance
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Balance_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Balance_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Font & Text).", 11, 1, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_FontLeft", parent, "UIDropDownMenuTemplate")
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
			leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_FontMiddle", parent, "UIDropDownMenuTemplate")
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
			middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.right.fontFace = newValue
				spec.displayText.right.fontFaceName = newName
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			end
			CloseDropDownMenus()
		end

		yCoord = yCoord - 40 - 20

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_FontRight", parent, "UIDropDownMenuTemplate")
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
			rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			UIDropDownMenu_SetText(controls.dropDown.fontRight, newName)
			if spec.displayText.fontFaceLock then
				spec.displayText.left.fontFace = newValue
				spec.displayText.left.fontFaceName = newName
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontLeft, newName)
				spec.displayText.middle.fontFace = newValue
				spec.displayText.middle.fontFaceName = newName
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, newName)
			end
			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
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
				middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontMiddle, spec.displayText.middle.fontFaceName)
				spec.displayText.right.fontFace = spec.displayText.left.fontFace
				spec.displayText.right.fontFaceName = spec.displayText.left.fontFaceName
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				UIDropDownMenu_SetText(controls.dropDown.fontRight, spec.displayText.right.fontFaceName)
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

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
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
			middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
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
			rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Astral Power Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Astral Power", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.UiFunctions:BuildColorPicker(parent, "Astral Power from hardcasting spells", spec.colors.text.casting, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Astral Power", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Astral Power to cast Starsurge or Starfall", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Cast will overcap Astral Power", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TRB_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Astral Power text color when you are able to cast Starsurge or Starfall"
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TRB_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Astral Power text color when your current hardcast spell will result in overcapping maximum Astral Power."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($sunfireCount, $moonfireCount, $stellarFlareCount) will change based on whether or not the DoT is on the current target."
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

		title = "Astral Power Decimal Precision"
		controls.astralPowerPrecision = TRB.UiFunctions:BuildSlider(parent, title, 0, 1, spec.astralPowerPrecision, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.astralPowerPrecision:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 0)
			self.EditBox:SetText(value)
			spec.astralPowerPrecision = value
		end)

		TRB.Frames.interfaceSettingsFrame = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
	end

	local function BalanceConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.balance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.balance
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Balance_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Balance_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Audio & Tracking).", 11, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.ssReady = CreateFrame("CheckButton", "TwintopResourceBar_CB3_3", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ssReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Starsurge is usable")
		f.tooltip = "Play an audio cue when Starsurge can be cast."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.ssReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.ssReady.enabled = self:GetChecked()

			if spec.audio.ssReady.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.ssReadyAudio = CreateFrame("FRAME", "TwintopResourceBar_ssReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.ssReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.ssReadyAudio, oUi.sliderWidth)
		UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, spec.audio.ssReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.ssReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.ssReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.ssReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.ssReadyAudio:SetValue(newValue, newName)
			spec.audio.ssReady.sound = newValue
			spec.audio.ssReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.ssReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.sfReady = CreateFrame("CheckButton", "TwintopResourceBar_CB3_MD_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sfReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Starfall is usable")
		f.tooltip = "Play an audio cue when Starfall is usable. This supercedes the regular Starsurge audio sound if both are usable."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.sfReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.sfReady.enabled = self:GetChecked()

			if spec.audio.sfReady.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.sfReadyAudio = CreateFrame("FRAME", "TwintopResourceBar_sfReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.sfReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.sfReadyAudio, oUi.sliderWidth)
		UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, spec.audio.sfReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.sfReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.sfReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.sfReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.sfReadyAudio:SetValue(newValue, newName)
			spec.audio.sfReady.sound = newValue
			spec.audio.sfReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.sfReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.checkBoxes.onethsReady = CreateFrame("CheckButton", "TwintopResourceBar_CB3_oneths_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.onethsReady
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when Oneth's Clear Vision or Oneth's Perception proc occurs.")
		f.tooltip = "Play an audio cue when an Oneth's Clear Vision or Oneth's Perception proc occurs. This supercedes the regular Starsurge and Starfall audio sound if both are usable."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.onethsReady.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.onethsReady.enabled = self:GetChecked()

			if spec.audio.onethsReady.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.onethsReady.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.onethsReadyAudio = CreateFrame("FRAME", "TwintopResourceBar_onethsReadyAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.onethsReadyAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.onethsReadyAudio, oUi.sliderWidth)
		UIDropDownMenu_SetText(controls.dropDown.onethsReadyAudio, spec.audio.onethsReady.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.onethsReadyAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.onethsReadyAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.onethsReady.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.onethsReadyAudio:SetValue(newValue, newName)
			spec.audio.onethsReady.sound = newValue
			spec.audio.onethsReady.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.onethsReadyAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.onethsReady.sound, TRB.Data.settings.core.audio.channel.channel)
		end



		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Astral Power")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Astral Power."
---@diagnostic disable-next-line: undefined-field
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_overcapAudio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30+10)
		UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.sliderWidth)
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

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls
	end

	local function BalanceConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.balance

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.balance
		local yCoord = 5
		local f = nil
		local namePrefix = "Druid_Balance"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Druid_Balance_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Balance_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (Bar Text).", 11, 1, false, false, false, true, false)
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

	local function BalanceConstructOptionsPanel(cache)
				
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.balance or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.balanceDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Balance", UIParent)
		interfaceSettingsFrame.balanceDisplayPanel.name = "Balance Druid"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.balanceDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.balanceDisplayPanel)

		parent = interfaceSettingsFrame.balanceDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Balance Druid", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.balanceDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Balance_balanceDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.balanceDruidEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Balance Druid specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.druid.balance)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.druid.balance = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.balanceDruidEnabled, TRB.Data.settings.core.enabled.druid.balance, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.balanceDruidEnabled, TRB.Data.settings.core.enabled.druid.balance, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Druid_Balance_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Druid_Balance_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Balance Druid (All).", 11, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Balance_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Druid_Balance_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.balance = controls

		BalanceConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		BalanceConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		BalanceConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		BalanceConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		BalanceConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	--[[

	Feral Option Menus

	]]

	local function FeralConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.feral

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.feral
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Druid_Feral_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Feral Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = FeralResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Feral Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = FeralLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Feral Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = FeralLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[StaticPopupDialogs["TwintopResourceBar_Druid_Feral_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Feral Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = FeralLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Druid_Feral_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Feral_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
	end

	local function FeralConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.feral

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.feral
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Druid_Feral_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Feral_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Feral Druid (Bar Display).", 11, 2, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 11, 2, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.UiFunctions:GenerateComboPointDimensionsOptions(parent, controls, spec, 11, 2, yCoord, "Energy", "Combo Point")

		yCoord = yCoord - 60
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 11, 2, yCoord, true, "Combo Point")

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)		

		yCoord = yCoord - 40

        --[[
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

		yCoord = yCoord - 40]]

		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_RB1_2", parent, "UIRadioButtonTemplate")
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

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show Resource Bar when Energy is not capped")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Energy is not capped, hidden otherwise when out of combat."
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

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_RB1_4", parent, "UIRadioButtonTemplate")
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

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_RB1_5", parent, "UIRadioButtonTemplate")
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

		--[[
		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)]]

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

        --[[
		controls.checkBoxes.flashEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB1_5", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.flashEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
		getglobal(f:GetName() .. 'Text'):SetText("Flash Bar when Beastial Wrath is usable")
		f.tooltip = "This will flash the bar when Beastial Wrath can be cast."
		f:SetChecked(spec.colors.bar.flashEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.flashEnabled = self:GetChecked()
		end)

		controls.checkBoxes.esThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB1_6", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.esThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-60)
		getglobal(f:GetName() .. 'Text'):SetText("Border color when Beastial Wrath is usable")
		f.tooltip = "This will change the bar's border color (as configured below) when Beastial Wrath is usable."
		f:SetChecked(spec.colors.bar.beastialWrathEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.beastialWrathEnabled = self:GetChecked()
		end)
        ]]

		yCoord = yCoord - 70

		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Energy", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
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
		controls.colors.clearcasting = TRB.UiFunctions:BuildColorPicker(parent, "Energy when Clearcasting proc is up", spec.colors.bar.clearcasting, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.clearcasting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "clearcasting")
		end)

		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Energy gain from Passive Sources", spec.colors.bar.passive, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)


		yCoord = yCoord - 30
		controls.colors.maxBite = TRB.UiFunctions:BuildColorPicker(parent, "Energy when 5 Combo Points and Ferocious Bite will do max damage", spec.colors.bar.maxBite, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.maxBite
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "maxBite")
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)


		yCoord = yCoord - 30
		controls.colors.apexPredator = TRB.UiFunctions:BuildColorPicker(parent, "Energy when you have an Apex Predator's Craving proc", spec.colors.bar.apexPredator, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.apexPredator
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "apexPredator")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Combo Point Colors", 0, yCoord)

		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.UiFunctions:BuildColorPicker(parent, "Combo Points", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.UiFunctions:BuildColorPicker(parent, "Combo Point's border", spec.colors.comboPoints.border, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.UiFunctions:BuildColorPicker(parent, "Penultimate Combo Point", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.UiFunctions:BuildColorPicker(parent, "Final Combo Point", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Combo Point color for all?")
		f.tooltip = "When checked, the highest Combo Point's color will be used for all Combo Points. E.g., if you have maximum 5 combo points and currently have 4, the Penultimate color will be used for all Combo Points instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)

		controls.colors.comboPoints.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled Combo Point background", spec.colors.comboPoints.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)
		
		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Energy threshold line", spec.colors.threshold.under, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Energy threshold line", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.thresholdBleedColors = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdBleedColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdBleedColors
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-120)
		getglobal(f:GetName() .. 'Text'):SetText("Use different colors for Bleed snapshots?")
		f.tooltip = "When checked, threshold lines for Rake, Rip, Thrash, and Moonfire (if Lunar Inspiration is talented) will have their threshold lines colored based on if the current buffs are better, worse, or the same damage (or the bleed is not on the target) instead of based on available Energy or Combo Points. The colors used are set in the 'Bleed Snapshotting' section under the 'Font & Text' tab."
		f:SetChecked(spec.thresholds.bleedColors)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.bleedColors = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.UiFunctions:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.brutalSlashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_brutalSlash", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.brutalSlashThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Brutal Slash (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Brutal Slash. Only visible if talented in to Brutal Slash. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.brutalSlash.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.brutalSlash.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.feralFrenzyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_feralfrenzy", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feralFrenzyThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Feral Frenzy (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Feral Frenzy. Only visible if talented in to Feral Frenzy. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.feralFrenzy.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.feralFrenzy.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.moonfireThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_moonfire", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.moonfireThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Moonfire (if Lunar Inspiration talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Moonfire. Only visible if talented in to Lunar Inspiration."
		f:SetChecked(spec.thresholds.moonfire.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.moonfire.enabled = self:GetChecked()
		end)
		
		yCoord = yCoord - 25
		controls.checkBoxes.rakeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rake", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.rakeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rake")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Rake."
		f:SetChecked(spec.thresholds.rake.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rake.enabled = self:GetChecked()
		end)
		
		yCoord = yCoord - 25
		controls.checkBoxes.shredThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_shred", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.shredThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Shred")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Shred."
		f:SetChecked(spec.thresholds.shred.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.shred.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.swipeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_swipe", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.swipeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Swipe (if Brutal Slash untalented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Swipe. Only visible if not talented in to Brutal Slash."
		f:SetChecked(spec.thresholds.swipe.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.swipe.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.thrashThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_thrash", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thrashThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Thrash")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Thrash."
		f:SetChecked(spec.thresholds.thrash.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.thrash.enabled = self:GetChecked()
		end)


		yCoord = yCoord - 25
		controls.labels.finishers = TRB.UiFunctions:BuildLabel(parent, "Finishers", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.ferociousBiteThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBite", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ferociousBiteThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ferocious Bite (moving/dynamic)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite. If you do not have any combo points, will be colored as 'unusable'. Will move along the bar between the current minimum and maximum Energy cost amounts."
		f:SetChecked(spec.thresholds.ferociousBite.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ferociousBite.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ferociousBiteMinimumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMinimum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ferociousBiteMinimumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ferocious Bite (minimum)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite at its minimum Energy cost. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.ferociousBiteMinimum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ferociousBiteMinimum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ferociousBiteMaximumThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_ferociousBiteMaximum", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ferociousBiteMaximumThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding*2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Ferocious Bite (maximum)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Ferocious Bite at its maximum Energy cost. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.ferociousBiteMaximum.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.ferociousBiteMaximum.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.maimThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_maim", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.maimThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Maim")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Maim. If on cooldown or you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.maim.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.maim.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.primalWrathThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_primalwrath", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.primalWrathThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Primal Wrath (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Primal Wrath. Only visible when talented in to Primal Wrath. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.primalWrath.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.primalWrath.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.ripThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_rip", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.ripThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Rip")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Rip. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.rip.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.rip.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.savageRoarThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_savageRoar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.savageRoarThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Savage Roar (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Savage Roar. Only visible when talented in to Savage Roar. If you do not have any combo points, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.savageRoar.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.savageRoar.enabled = self:GetChecked()
		end)

		--[[
		yCoord = yCoord - 25		
		controls.labels.other = TRB.UiFunctions:BuildLabel(parent, "Other Thresholds", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.bloodtalonsThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_Threshold_Option_bloodtalons", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.bloodtalonsThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Bloodtalons (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use complete a successful Bloodtalons ability combo. Only visible when talented in to Bloodtalons."
		f:SetChecked(spec.thresholds.bloodtalons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.bloodtalons.enabled = self:GetChecked()
		end)
		]]

		yCoord = yCoord - 30

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
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
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for any abilities currently on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
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

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when overcapping")
		f.tooltip = "This will change the bar's border color when your current energy is above the overcapping maximum Energy as configured below."
		f:SetChecked(spec.colors.bar.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.overcapEnabled = self:GetChecked()
		end)

		yCoord = yCoord - 40

		title = "Show Overcap Notification Above"
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 130, spec.overcapThreshold, 1, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
	end

	local function FeralConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.feral

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.feral
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Feral_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Feral_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Feral Druid (Font & Text).", 11, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_FontLeft", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_FontMiddle", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_FontRight", parent, "UIDropDownMenuTemplate")
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

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
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

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
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
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Energy Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Energy", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)
		
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Energy", spec.colors.text.passive, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Energy to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Current Energy is above overcap threshold", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bleed Snapshotting", 0, yCoord)

		yCoord = yCoord - 25
		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total Bleed counters and Bleed timers based on shapshotted damage?")
		f.tooltip = "When checked, the color of total Bleeds (and Moonfire, if talented) up counters and Bleed timers will change based on whether or not the current snapshotted damage values are better, worse, or the same vs. your current damage buffs."
		f:SetChecked(spec.colors.text.dots.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.dots.enabled = self:GetChecked()
		end)

		controls.colors.dots = {}

		controls.colors.dots.same = TRB.UiFunctions:BuildColorPicker(parent, "Bleed snapshot on current target is the same", spec.colors.text.dots.same, 550, 25, oUi.xCoord, yCoord-30)
		f = controls.colors.dots.same
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "same")
		end)

		controls.colors.dots.worse = TRB.UiFunctions:BuildColorPicker(parent, "Bleed snapshot on current target is worse and should be reapplied.", spec.colors.text.dots.worse, 550, 25, oUi.xCoord, yCoord-60)
		f = controls.colors.dots.worse
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "worse")
		end)

		controls.colors.dots.better = TRB.UiFunctions:BuildColorPicker(parent, "Bleed snapshot on current target is better and should NOT be reapplied.", spec.colors.text.dots.better, 550, 25, oUi.xCoord, yCoord-90)
		f = controls.colors.dots.better
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "better")
		end)

		controls.colors.dots.down = TRB.UiFunctions:BuildColorPicker(parent, "Bleed is not active on current target", spec.colors.text.dots.down, 550, 25, oUi.xCoord, yCoord-120)
		f = controls.colors.dots.down
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text.dots, controls.colors.dots, "down")
		end)


		yCoord = yCoord - 150
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
	end

	local function FeralConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.feral

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.feral
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Feral_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Feral_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Feral Druid (Audio & Tracking).", 11, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.apcAudio = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_apc_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.apcAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when an Apex Predator's Craving proc occurs")
		f.tooltip = "Play an audio cue when an Apex Predator's Craving (legendary) proc occurs, allowing a max damage Ferocious Bite to be cast without spending any Energy or Combo Points."
		f:SetChecked(spec.audio.apexPredatorsCraving.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.apexPredatorsCraving.enabled = self:GetChecked()

			if spec.audio.apexPredatorsCraving.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.apcAudio = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_apexPredatorsCraving_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.apcAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.apcAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.apcAudio, spec.audio.apexPredatorsCraving.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.apcAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.apcAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.apexPredatorsCraving.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.apcAudio:SetValue(newValue, newName)
			spec.audio.apexPredatorsCraving.sound = newValue
			spec.audio.apexPredatorsCraving.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.apcAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
		end

		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Energy")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Energy."
		f:SetChecked(spec.audio.overcap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.overcap.enabled = self:GetChecked()

			if spec.audio.overcap.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Druid_Feral_overcapAudio", parent, "UIDropDownMenuTemplate")
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
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_PFG_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over GCDs")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X GCDs, based on player's current GCD length."
		if spec.generation.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(true)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(false)
			spec.generation.mode = "gcd"
		end)

		title = "Energy GCDs - 0.75sec Floor"
		controls.energyGenerationGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.generation.gcds, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.energyGenerationGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.generation.gcds = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_PFG_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.energyGenerationModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Energy generation over time")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Shows the amount of Energy generation over the next X seconds."
		if spec.generation.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.energyGenerationModeGCDs:SetChecked(false)
			controls.checkBoxes.energyGenerationModeTime:SetChecked(true)
			spec.generation.mode = "time"
		end)

		title = "Energy Over Time (sec)"
		controls.energyGenerationTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.generation.time, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.energyGenerationTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.generation.time = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls
	end
    
	local function FeralConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.feral

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.feral
		local yCoord = 5
		local f = nil
		local namePrefix = "Druid_Feral"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Druid_Feral_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Feral_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Feral Druid (Bar Text).", 11, 2, false, false, false, true, false)
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

	local function FeralConstructOptionsPanel(cache)
				
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.feral or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.feralDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Feral", UIParent)
		interfaceSettingsFrame.feralDisplayPanel.name = "Feral Druid"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.feralDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.feralDisplayPanel)

		parent = interfaceSettingsFrame.feralDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Feral Druid", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.feralDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Feral_feralDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.feralDruidEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Feral Druid specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.druid.feral)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.druid.feral = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.feralDruidEnabled, TRB.Data.settings.core.enabled.druid.feral, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.feralDruidEnabled, TRB.Data.settings.core.enabled.druid.feral, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Druid_Feral_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Druid_Feral_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Feral Druid (All).", 11, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Feral_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Druid_Feral_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.feral = controls

		FeralConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		FeralConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		FeralConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		FeralConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		FeralConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	--[[

	Restoration Druid

	]]

	local function RestorationConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.restoration

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Restoration Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = RestorationResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Restoration Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = RestorationLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Restoration Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = RestorationLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[
		StaticPopupDialogs["TwintopResourceBar_Druid_Restoration_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Restoration Druid settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = RestorationLoadDefaultBarTextNarrowAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		]]

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar to Defaults", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton = TRB.UiFunctions:BuildButton(parent, "Reset to Defaults", oUi.xCoord, yCoord, 150, 30)
		controls.resetButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Restoration_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Druid_Restoration_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Druid_Restoration_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Restoration_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Restoration Druid (Bar Display).", 11, 4, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 11, 4, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 11, 4, yCoord, false)

		yCoord = yCoord - 30
		controls.barDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.alwaysShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_RB1_2", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.alwaysShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Always show bar")
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

		controls.checkBoxes.notZeroShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_RB1_3", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.notZeroShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-15)
		getglobal(f:GetName() .. 'Text'):SetText("Show bar when Mana is not full")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar show out of combat only if Mana is not full, hidden otherwise when out of combat."
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

		controls.checkBoxes.combatShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_RB1_4", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.combatShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Only show bar in combat")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "This will make the Resource Bar only be visible on your UI when in combat."
		f:SetChecked((not spec.displayBar.alwaysShow) and (not spec.displayBar.notZeroShow) and (not spec.displayBar.neverShow))
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

		controls.checkBoxes.neverShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_RB1_5", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.neverShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord-45)
		getglobal(f:GetName() .. 'Text'):SetText("Never show bar (run in background)")
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

		controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_showCastingBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showCastingBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show casting bar")
		f.tooltip = "This will show the casting bar when hardcasting a spell. Uncheck to hide this bar."
		f:SetChecked(spec.bar.showCasting)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showCasting = self:GetChecked()
		end)

		controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_showPassiveBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.showPassiveBar
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
		getglobal(f:GetName() .. 'Text'):SetText("Show passive bar")
		f.tooltip = "This will show the passive bar. Uncheck to hide this bar. This setting supercedes any other passive tracking options!"
		f:SetChecked(spec.bar.showPassive)
		f:SetScript("OnClick", function(self, ...)
			spec.bar.showPassive = self:GetChecked()
		end)

		yCoord = yCoord - 70
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Mana", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.noEfflorescence = TRB.UiFunctions:BuildColorPicker(parent, "Mana when Efflorescence is not out", spec.colors.bar.noEfflorescence, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.noEfflorescence
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "noEfflorescence")
		end)

		yCoord = yCoord - 30
		controls.colors.spending = TRB.UiFunctions:BuildColorPicker(parent, "Mana cost of current hardcast spell", spec.colors.bar.spending, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 4)
		end)
		
		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 4)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Mana from Passive Sources (Potions, Mana Tide Totem bonus regen, etc)", spec.colors.bar.passive, 550, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 4)
		end)


		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Border Color + Changing", 0, yCoord)

		yCoord = yCoord - 25
		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Bar's normal/base border", spec.colors.bar.border, 275, 25, oUi.xCoord2, yCoord-0)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 4)
		end)

		controls.colors.innervate = TRB.UiFunctions:BuildColorPicker(parent, "Border when you have Innervate", spec.colors.bar.innervate, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.innervate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "innervate")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.innervateBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Threshold_Option_innervateBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateBorderChange
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Innervate")
		f.tooltip = "This will change the bar border color when you have Innervate."
		f:SetChecked(spec.colors.bar.innervateBorderChange)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.innervateBorderChange = self:GetChecked()
		end)
		
		yCoord = yCoord - 30

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Threshold Lines", 0, yCoord)

		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Mana gain from potions (when usable)", spec.colors.threshold.over, 275, 25, oUi.xCoord2, yCoord-0)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Mana potion on cooldown", spec.colors.threshold.unusable, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.mindbender = TRB.UiFunctions:BuildColorPicker(parent, "Passive mana gain per source", spec.colors.threshold.mindbender, 275, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.mindbender
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "mindbender")
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.potionOfSpiritualClarityThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Threshold_Option_potionOfSpiritualClarity", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.potionOfSpiritualClarityThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Potion of Spiritual Clarity (10,000 + regen)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Potion of Spirital Clarity (10,000 + 10 seconds of passive mana regen)"
		f:SetChecked(spec.thresholds.potionOfSpiritualClarity.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.potionOfSpiritualClarity.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.soulfulManaPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Threshold_Option_soulfulManaPotion", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.soulfulManaPotionThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Soulful Mana Potion (4,000)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Soulful Mana Potion (4,000)"
		f:SetChecked(spec.thresholds.soulfulManaPotion.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.soulfulManaPotion.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.spiritualManaPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Threshold_Option_spiritualManaPotion", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spiritualManaPotionThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Spiritual Mana Potion (6,000)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Spiritual Mana Potion (6,000)"
		f:SetChecked(spec.thresholds.spiritualManaPotion.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.spiritualManaPotion.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.spiritualRejuvenationPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Threshold_Option_spiritualRejuvenationPotion", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spiritualRejuvenationPotionThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Spiritual Rejuvenation Potion (2,500)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Spiritual Rejuvenation Potion (2,500)"
		f:SetChecked(spec.thresholds.spiritualRejuvenationPotion.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.spiritualRejuvenationPotion.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		yCoord = yCoord - 25

        -- Create the dropdown, and configure its appearance
        controls.dropDown.thresholdIconRelativeTo = CreateFrame("FRAME", "TwintopResourceBar_Druid_Restoration_thresholdIconRelativeTo", parent, "UIDropDownMenuTemplate")
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
			
			if GetSpecialization() == 4 then
				TRB.Functions.RedrawThresholdLines(spec)
			end

            UIDropDownMenu_SetText(controls.dropDown.thresholdIconRelativeTo, newName)
            CloseDropDownMenus()
        end
		
		--NOTE: the order of these checkboxes is reversed!
		controls.checkBoxes.thresholdIconCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_thresholdIconThresholdEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord2+(oUi.xPadding*2), yCoord-30)
		getglobal(f:GetName() .. 'Text'):SetText("Show cooldown overlay?")
		f.tooltip = "When checked, the cooldown spinner animation (and cooldown remaining time text, if enabled in Interface -> Action Bars) will be visible for potion icons that are on cooldown."
		f:SetChecked(spec.thresholds.icons.showCooldown)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.showCooldown = self:GetChecked()
		end)
		
		TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

		controls.checkBoxes.thresholdIconEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_thresholdIconEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdIconEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Show ability icons for threshold lines?")
		f.tooltip = "When checked, icons for the threshold each line represents will be displayed. Configuration of size and location of these icons is below."
		f:SetChecked(spec.thresholds.icons.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.icons.enabled = self:GetChecked()
			TRB.UiFunctions:ToggleCheckboxEnabled(controls.checkBoxes.thresholdIconCooldown, spec.thresholds.icons.enabled)

			if GetSpecialization() == 4 then
				TRB.Functions.RedrawThresholdLines(spec)

				if spec.thresholds.icons.enabled then
					resourceFrame.thresholds[1].icon:Show()
					resourceFrame.thresholds[2].icon:Show()
					resourceFrame.thresholds[3].icon:Show()
					resourceFrame.thresholds[4].icon:Show()
				else
					resourceFrame.thresholds[1].icon:Hide()
					resourceFrame.thresholds[2].icon:Hide()
					resourceFrame.thresholds[3].icon:Hide()
					resourceFrame.thresholds[4].icon:Hide()
				end
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
						
			if GetSpecialization() == 4 then
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], "potionOfSpiritualClarity", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], "spiritualRejuvenationPotion", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], "spiritualManaPotion", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], "soulfulManaPotion", spec)
			end
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
						
			if GetSpecialization() == 4 then
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], "potionOfSpiritualClarity", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], "spiritualRejuvenationPotion", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], "spiritualManaPotion", spec)
				TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], "soulfulManaPotion", spec)
			end
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

			if GetSpecialization() == 4 then
				TRB.Functions.RedrawThresholdLines(spec)
			end
		end)


		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Potion on Cooldown Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.potionCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_potionCooldown_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.potionCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show potion threshold lines when potion is on cooldown")
		f.tooltip = "Shows the potion threshold lines while potion use is still on cooldown. Configure below how far in advance to have the lines be visible, between 0 - 300 seconds (300 being effectively 'always visible')."
		f:SetChecked(spec.thresholds.potionCooldown.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.potionCooldown.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.potionCooldownModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_potionCooldown_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.potionCooldownModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs left on Potion cooldown")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Show potion threshold lines based on how many GCDs remain on potion cooldown."
		if spec.thresholds.potionCooldown.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.potionCooldownModeGCDs:SetChecked(true)
			controls.checkBoxes.potionCooldownModeTime:SetChecked(false)
			spec.thresholds.potionCooldown.mode = "gcd"
		end)

		title = "Potion Cooldown GCDs - 0.75sec Floor"
		controls.potionCooldownGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0, 400, spec.thresholds.potionCooldown.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.potionCooldownGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.thresholds.potionCooldown.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.potionCooldownModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_potionCooldown_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.potionCooldownModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time left on Potion cooldown")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Apotheosis will end."
		if spec.thresholds.potionCooldown.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.potionCooldownModeGCDs:SetChecked(false)
			controls.checkBoxes.potionCooldownModeTime:SetChecked(true)
			spec.thresholds.potionCooldown.mode = "time"
		end)

		title = "Potion Cooldown Time Remaining"
		controls.potionCooldownTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 300, spec.thresholds.potionCooldown.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.potionCooldownTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.thresholds.potionCooldown.timeMax = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Restoration_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Restoration_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Restoration Druid (Font & Text).", 11, 4, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Druid_Restoration_FontLeft", parent, "UIDropDownMenuTemplate")
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

			if GetSpecialization() == 4 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
					rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Druid_Restoration_FontMiddle", parent, "UIDropDownMenuTemplate")
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

			if GetSpecialization() == 4 then
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
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Druid_Restoration_FontRight", parent, "UIDropDownMenuTemplate")
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

			if GetSpecialization() == 4 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
				if spec.displayText.fontFaceLock then
					leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
					middleTextFrame.font:SetFont(spec.displayText.middle.fontFace, spec.displayText.middle.fontSize, "OUTLINE")
				end
			end

			CloseDropDownMenus()
		end

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Druid_RestorationCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
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

				if GetSpecialization() == 4 then
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

			if GetSpecialization() == 4 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
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

			if GetSpecialization() == 4 then
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

			if GetSpecialization() == 4 then
				rightTextFrame.font:SetFont(spec.displayText.right.fontFace, spec.displayText.right.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeLeft:SetValue(value)
				controls.fontSizeMiddle:SetValue(value)
			end
		end)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Mana Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Mana", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.casting = TRB.UiFunctions:BuildColorPicker(parent, "Mana spent from hardcasting spells", spec.colors.text.casting, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
		end)

		yCoord = yCoord - 30
		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Mana", spec.colors.text.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)
	
		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers ($fsCount) will change based on whether or not the DoT is on the current target."
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

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.druid.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Druid_Restoration_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Restoration_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Restoration Druid (Audio & Tracking).", 11, 4, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervate
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio when you gain Innervate")
		f.tooltip = "This sound will play when you gain Innervate from a helpful Druid."
		f:SetChecked(spec.audio.innervate.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.innervate.enabled = self:GetChecked()

			if spec.audio.innervate.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.innervateAudio = CreateFrame("FRAME", "TwintopResourceBar_Druid_Restoration_Innervate_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.innervateAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.innervateAudio, oUi.sliderWidth)
		UIDropDownMenu_SetText(controls.dropDown.innervateAudio, spec.audio.innervate.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.innervateAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.innervateAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.innervate.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.innervateAudio:SetValue(newValue, newName)
			spec.audio.innervate.sound = newValue
			spec.audio.innervate.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.innervateAudio, newName)
			CloseDropDownMenus()
			---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
		end
		
		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive External Mana Generation Tracking", 0, yCoord)
		
		yCoord = yCoord - 30
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track passive mana regen while Innervate is active")
		f.tooltip = "Show the passive regeneration of mana over the remaining duration of Innervate."
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track bonus passive mana regen while Mana Tide Totem is active")
		f.tooltip = "Show the bonus passive regeneration of mana over the remaining duration of Mana Tide Totem."
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track mana regen from a Priest's Symbol of Hope")
		f.tooltip = "Show the regeneration of mana from a Priest's Symbol of Hope channel. This does not hide the mana regeneration from your own channeling of Symbol of Hope."
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls
	end

	local function RestorationConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.druid.restoration

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.restoration
		local yCoord = 5
		local f = nil

		local namePrefix = "Druid_Restoration"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		
		controls.buttons.exportButton_Druid_Restoration_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Druid_Restoration_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Restoration Druid (Bar Text).", 11, 4, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 4 then
				TRB.Functions.IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.UiFunctions:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 4 then
				TRB.Functions.IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 70
		TRB.UiFunctions:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.right = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Right", spec.displayText.right.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.right
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.right.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 4 then
				TRB.Functions.IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function RestorationConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.restoration or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.restorationDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Druid_Restoration", UIParent)
		interfaceSettingsFrame.restorationDisplayPanel.name = "Restoration Druid"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.restorationDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.restorationDisplayPanel)

		parent = interfaceSettingsFrame.restorationDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Restoration Druid", oUi.xCoord+oUi.xPadding, yCoord-5)	
		
		controls.checkBoxes.restorationDruidEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Druid_Restoration_restorationDruidEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.restorationDruidEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Restoration Druid specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.druid.restoration)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.druid.restoration = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.restorationDruidEnabled, TRB.Data.settings.core.enabled.druid.restoration, true)
		end)
		
		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.restorationDruidEnabled, TRB.Data.settings.core.enabled.druid.restoration, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Druid_Restoration_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Druid_Restoration_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Restoration Druid (All).", 11, 4, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Druid_Restoration_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Druid_Restoration_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.restoration = controls

		RestorationConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		RestorationConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		RestorationConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		RestorationConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		RestorationConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end	

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		BalanceConstructOptionsPanel(specCache.balance)
		FeralConstructOptionsPanel(specCache.feral)
		
		if TRB.Data.settings.core.experimental.specs.druid.restoration then
			RestorationConstructOptionsPanel(specCache.restoration)
		end
	end
	TRB.Options.Druid.ConstructOptionsPanel = ConstructOptionsPanel
end