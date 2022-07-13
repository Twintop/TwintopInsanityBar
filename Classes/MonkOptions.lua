local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 10 then --Only do this if we're on a Monk!
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

	TRB.Options.Monk = {}
	TRB.Options.Monk.Brewmaster = {}
	TRB.Options.Monk.Mistweaver = {}
	TRB.Options.Monk.Windwalker = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.brewmaster = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = {}


	-- Mistweaver
	local function MistweaverLoadDefaultBarTextSimpleSettings()
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

	local function MistweaverLoadDefaultBarTextAdvancedSettings()
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

	local function MistweaverLoadDefaultSettings()
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

		settings.displayText = MistweaverLoadDefaultBarTextSimpleSettings()
		return settings
	end

	local function MistweaverResetSettings()
		local settings = MistweaverLoadDefaultSettings()
		return settings
	end

	local function WindwalkerLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$serenityTime}[$serenityTime sec]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="{$danceOfChiJiTime}[$danceOfChiJiTime] {$motcCount}[#sck $motcCount | $motcMinTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive + ]$energy",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end
    
    local function WindwalkerLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$serenityTime}[#serenity $serenityTime #serenity]{$ttd}[||nTTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$danceOfChiJiTime}[$danceOfChiJiTime]{$motcCount}[||n#sck$motcCount - $motcMinTime#sck]",
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

	local function WindwalkerLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			overcapThreshold=120,
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
				-- Core Monk
				cracklingJadeLightning = {
					enabled = true, -- 1
				},
				detox = {
					enabled = false, -- 2
				},
				expelHarm = {
					enabled = true, -- 3
				},
				paralysis = {
					enabled = false, -- 4
				},
				tigerPalm = {
					enabled = true, -- 5
				},
				vivify = {
					enabled = false, -- 6
				},
				-- Windwalker
				disable = {
					enabled = false, -- 7
				},
				-- Talents
				fistOfTheWhiteTiger = {
					enabled = true, -- 8
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
                fullWidth=false,
            },
			endOfSerenity = {
				enabled=true,
				mode="gcd",
				gcdsMax=2,
				timeMax=3.0
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
						up="FFFFFFFF",
						down="FFFF0000",
						pandemic="FFFF00FF"
					}
				},
				bar = {
					border="FFFFD300",
					borderOvercap="FFFF0000",
					borderChiJi="FF00FF00",
					background="66000000",
					base="FFFFFF00",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF9F4500",
					serenity="FF00FF96",
					serenityEnd="FFFF0000",
					t28="FF006D40",
					overcapEnabled=true,
				},
				comboPoints = {
					border="FF00FF98",
					background="66000000",
					base="FFB5FFEB",
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
				danceOfChiJi={
					name = "Dance of Chi-Ji",
					enabled=false,
					sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
					soundName="TRB: Air Horn"
				},
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

		settings.displayText = WindwalkerLoadDefaultBarTextSimpleSettings()
		return settings
    end

	local function WindwalkerResetSettings()
		local settings = WindwalkerLoadDefaultSettings()
		return settings
	end


    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		if TwintopInsanityBarSettings.core ~= nil and
			TwintopInsanityBarSettings.core.experimental ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs ~= nil and
			TwintopInsanityBarSettings.core.experimental.specs.monk ~= nil and 
			TwintopInsanityBarSettings.core.experimental.specs.monk.mistweaver then
			settings.monk.mistweaver = MistweaverLoadDefaultSettings()
		end

		settings.monk.windwalker = WindwalkerLoadDefaultSettings()
		return settings
	end
    TRB.Options.Monk.LoadDefaultSettings = LoadDefaultSettings
	


	--[[

	Mistweaver Option Menus

	]]

	local function MistweaverConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.mistweaver

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_Reset"] = {
			text = "Do you want to reset Twintop's Resource Bar back to its default configuration? Only the Mistweaver Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = MistweaverResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Mistweaver Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MistweaverLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Mistweaver Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MistweaverLoadDefaultBarTextAdvancedSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		--[[
		StaticPopupDialogs["TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (narrow advanced) configuration? Only the Mistweaver Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = MistweaverLoadDefaultBarTextNarrowAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		--[[
		controls.resetButton2 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Narrow Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton2:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextNarrowAdvanced")
		end)
		]]

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Mistweaver_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Monk_Mistweaver_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Mistweaver Monk (Bar Display).", 10, 2, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 10, 2, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 10, 2, yCoord, false)

		yCoord = yCoord - 30
		local yCoord2 = yCoord
		yCoord, yCoord2 = TRB.UiFunctions:GenerateBarDisplayOptions(parent, controls, spec, 10, 2, yCoord, "Mana", "notFull", true, true, false)

		yCoord = yCoord - 70
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Mana", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.spending = TRB.UiFunctions:BuildColorPicker(parent, "Mana cost of current hardcast spell", spec.colors.bar.spending, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.spending
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Mana from Passive Sources (Potions, Mana Tide Totem bonus regen, etc)", spec.colors.bar.passive, 550, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
		end)


		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Border Color + Changing", 0, yCoord)

		yCoord = yCoord - 25
		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Bar's normal/base border", spec.colors.bar.border, 275, 25, oUi.xCoord2, yCoord-0)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 2)
		end)

		controls.colors.innervate = TRB.UiFunctions:BuildColorPicker(parent, "Border when you have Innervate", spec.colors.bar.innervate, 275, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.innervate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "innervate")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.innervateBorderChange = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Threshold_Option_innervateBorderChange", parent, "ChatConfigCheckButtonTemplate")
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

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.potionOfSpiritualClarityThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Threshold_Option_potionOfSpiritualClarity", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.potionOfSpiritualClarityThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Potion of Spiritual Clarity (10,000 + regen)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Potion of Spirital Clarity (10,000 + 10 seconds of passive mana regen)"
		f:SetChecked(spec.thresholds.potionOfSpiritualClarity.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.potionOfSpiritualClarity.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.soulfulManaPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Threshold_Option_soulfulManaPotion", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.soulfulManaPotionThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Soulful Mana Potion (4,000)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Soulful Mana Potion (4,000)"
		f:SetChecked(spec.thresholds.soulfulManaPotion.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.soulfulManaPotion.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.spiritualManaPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Threshold_Option_spiritualManaPotion", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spiritualManaPotionThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Spiritual Mana Potion (6,000)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Mana you will gain if you use a Spiritual Mana Potion (6,000)"
		f:SetChecked(spec.thresholds.spiritualManaPotion.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.spiritualManaPotion.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.spiritualRejuvenationPotionThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Threshold_Option_spiritualRejuvenationPotion", parent, "ChatConfigCheckButtonTemplate")
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

		yCoord = TRB.UiFunctions:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 2, yCoord)

		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Potion on Cooldown Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.potionCooldown = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_potionCooldown_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.potionCooldown
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Show potion threshold lines when potion is on cooldown")
		f.tooltip = "Shows the potion threshold lines while potion use is still on cooldown. Configure below how far in advance to have the lines be visible, between 0 - 300 seconds (300 being effectively 'always visible')."
		f:SetChecked(spec.thresholds.potionCooldown.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.potionCooldown.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.potionCooldownModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_potionCooldown_M_GCD", parent, "UIRadioButtonTemplate")
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
		controls.checkBoxes.potionCooldownModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_potionCooldown_M_TIME", parent, "UIRadioButtonTemplate")
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Mistweaver_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Mistweaver Monk (Font & Text).", 10, 2, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30

		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Monk_Mistweaver_FontLeft", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Monk_Mistweaver_FontMiddle", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Monk_Mistweaver_FontRight", parent, "UIDropDownMenuTemplate")
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

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_MistweaverCB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
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

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
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
	
		--[[
		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "DoT Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total DoT counter and DoT timer color based on DoT status?")
		f.tooltip = "When checked, the color of total DoTs up counters and DoT timers will change based on whether or not the DoT is on the current target."
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
		]]

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
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Mistweaver Monk (Audio & Tracking).", 10, 2, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.innervate = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_Innervate_CB", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.innervateAudio = CreateFrame("FRAME", "TwintopResourceBar_Monk_Mistweaver_Innervate_Audio", parent, "UIDropDownMenuTemplate")
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
		controls.checkBoxes.innervateRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_InnervatePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.innervateRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track passive mana regen while Innervate is active")
		f.tooltip = "Show the passive regeneration of mana over the remaining duration of Innervate."
		f:SetChecked(spec.passiveGeneration.innervate)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.innervate = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.manaTideTotemRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_ManaTideTotemPassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.manaTideTotemRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track bonus passive mana regen while Mana Tide Totem is active")
		f.tooltip = "Show the bonus passive regeneration of mana over the remaining duration of Mana Tide Totem."
		f:SetChecked(spec.passiveGeneration.manaTideTotem)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.manaTideTotem = self:GetChecked()
		end)
		
		yCoord = yCoord - 30
		controls.checkBoxes.symbolOfHopeRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_SymbolOfHopePassiveMana_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.symbolOfHopeRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track mana regen from a Priest's Symbol of Hope")
		f.tooltip = "Show the regeneration of mana from a Priest's Symbol of Hope channel. This does not hide the mana regeneration from your own channeling of Symbol of Hope."
		f:SetChecked(spec.passiveGeneration.symbolOfHope)
		f:SetScript("OnClick", function(self, ...)
			spec.passiveGeneration.symbolOfHope = self:GetChecked()
		end)

		TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls
	end

	local function MistweaverConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.mistweaver

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.mistweaver
		local yCoord = 5
		local f = nil

		local namePrefix = "Monk_Mistweaver"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		
		controls.buttons.exportButton_Monk_Mistweaver_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Mistweaver_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Mistweaver Monk (Bar Text).", 10, 2, false, false, false, true, false)
		end)

		yCoord = yCoord - 30
		TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			if GetSpecialization() == 3 then
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
			if GetSpecialization() == 3 then
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
			if GetSpecialization() == 3 then
				TRB.Functions.IsTtdActive(spec)
			end
		end)

		yCoord = yCoord - 30
		local variablesPanel = TRB.UiFunctions:CreateVariablesSidePanel(parent, namePrefix)
		TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
		TRB.Options:CreateBarTextVariables(cache, variablesPanel, 5, -30)
	end

	local function MistweaverConstructOptionsPanel(cache)
		
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.mistweaver or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.mistweaverDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Mistweaver", UIParent)
		interfaceSettingsFrame.mistweaverDisplayPanel.name = "Mistweaver Monk"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.mistweaverDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.mistweaverDisplayPanel)

		parent = interfaceSettingsFrame.mistweaverDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Mistweaver Monk", oUi.xCoord+oUi.xPadding, yCoord-5)	
		
		controls.checkBoxes.mistweaverMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Mistweaver_mistweaverMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.mistweaverMonkEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Mistweaver Monk specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.monk.mistweaver)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.monk.mistweaver = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)
		end)
		
		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.mistweaverMonkEnabled, TRB.Data.settings.core.enabled.monk.mistweaver, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Monk_Mistweaver_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Monk_Mistweaver_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Mistweaver Monk (All).", 10, 2, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab1", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab2", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab3", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab4", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Mistweaver_Tab5", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Monk_Mistweaver_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.mistweaver = controls

		MistweaverConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		MistweaverConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		MistweaverConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		MistweaverConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		MistweaverConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end


	--[[

	Windwalker Option Menus

	]]

	local function WindwalkerConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.windwalker

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec = WindwalkerResetSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = WindwalkerLoadDefaultBarTextSimpleSettings()
				ReloadUI()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Windwalker Monk settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = WindwalkerLoadDefaultBarTextAdvancedSettings()
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
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Monk_Windwalker_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_Monk_Windwalker_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Bar Display).", 10, 3, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 10, 3, yCoord)

		yCoord = yCoord - 30
		yCoord = TRB.UiFunctions:GenerateComboPointDimensionsOptions(parent, controls, spec, 10, 3, yCoord, "Energy", "Chi")

		yCoord = yCoord - 60
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 10, 3, yCoord, true, "Chi")

		yCoord = yCoord - 30
		local yCoord2 = yCoord
		yCoord, yCoord2 = TRB.UiFunctions:GenerateBarDisplayOptions(parent, controls, spec, 10, 3, yCoord, "Energy", "notFull", true, true, false)

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
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Energy gain from Passive Sources", spec.colors.bar.passive, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 3)
		end)

		controls.colors.borderChiJi = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border with Dance of Chi-Ji proc", spec.colors.bar.borderChiJi, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderChiJi
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderChiJi")
		end)

		yCoord = yCoord - 30
		controls.colors.serenity = TRB.UiFunctions:BuildColorPicker(parent, "Energy while Serenity is active", spec.colors.bar.serenity, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.serenity
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "serenity")
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when you are overcapping Energy", spec.colors.bar.borderOvercap, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)

		yCoord = yCoord - 30
		controls.colors.serenityEnd = TRB.UiFunctions:BuildColorPicker(parent, "Energy while you have less than 1 GCD left in Serenity", spec.colors.bar.serenityEnd, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.serenityEnd
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "serenityEnd")
		end)

		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Energy spent from hardcasting spells", spec.colors.bar.casting, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 3)
		end)

		yCoord = yCoord - 30
		controls.colors.t28 = TRB.UiFunctions:BuildColorPicker(parent, "Energy while you have the Primordial Power (T28) buff", spec.colors.bar.t28, 275, 25, oUi.xCoord, yCoord)
		f = controls.colors.t28
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "t28")
		end)

		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 275, 25, oUi.xCoord2, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 3)
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Chi Colors", 0, yCoord)
		controls.colors.comboPoints = {}

		yCoord = yCoord - 30
		controls.colors.comboPoints.base = TRB.UiFunctions:BuildColorPicker(parent, "Chi", spec.colors.comboPoints.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
		end)

		controls.colors.comboPoints.border = TRB.UiFunctions:BuildColorPicker(parent, "Chi's border", spec.colors.comboPoints.border, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.comboPoints.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.penultimate = TRB.UiFunctions:BuildColorPicker(parent, "Penultimate Chi", spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.penultimate
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
		end)

		yCoord = yCoord - 30		
		controls.colors.comboPoints.final = TRB.UiFunctions:BuildColorPicker(parent, "Final Chi", spec.colors.comboPoints.final, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.comboPoints.final
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
		end)

		yCoord = yCoord - 30
		controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.sameColorComboPoint
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Use highest Chi color for all?")
		f.tooltip = "When checked, the highest Chi's color will be used for all Chi. E.g., if you have maximum 5 Chi and currently have 4, the Penultimate color will be used for all Chi instead of just the second to last."
		f:SetChecked(spec.comboPoints.sameColor)
		f:SetScript("OnClick", function(self, ...)
			spec.comboPoints.sameColor = self:GetChecked()
		end)


		controls.colors.comboPoints.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled Chi background", spec.colors.comboPoints.background, 275, 25, oUi.xCoord2, yCoord)
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

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-90)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)
		
		controls.labels.builders = TRB.UiFunctions:BuildLabel(parent, "Builders", 5, yCoord, 110, 20)
		yCoord = yCoord - 20
		controls.checkBoxes.expelHarmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_expelHarm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.expelHarmThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Expel Harm")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Expel Harm. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.expelHarm.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.expelHarm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.tigerPalmThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_tigerPalm", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.tigerPalmThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Tiger Palm")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Tiger Palm."
		f:SetChecked(spec.thresholds.tigerPalm.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.tigerPalm.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.fistOfTheWhiteTigerThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_fistOfTheWhiteTiger", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.fistOfTheWhiteTigerThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fist of the White Tiger (if talented)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Fist of the White Tiger. Only visible if talented in to Fist of the White Tiger. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.fistOfTheWhiteTiger.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.fistOfTheWhiteTiger.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25		
		controls.labels.utility = TRB.UiFunctions:BuildLabel(parent, "General / Utility", 5, yCoord, 110, 20)
		yCoord = yCoord - 20

		controls.checkBoxes.cracklingJadeLightningThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_cracklingJadeLightning", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.cracklingJadeLightningThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Crackling Jade Lightning")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Crackling Jade Lightning."
		f:SetChecked(spec.thresholds.cracklingJadeLightning.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.cracklingJadeLightning.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.detoxThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_detox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.detoxThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Detox")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Detox. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.detox.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.detox.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.paralysisThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_paralysis", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.paralysisThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Paralysis")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Paralysis. If on cooldown, will be colored as 'unusable'."
		f:SetChecked(spec.thresholds.paralysis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.paralysis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.vivifyThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_vivify", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.vivifyThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Vivify")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Vivify."
		f:SetChecked(spec.thresholds.vivify.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.vivify.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.disableThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_Threshold_Option_disable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.disableThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Disable")
		f.tooltip = "This will show the vertical line on the bar denoting how much Energy is required to use Disable."
		f:SetChecked(spec.thresholds.disable.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.disable.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.UiFunctions:GenerateThresholdLineIconsOptions(parent, controls, spec, 10, 3, yCoord)

		yCoord = yCoord - 60
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Serenity Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfSerenity = CreateFrame("CheckButton", "TRB_EOVF_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfSerenity
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Serenity")
		f.tooltip = "Changes the bar color when Serenity is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfSerenity.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfSerenity.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfSerenityModeGCDs = CreateFrame("CheckButton", "TRB_EOFV_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Serenity ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Serenity ends."
		if spec.endOfSerenity.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(false)
			spec.endOfSerenity.mode = "gcd"
		end)

		title = "Serenity GCDs - 0.75sec Floor"
		controls.endOfSerenityGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 10, spec.endOfSerenity.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfSerenityGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfSerenity.gcdsMax = value
		end)

		yCoord = yCoord - 60
		controls.checkBoxes.endOfSerenityModeTime = CreateFrame("CheckButton", "TRB_EOFV_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfSerenityModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Serenity ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Serenity will end."
		if spec.endOfSerenity.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfSerenityModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfSerenityModeTime:SetChecked(true)
			spec.endOfSerenity.mode = "time"
		end)

		title = "Serenity Time Remaining"
		controls.endOfSerenityTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 15, spec.endOfSerenity.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfSerenityTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfSerenity.timeMax = value
		end)


		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB1_8", parent, "ChatConfigCheckButtonTemplate")
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
		controls.overcapAt = TRB.UiFunctions:BuildSlider(parent, title, 0, 170, spec.overcapThreshold, 1, 1,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
		controls.overcapAt:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 1)
			self.EditBox:SetText(value)
			spec.overcapThreshold = value
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Windwalker_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Font & Text).", 10, 3, false, true, false, false, false)
		end)

		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Font Face", 0, yCoord)

		yCoord = yCoord - 30
		-- Create the dropdown, and configure its appearance
		controls.dropDown.fontLeft = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontLeft", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontMiddle = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontMiddle", parent, "UIDropDownMenuTemplate")
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
		controls.dropDown.fontRight = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_FontRight", parent, "UIDropDownMenuTemplate")
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

		controls.checkBoxes.fontFaceLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB1_FONTFACE1", parent, "ChatConfigCheckButtonTemplate")
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

			if GetSpecialization() == 3 then
				leftTextFrame.font:SetFont(spec.displayText.left.fontFace, spec.displayText.left.fontSize, "OUTLINE")
			end

			if spec.displayText.fontSizeLock then
				controls.fontSizeMiddle:SetValue(value)
				controls.fontSizeRight:SetValue(value)
			end
		end)

		controls.checkBoxes.fontSizeLock = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB2_F1", parent, "ChatConfigCheckButtonTemplate")
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

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Energy text color when your current energy is above the overcapping maximum Energy value."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
		end)
		

		yCoord = yCoord - 30
		controls.dotColorSection = TRB.UiFunctions:BuildSectionHeader(parent, "Mark of the Crane Count and Time Remaining Tracking", 0, yCoord)

		yCoord = yCoord - 25

		controls.checkBoxes.dotColor = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_dotColor", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.dotColor
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change total Mark of the Crane counter and Mark of the Crane timer color based on time remaining?")
		f.tooltip = "When checked, the color of total Mark of the Crane debuffs up counters and timers will change based on whether or not Mark of the Crane is on the current target."
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end

	local function WindwalkerConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Audio & Tracking).", 10, 3, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 60
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
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
		controls.dropDown.overcapAudio = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_overcapAudio", parent, "UIDropDownMenuTemplate")
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
		controls.checkBoxes.danceOfChiJiAudio = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_danceOfChiJi_Sound_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.danceOfChiJiAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you get a Dance of Chi-Ji proc")
		f.tooltip = "Play an audio cue when you get a Dance of Chi-Ji proc that allows you to use Spinning Crane Kick for no Chi."
		f:SetChecked(spec.audio.danceOfChiJi.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.audio.danceOfChiJi.enabled = self:GetChecked()

			if spec.audio.danceOfChiJi.enabled then
---@diagnostic disable-next-line: redundant-parameter
				PlaySoundFile(spec.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
			end
		end)

		-- Create the dropdown, and configure its appearance
		controls.dropDown.danceOfChiJiAudio = CreateFrame("FRAME", "TwintopResourceBar_Monk_Windwalker_danceOfChiJi_Audio", parent, "UIDropDownMenuTemplate")
		controls.dropDown.danceOfChiJiAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		UIDropDownMenu_SetWidth(controls.dropDown.danceOfChiJiAudio, oUi.dropdownWidth)
		UIDropDownMenu_SetText(controls.dropDown.danceOfChiJiAudio, spec.audio.danceOfChiJi.soundName)
		UIDropDownMenu_JustifyText(controls.dropDown.danceOfChiJiAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(controls.dropDown.danceOfChiJiAudio, function(self, level, menuList)
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
						info.checked = sounds[v] == spec.audio.danceOfChiJi.sound
						info.func = self.SetValue
						info.arg1 = sounds[v]
						info.arg2 = v
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end)

		-- Implement the function to change the audio
		function controls.dropDown.danceOfChiJiAudio:SetValue(newValue, newName)
			spec.audio.danceOfChiJi.sound = newValue
			spec.audio.danceOfChiJi.soundName = newName
			UIDropDownMenu_SetText(controls.dropDown.danceOfChiJiAudio, newName)
			CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
			PlaySoundFile(spec.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
		end


		yCoord = yCoord - 60
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Passive Energy Regeneration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.trackEnergyRegen = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_trackEnergyRegen_Checkbox", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.trackEnergyRegen
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Track energy regen")
		f.tooltip = "Include energy regen in the passive bar and passive variables. Unchecking this will cause the following Passive Energy Generation options to have no effect."
		f:SetChecked(spec.generation.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.generation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.energyGenerationModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_GCD", parent, "UIRadioButtonTemplate")
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
		controls.checkBoxes.energyGenerationModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_PFG_TIME", parent, "UIRadioButtonTemplate")
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls
	end
    
	local function WindwalkerConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

				local spec = TRB.Data.settings.monk.windwalker

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.windwalker
		local yCoord = 5
		local f = nil

		local namePrefix = "Monk_Windwalker"

		TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)
		controls.buttons.exportButton_Monk_Windwalker_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_Monk_Windwalker_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (Bar Text).", 10, 3, false, false, false, true, false)
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

	local function WindwalkerConstructOptionsPanel(cache)
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.windwalker or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}
		controls.buttons = controls.buttons or {}

		interfaceSettingsFrame.windwalkerDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Monk_Windwalker", UIParent)
		interfaceSettingsFrame.windwalkerDisplayPanel.name = "Windwalker Monk"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.windwalkerDisplayPanel.parent = parent.name
		InterfaceOptions_AddCategory(interfaceSettingsFrame.windwalkerDisplayPanel)

		parent = interfaceSettingsFrame.windwalkerDisplayPanel

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Windwalker Monk", oUi.xCoord+oUi.xPadding, yCoord-5)
	
		controls.checkBoxes.windwalkerMonkEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Monk_Windwalker_windwalkerMonkEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.windwalkerMonkEnabled
		f:SetPoint("TOPLEFT", 250, yCoord-10)		
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Windwalker Monk specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.monk.windwalker)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.monk.windwalker = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.windwalkerMonkEnabled, TRB.Data.settings.core.enabled.monk.windwalker, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 345, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)        
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_Monk_Windwalker_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 440, yCoord-10, 150, 20)
		controls.buttons.exportButton_Monk_Windwalker_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Windwalker Monk (All).", 10, 3, true, true, true, true, false)
		end)

		yCoord = yCoord - 42

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_Monk_Windwalker_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		PanelTemplates_TabResize(tabs[1], 0)
		PanelTemplates_TabResize(tabs[2], 0)
		PanelTemplates_TabResize(tabs[3], 0)
		PanelTemplates_TabResize(tabs[4], 0)
		PanelTemplates_TabResize(tabs[5], 0)
		yCoord = yCoord - 15

		for i = 1, 5 do 
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_Monk_Windwalker_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.windwalker = controls

		WindwalkerConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		WindwalkerConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		WindwalkerConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		WindwalkerConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		WindwalkerConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		
		if TRB.Data.settings.core.experimental.specs.monk.mistweaver then
			MistweaverConstructOptionsPanel(specCache.mistweaver)
		end

		WindwalkerConstructOptionsPanel(specCache.windwalker)
	end
	TRB.Options.Monk.ConstructOptionsPanel = ConstructOptionsPanel
end