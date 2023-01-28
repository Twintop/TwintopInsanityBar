local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
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

	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

	TRB.Options.DemonHunter = {}
	TRB.Options.DemonHunter.Havoc = {}
    TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = {}

	local function HavocLoadDefaultBarTextSimpleSettings()
		local textSettings = {
			fontSizeLock=true,
			fontFaceLock=true,
			left={
				text="{$ucTime}[$ucTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			middle={
				text="{$metamorphosisTime}[$metamorphosisTime]",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			},
			right={
				text="{$passive}[$passive + ]{$casting}[$casting + ]$fury",
				fontFace="Fonts\\FRIZQT__.TTF",
				fontFaceName="Friz Quadrata TT",
				fontSize=18
			}
		}

		return textSettings
	end

    local function HavocLoadDefaultBarTextAdvancedSettings()
		local textSettings = {
			fontSizeLock = false,
			fontFaceLock = true,
			left = {
				text = "{$ttd}[TTD: $ttd]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			middle = {
				text="{$ucTime}[#unboundChaos $ucTime #unboundChaos||n]{$metamorphosisTime}[#metamorphosis $metamorphosisTime #metamorphosis]",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 13
			},
			right = {
				text = "{$tacticalRetreatFury}[#tacticalRetreat$tacticalRetreatFury+]{$bhFury}[#bh$bhFury+]{$casting}[#casting$casting+]$fury",
				fontFace = "Fonts\\FRIZQT__.TTF",
				fontFaceName = "Friz Quadrata TT",
				fontSize = 22
			}
		}

		return textSettings
	end

	local function HavocLoadDefaultSettings()
		local settings = {
			hastePrecision=2,
			furyPrecision=0,
			overcapThreshold=120,
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
				annihilation = {
					enabled = true, -- 1
				},
				bladeDance = {
					enabled = true, -- 2
				},
				chaosNova = {
					enabled = true, -- 3
				},
				chaosStrike = {
					enabled = true, -- 4
				},
				deathSweep = {
					enabled = true, -- 5
				},
				eyeBeam = {
					enabled = true, -- 6
				},
				-- Talents
				glaiveTempest = {
					enabled = true, -- 7
				},
				felEruption = {
					enabled = true, -- 8
				},
				throwGlaive = {
					enabled = true, -- 9
				}
			},
			displayBar = {
				alwaysShow=false,
				notZeroShow=true,
				neverShow=false
			},
			endOfMetamorphosis = {
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
					current="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					overcap="FFFF0000",
					overThreshold="FF00FF00",
					overThresholdEnabled=false,
					overcapEnabled=true,
					left="FFFFFFFF",
					middle="FFFFFFFF",
					right="FFFFFFFF"
				},
				bar = {
					border="FFA330C9",
					borderOvercap="FFFF0000",
					background="66000000",
					base="FFC942FD",
					casting="FFFFFFFF",
					spending="FF555555",
					passive="FF660066",
					metamorphosis="FF67F100",
					metamorphosisEnding="FFFF0000",
					overcapEnabled=true,
				},
				threshold = {
					under="FFFFFFFF",
					over="FF00FF00",
					unusable="FFFF0000",
					special="FFFF00FF",
					outOfRange="FF440000"
				}
			},
			displayText = {},
			audio = {
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

		settings.displayText = HavocLoadDefaultBarTextSimpleSettings()
		return settings
    end

    local function LoadDefaultSettings()
		local settings = TRB.Options.LoadDefaultSettings()

		settings.demonhunter.havoc = HavocLoadDefaultSettings()
		return settings
	end
    TRB.Options.DemonHunter.LoadDefaultSettings = LoadDefaultSettings

	--[[

	Havoc Option Menus

	]]

	local function HavocConstructResetDefaultsPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_Reset"] = {
			text = "Do you want to reset the Twintop's Resource Bar back to its default configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				TRB.Data.settings.demonhunter.havoc = nil
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (simple) configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HavocLoadDefaultBarTextSimpleSettings()
				C_UI.Reload()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}
		StaticPopupDialogs["TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced"] = {
			text = "Do you want to reset Twintop's Resource Bar's text (including font size, font style, and text information) back to its default (advanced) configuration? Only the Havoc Demon Hunter settings will be changed. This will cause your UI to be reloaded!",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				spec.displayText = HavocLoadDefaultBarTextAdvancedSettings()
				C_UI.Reload()
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
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_Reset")
		end)

		yCoord = yCoord - 40
		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Reset Resource Bar Text", 0, yCoord)

		yCoord = yCoord - 30
		controls.resetButton1 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Simple)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton1:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextSimple")
        end)
		yCoord = yCoord - 40

		controls.resetButton3 = TRB.UiFunctions:BuildButton(parent, "Reset Bar Text (Full Advanced)", oUi.xCoord, yCoord, 250, 30)
		controls.resetButton3:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_DemonHunter_Havoc_ResetBarTextAdvanced")
		end)

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructBarColorsAndBehaviorPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

		local sanityCheckValues = TRB.Functions.GetSanityCheckValues(spec)

		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay = TRB.UiFunctions:BuildButton(parent, "Export Bar Display", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarDisplay:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Display).", 12, 1, true, false, false, false, false)
		end)

		yCoord = TRB.UiFunctions:GenerateBarDimensionsOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		yCoord = TRB.UiFunctions:GenerateBarTexturesOptions(parent, controls, spec, 12, 1, yCoord, false)

		yCoord = yCoord - 30
		local yCoord2 = yCoord
		yCoord, yCoord2 = TRB.UiFunctions:GenerateBarDisplayOptions(parent, controls, spec, 12, 1, yCoord, "Fury", "notEmpty", true, true, false)

		yCoord = yCoord - 70
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.base = TRB.UiFunctions:BuildColorPicker(parent, "Fury", spec.colors.bar.base, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.base
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base")
		end)

		controls.colors.metamorphosis = TRB.UiFunctions:BuildColorPicker(parent, "Fury while Metamorphosis is active", spec.colors.bar.metamorphosis, 225, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosis
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "metamorphosis")
		end)

		yCoord = yCoord - 30
		controls.colors.passive = TRB.UiFunctions:BuildColorPicker(parent, "Fury gain from Passive Sources", spec.colors.bar.passive, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 1)
		end)

		controls.colors.metamorphosisEnding = TRB.UiFunctions:BuildColorPicker(parent, "Fury when Metamorphosis is ending", spec.colors.bar.metamorphosisEnding, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.metamorphosisEnding
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "metamorphosisEnding")
		end)

		yCoord = yCoord - 30
		controls.colors.casting = TRB.UiFunctions:BuildColorPicker(parent, "Fury gain from Eye Beam with Blind Fury", spec.colors.bar.casting, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.casting
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting", "bar", castingFrame, 1)
		end)

		controls.colors.border = TRB.UiFunctions:BuildColorPicker(parent, "Resource Bar's border", spec.colors.bar.border, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", barBorderFrame, 1)
		end)

		
		yCoord = yCoord - 30
		controls.colors.background = TRB.UiFunctions:BuildColorPicker(parent, "Unfilled bar background", spec.colors.bar.background, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 1)
		end)

		controls.colors.borderOvercap = TRB.UiFunctions:BuildColorPicker(parent, "Bar border color when your next builder will overcap Fury", spec.colors.bar.borderOvercap, 250, 25, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)

		yCoord = yCoord - 40
		controls.barColorsSection = TRB.UiFunctions:BuildSectionHeader(parent, "Ability Threshold Lines", 0, yCoord)
		
		controls.colors.threshold = {}

		yCoord = yCoord - 25
		controls.colors.threshold.under = TRB.UiFunctions:BuildColorPicker(parent, "Under minimum required Fury threshold line", spec.colors.threshold.under, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.threshold.under
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "under")
		end)

		controls.colors.threshold.over = TRB.UiFunctions:BuildColorPicker(parent, "Over minimum required Fury threshold line", spec.colors.threshold.over, 300, 25, oUi.xCoord2, yCoord-30)
		f = controls.colors.threshold.over
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "over")
		end)

		controls.colors.threshold.unusable = TRB.UiFunctions:BuildColorPicker(parent, "Ability is unusable threshold line", spec.colors.threshold.unusable, 300, 25, oUi.xCoord2, yCoord-60)
		f = controls.colors.threshold.unusable
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "unusable")
		end)

		controls.colors.threshold.special = TRB.UiFunctions:BuildColorPicker(parent, "Chaos Theory effect up", spec.colors.threshold.special, 300, 25, oUi.xCoord2, yCoord-90)
		f = controls.colors.threshold.special
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "special")
		end)

		controls.colors.threshold.outOfRange = TRB.UiFunctions:BuildColorPicker(parent, "Out of range of current target to use ability", spec.colors.threshold.outOfRange, 300, 25, oUi.xCoord2, yCoord-120)
		f = controls.colors.threshold.outOfRange
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.threshold, controls.colors.threshold, "outOfRange")
		end)

		controls.checkBoxes.thresholdOutOfRange = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdOutOfRange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOutOfRange
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-150)
		getglobal(f:GetName() .. 'Text'):SetText("Change threshold line color when out of range?")
		f.tooltip = "When checked, while in combat threshold lines will change color when you are unable to use the ability due to being out of range of your current target."
		f:SetChecked(spec.thresholds.outOfRange)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.outOfRange = self:GetChecked()
		end)

		controls.checkBoxes.thresholdOverlapBorder = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_thresholdOverlapBorder", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.thresholdOverlapBorder
		f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-170)
		getglobal(f:GetName() .. 'Text'):SetText("Threshold lines overlap bar border?")
		f.tooltip = "When checked, threshold lines will span the full height of the bar and overlap the bar border."
		f:SetChecked(spec.thresholds.overlapBorder)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.overlapBorder = self:GetChecked()
			TRB.Functions.RedrawThresholdLines(spec)
		end)

		controls.checkBoxes.bladeDanceThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_bladeDance", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.bladeDanceThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Blade Dance / Death Sweep")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Blade Dance. Shows for Death Sweep while in Demon Form."
		f:SetChecked(spec.thresholds.bladeDance.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.bladeDance.enabled = self:GetChecked()
			spec.thresholds.deathSweep.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chaosNovaThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosNova", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosNovaThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Nova (no Unleashed Power)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Nova. Only shown if Unleashed Power is not talented."
		f:SetChecked(spec.thresholds.chaosNova.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosNova.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.chaosStrikeThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_chaosStrike", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.chaosStrikeThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Chaos Strike / Annihilation")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Chaos Strike. Shows for Annihilation while in Demon Form."
		f:SetChecked(spec.thresholds.chaosStrike.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.chaosStrike.enabled = self:GetChecked()
			spec.thresholds.annihilation.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.eyeBeamThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_eyeBeam", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.eyeBeamThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Eye Beam")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Eye Beam."
		f:SetChecked(spec.thresholds.eyeBeam.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.eyeBeam.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.felEruptionVictoryThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_felEruption", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.felEruptionVictoryThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Fel Eruption")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Fel Eruption. Only visible if talented."
		f:SetChecked(spec.thresholds.felEruption.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.felEruption.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.glaiveTempestThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_glaiveTempest", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.glaiveTempestThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Glaive Tempest")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Glaive Tempest. Only visible if talented."
		f:SetChecked(spec.thresholds.glaiveTempest.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.glaiveTempest.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 25
		controls.checkBoxes.throwGlaiveThresholdShow = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_Threshold_Option_throwGlaive", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.throwGlaiveThresholdShow
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Throw Glaive (Furious Throws)")
		f.tooltip = "This will show the vertical line on the bar denoting how much Fury is required to use Throw Glaive. Only visible if talented in to Furious Throws."
		f:SetChecked(spec.thresholds.throwGlaive.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.thresholds.throwGlaive.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 30

		yCoord = TRB.UiFunctions:GenerateThresholdLineIconsOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "End of Metamorphosis Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.endOfMetamorphosis = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_CB", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosis
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change bar color at the end of Metamorphosis")
		f.tooltip = "Changes the bar color when Metamorphosis is ending in the next X GCDs or fixed length of time. Select which to use from the options below."
		f:SetChecked(spec.endOfMetamorphosis.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.endOfMetamorphosis.enabled = self:GetChecked()
		end)

		yCoord = yCoord - 40
		controls.checkBoxes.endOfMetamorphosisModeGCDs = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_GCD", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeGCDs
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("GCDs until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many GCDs remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "gcd" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(true)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(false)
			spec.endOfMetamorphosis.mode = "gcd"
		end)

		title = "Metamorphosis GCDs - 0.75sec Floor"
		controls.endOfMetamorphosisGCDs = TRB.UiFunctions:BuildSlider(parent, title, 0.5, 20, spec.endOfMetamorphosis.gcdsMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisGCDs:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			spec.endOfMetamorphosis.gcdsMax = value
		end)


		yCoord = yCoord - 60
		controls.checkBoxes.endOfMetamorphosisModeTime = CreateFrame("CheckButton", "TwintopResourceBar_Hunter_Marksmanship_EOT_M_TIME", parent, "UIRadioButtonTemplate")
		f = controls.checkBoxes.endOfMetamorphosisModeTime
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Time until Metamorphosis ends")
		getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
		f.tooltip = "Change the bar color based on how many seconds remain until Metamorphosis ends."
		if spec.endOfMetamorphosis.mode == "time" then
			f:SetChecked(true)
		end
		f:SetScript("OnClick", function(self, ...)
			controls.checkBoxes.endOfMetamorphosisModeGCDs:SetChecked(false)
			controls.checkBoxes.endOfMetamorphosisModeTime:SetChecked(true)
			spec.endOfMetamorphosis.mode = "time"
		end)

		title = "Metamorphosis Time Remaining (sec)"
		controls.endOfMetamorphosisTime = TRB.UiFunctions:BuildSlider(parent, title, 0, 10, spec.endOfMetamorphosis.timeMax, 0.25, 2,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.endOfMetamorphosisTime:SetScript("OnValueChanged", function(self, value)
			value = TRB.UiFunctions:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.RoundTo(value, 2)
			self.EditBox:SetText(value)
			spec.endOfMetamorphosis.timeMax = value
		end)


		yCoord = yCoord - 40
		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Overcapping Configuration", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB1_8", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Change border color when your next builder ability will overcap Fury")
		f.tooltip = "This will change the bar's border color when your next builder ability will result in overcapping maximum Fury. Setting accepts values up to 130 to accomidate the Deadly Calm talent."
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructFontAndTextPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText = TRB.UiFunctions:BuildButton(parent, "Export Font & Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_FontAndText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Font & Text).", 12, 1, false, true, false, false, false)
		end)

		

		yCoord = TRB.UiFunctions:GenerateFontOptions(parent, controls, spec, 12, 1, yCoord)

		yCoord = yCoord - 40
		controls.textDisplaySection = TRB.UiFunctions:BuildSectionHeader(parent, "Fury Text Colors", 0, yCoord)

		yCoord = yCoord - 30
		controls.colors.text.current = TRB.UiFunctions:BuildColorPicker(parent, "Current Fury", spec.colors.text.current, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.current
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
		end)

		controls.colors.text.passive = TRB.UiFunctions:BuildColorPicker(parent, "Passive Fury", spec.colors.text.passive, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.passive
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
		end)

		yCoord = yCoord - 30
		controls.colors.text.overThreshold = TRB.UiFunctions:BuildColorPicker(parent, "Have enough Fury to use any enabled threshold ability", spec.colors.text.overThreshold, 300, 25, oUi.xCoord, yCoord)
		f = controls.colors.text.overThreshold
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overThreshold")
		end)

		controls.colors.text.overcap = TRB.UiFunctions:BuildColorPicker(parent, "Overcapping Fury", spec.colors.text.overcap, 300, 25, oUi.xCoord2, yCoord)
		f = controls.colors.text.overcap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.UiFunctions:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "overcap")
		end)

		yCoord = yCoord - 30

		controls.checkBoxes.overThresholdEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OverThresholdTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overThresholdEnabled
		f:SetPoint("TOPLEFT", 0, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when you are able to use an ability whose threshold you have enabled under 'Bar Display'."
		f:SetChecked(spec.colors.text.overThresholdEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overThresholdEnabled = self:GetChecked()
		end)

		controls.checkBoxes.overcapTextEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_OvercapTextEnable", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapTextEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord2+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled?")
		f.tooltip = "This will change the Fury text color when your next builder ability will result in overcapping maximum Fury."
		f:SetChecked(spec.colors.text.overcapEnabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.text.overcapEnabled = self:GetChecked()
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructAudioAndTrackingPanel(parent)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil

		local title = ""

		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking = TRB.UiFunctions:BuildButton(parent, "Export Audio & Tracking", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_AudioAndTracking:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Audio & Tracking).", 12, 1, false, false, true, false, false)
		end)

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Audio Options", 0, yCoord)

		yCoord = yCoord - 30
		controls.checkBoxes.overcapAudio = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_CB3_OC_Sound", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapAudio
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText("Play audio cue when you will overcap Fury")
		f.tooltip = "Play an audio cue when your hardcast spell will overcap Fury."
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
		controls.dropDown.overcapAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_DemonHunter_Havoc_overcapAudio", parent)
		controls.dropDown.overcapAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
		LibDD:UIDropDownMenu_SetWidth(controls.dropDown.overcapAudio, oUi.dropdownWidth)
		LibDD:UIDropDownMenu_SetText(controls.dropDown.overcapAudio, spec.audio.overcap.soundName)
		LibDD:UIDropDownMenu_JustifyText(controls.dropDown.overcapAudio, "LEFT")

		-- Create and bind the initialization function to the dropdown menu
		LibDD:UIDropDownMenu_Initialize(controls.dropDown.overcapAudio, function(self, level, menuList)
			local entries = 25
			local info = LibDD:UIDropDownMenu_CreateInfo()
			local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
			local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
			if (level or 1) == 1 or menuList == nil then
				local menus = math.ceil(TRB.Functions.TableLength(sounds) / entries)
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

		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls
	end

	local function HavocConstructBarTextDisplayPanel(parent, cache)
		if parent == nil then
			return
		end

		local spec = TRB.Data.settings.demonhunter.havoc

		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local controls = interfaceSettingsFrame.controls.havoc
		local yCoord = 5
		local f = nil
		local namePrefix = "DemonHunter_Havoc"

		controls.buttons.exportButton_DemonHunter_Havoc_BarText = TRB.UiFunctions:BuildButton(parent, "Export Bar Text", 325, yCoord-5, 225, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_BarText:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (Bar Text).", 12, 1, false, false, false, true, false)
		end)

		controls.textCustomSection = TRB.UiFunctions:BuildSectionHeader(parent, "Bar Display Text Customization", 0, yCoord)

		yCoord = yCoord - 30
		controls.labels.leftText = TRB.UiFunctions:BuildLabel(parent, "Left Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.left = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Left", spec.displayText.left.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.left
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.left.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		controls.labels.middleText = TRB.UiFunctions:BuildLabel(parent, "Middle Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

		controls.textbox.middle = TRB.UiFunctions:CreateBarTextInputPanel(parent, namePrefix .. "_Middle", spec.displayText.middle.text,
														430, 60, oUi.xCoord+95, yCoord)
		f = controls.textbox.middle
		f:SetScript("OnTextChanged", function(self, input)
			spec.displayText.middle.text = self:GetText()
			TRB.Data.barTextCache = {}
			TRB.Functions.IsTtdActive(spec)
		end)

		yCoord = yCoord - 70
		controls.labels.rightText = TRB.UiFunctions:BuildLabel(parent, "Right Text", oUi.xCoord, yCoord, 90, 20, nil, "RIGHT")

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

	local function HavocConstructOptionsPanel(cache)
				
		local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
		local parent = interfaceSettingsFrame.panel
		local controls = interfaceSettingsFrame.controls.havoc or {}
		local yCoord = 0
		local f = nil

		controls.colors = {}
		controls.labels = {}
		controls.textbox = {}
		controls.checkBoxes = {}
		controls.dropDown = {}

		interfaceSettingsFrame.havocDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_DemonHunter_Havoc", UIParent)
		interfaceSettingsFrame.havocDisplayPanel.name = "Havoc Demon Hunter"
---@diagnostic disable-next-line: undefined-field
		interfaceSettingsFrame.havocDisplayPanel.parent = parent.name
		local category, layout = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory, interfaceSettingsFrame.havocDisplayPanel, "Havoc Demon Hunter")
		
		parent = interfaceSettingsFrame.havocDisplayPanel

		controls.buttons = controls.buttons or {}

		controls.textSection = TRB.UiFunctions:BuildSectionHeader(parent, "Havoc Demon Hunter", 0, yCoord-5)
	
		controls.checkBoxes.havocDemonHunterEnabled = CreateFrame("CheckButton", "TwintopResourceBar_DemonHunter_Havoc_havocDemonHunterEnabled", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.havocDemonHunterEnabled
		f:SetPoint("TOPLEFT", 320, yCoord-10)
		getglobal(f:GetName() .. 'Text'):SetText("Enabled")
		f.tooltip = "Is Twintop's Resource Bar enabled for the Havoc Demon Hunter specialization? If unchecked, the bar will not function (including the population of global variables!)."
		f:SetChecked(TRB.Data.settings.core.enabled.demonhunter.havoc)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.enabled.demonhunter.havoc = self:GetChecked()
			TRB.Functions.EventRegistration()
			TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)
		end)

		TRB.UiFunctions:ToggleCheckboxOnOff(controls.checkBoxes.havocDemonHunterEnabled, TRB.Data.settings.core.enabled.demonhunter.havoc, true)

		controls.buttons.importButton = TRB.UiFunctions:BuildButton(parent, "Import", 415, yCoord-10, 90, 20)
		controls.buttons.importButton:SetFrameLevel(10000)
		controls.buttons.importButton:SetScript("OnClick", function(self, ...)
			StaticPopup_Show("TwintopResourceBar_Import")
		end)

		controls.buttons.exportButton_DemonHunter_Havoc_All = TRB.UiFunctions:BuildButton(parent, "Export Specialization", 510, yCoord-10, 150, 20)
		controls.buttons.exportButton_DemonHunter_Havoc_All:SetScript("OnClick", function(self, ...)
			TRB.Functions.ExportPopup("Copy the string below to share your Twintop's Resource Bar configuration for Havoc Demon Hunter (All).", 12, 1, true, true, true, true, false)
		end)

		yCoord = yCoord - 52

		local tabs = {}
		local tabsheets = {}

		tabs[1] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab2", "Bar Display", 1, parent, 85)
		tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
		tabs[2] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab3", "Font & Text", 2, parent, 85, tabs[1])
		tabs[3] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab4", "Audio & Tracking", 3, parent, 120, tabs[2])
		tabs[4] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab5", "Bar Text", 4, parent, 60, tabs[3])
		tabs[5] = TRB.UiFunctions:CreateTab("TwintopResourceBar_Options_DemonHunter_Havoc_Tab1", "Reset Defaults", 5, parent, 100, tabs[4])

		yCoord = yCoord - 15

		for i = 1, 5 do
			PanelTemplates_TabResize(tabs[i], 0)
			PanelTemplates_DeselectTab(tabs[i])
			tabs[i].Text:SetPoint("TOP", 0, 0)
			tabsheets[i] = TRB.UiFunctions:CreateTabFrameContainer("TwintopResourceBar_DemonHunter_Havoc_LayoutPanel" .. i, parent)
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
		TRB.Frames.interfaceSettingsFrameContainer.controls.havoc = controls

		HavocConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
		HavocConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
		HavocConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
		HavocConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
		HavocConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
	end

	local function ConstructOptionsPanel(specCache)
		TRB.Options:ConstructOptionsPanel()
		HavocConstructOptionsPanel(specCache.havoc)
	end
	TRB.Options.DemonHunter.ConstructOptionsPanel = ConstructOptionsPanel
end