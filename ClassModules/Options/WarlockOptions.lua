local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on a Warlock!
	return
end

local L = TRB.Localization
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local oUi = TRB.Data.constants.optionsUi

local barContainerFrame = TRB.Frames.barContainerFrame
local castingFrame = TRB.Frames.castingFrame

local passiveFrame = TRB.Frames.passiveFrame

TRB.Options.Warlock = {}
TRB.Options.Warlock.Affliction = {}
TRB.Frames.interfaceSettingsFrameContainer.controls.affliction = {}

--Affliction
local function AfflictionLoadDefaultBarTextSimpleSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=16,
			color = "FFFFFFFF",
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
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid=TRB.Functions.String:Guid(),
			text="",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=16,
			color = "FFFFFFFF",
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
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid=TRB.Functions.String:Guid(),
			text="$soulShards/$soulShardsMax",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=16,
			color = "FFFFFFFF",
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
	return textSettings
end
TRB.Options.Warlock.AfflictionLoadDefaultBarTextSimpleSettings = AfflictionLoadDefaultBarTextSimpleSettings

local function AfflictionLoadDefaultBarTextAdvancedSettings()
	---@type TRB.Classes.DisplayTextEntry[]
	local textSettings = {
		{
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionLeft"],
			guid=TRB.Functions.String:Guid(),
			text="#agony $agonyCount   #haunt $hauntCount||n#corruption $corruptionCount   {$ttd}[TTD: $ttd]",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=13,
			color = "FFFFFFFF",
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
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionMiddle"],
			guid=TRB.Functions.String:Guid(),
			text="{$tormentedCrescendoTime}[#tormentedCrescendo $tormentedCrescendoTime #tormentedCrescendo] ||n{$nightfallTime}[#nightfall $nightfallTime #nightfall] ",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "CENTER",
			fontJustifyHorizontalName = L["PositionCenter"],
			fontSize=13,
			color = "FFFFFFFF",
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
			useDefaultFontColor = false,
			useDefaultFontFace = false,
			useDefaultFontSize = false,
			enabled = true,
			name = L["PositionRight"],
			guid=TRB.Functions.String:Guid(),
			text="$soulShards/$soulShardsMax",
			fontFace="Fonts\\FRIZQT__.TTF",
			fontFaceName="Friz Quadrata TT",
			fontJustifyHorizontal = "RIGHT",
			fontJustifyHorizontalName = L["PositionRight"],
			fontSize=16,
			color = "FFFFFFFF",
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
	return textSettings
end

local function AfflictionLoadDefaultSettings(includeBarText)
	local settings = {
		precision = {
			secondary = 2,
			resource = 0
		},
		thresholds = {
			width = 2,
			overlapBorder=true,
			outOfRange=true,
			icons = {
				showCooldown=true,
				border=2,
				relativeTo = "BOTTOM",
				relativeToName = L["PositionBelow"],
				enabled=true,
				desaturated=true,
				xPos=0,
				yPos=12,
				width=24,
				height=24
			},
		},
		displayBar = {
			alwaysShow=false,
			notZeroShow=true,
			neverShow=false,
			dragonriding=true
		},
		bar = {
			width=555,
			height=16,
			xPos=0,
			yPos=-215,
			border=2,
			dragAndDrop=false,
			pinToPersonalResourceDisplay=false
		},
		comboPoints = {
			width=25,
			height=16,
			xPos=0,
			yPos=4,
			border=2,
			spacing=14,
			relativeTo="TOP",
			relativeToName = L["PositionAboveMiddle"],
			fullWidth=true,
		},
		passiveGeneration = {
		},
		colors={
			text = {
				current = {
					color = "FF4D4DFF"
				},
				casting = {
					color = "FFFFFFFF"
				},
				passive = {
					color = "FF8080FF"
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
			bar={
				border="FF000099",
				background="66000000",
				base="FF0000FF",
				spending="FFFFFFFF",
				passive="FF8080FF",
				nightfall = {
					color = "FF00D9FF",
					enabled = true,
				},
				tormentedCrescendo = {
					color = "FF00FF00",
					enabled = true,
				},
				shadowEmbraceNotMax = {
					color = "FFFF0000",
					enabled = true
				},
				showPassive=true,
				showCasting=true
			},
			comboPoints = {
				border="FF4749B5",
				background="66000000",
				base="FF8788EE",
				penultimate="FFFF9900",
				final="FFFF0000",
				sameColor=false,
				consistentUnfilledColor = false,
				succulentSoul = {
					color = "FF31001B",
					enabled = true,
				},
				malignOmen = {
					color = "FF00C9B4",
					enabled = true,
				},
			},
			threshold={
				unusable="FFFF0000",
				over="FF00FF00",
				special="FF8080FF",
				outOfRange="FF440000"
			}
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
		audio={
			tormentedCrescendo={
				name = L["WarlockAfflictionAudioTormentedCrescendo1"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			tormentedCrescendo2={
				name = L["WarlockAfflictionAudioTormentedCrescendo2"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\AirHorn.ogg",
				soundName = L["LSMSoundAirHorn"]
			},
			nightfall={
				name = L["WarlockAfflictionAudioNightfall"],
				enabled=false,
				sound="Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
				soundName = L["LSMSoundBoxingArenaGong"]
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
			textureLock=true,
			comboPointsBackground="Interface\\Tooltips\\UI-Tooltip-Background",
			comboPointsBackgroundName="Blizzard Tooltip",
			comboPointsBorder="Interface\\Buttons\\WHITE8X8",
			comboPointsBorderName="1 Pixel",
			comboPointsBar="Interface\\TargetingFrame\\UI-StatusBar",
			comboPointsBarName="Blizzard",
		}
	}

	if includeBarText then
		settings.displayText.barText = AfflictionLoadDefaultBarTextSimpleSettings()
	end

	return settings
end

local function LoadDefaultSettings(includeBarText)
	local settings = TRB.Functions.Settings:LoadDefaultSettings()

	settings.warlock.affliction = AfflictionLoadDefaultSettings(includeBarText)
	return settings
end
TRB.Options.Warlock.LoadDefaultSettings = LoadDefaultSettings

--[[

Affliction Option Menus

]]

local function AfflictionConstructResetDefaultsPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local controls = TRB.Frames.interfaceSettingsFrameContainer.controls.affliction
	local yCoord = 5

	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_Reset"] = {
		text = string.format(L["ResetBarDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			TRB.Data.settings.warlock.affliction = AfflictionLoadDefaultSettings(true)
			C_UI.Reload()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetBarTextSimple"] = {
		text = string.format(L["ResetBarTextSimpleDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AfflictionLoadDefaultBarTextSimpleSettings()
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetBarTextAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedFullDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AfflictionLoadDefaultBarTextAdvancedSettings()
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	--[[
	StaticPopupDialogs["TwintopResourceBar_Warlock_Affliction_ResetBarTextNarrowAdvanced"] = {
		text = string.format(L["ResetBarTextAdvancedNarrowDialog"], L["WarlockAfflictionFull"]),
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			spec.displayText.barText = AfflictionLoadDefaultBarTextNarrowAdvancedSettings()
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	]]

	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarToDefaultsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetToDefaultsHeader"], oUi.xCoord, yCoord, 150, 30)
	controls.resetButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_Reset")
	end)

	yCoord = yCoord - 40
	controls.textCustomSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["ResetResourceBarTextHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.resetButton1 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextSimple"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton1:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetBarTextSimple")
	end)
	yCoord = yCoord - 40

	--[[
	controls.resetButton2 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedNarrow"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton2:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetBarTextNarrowAdvanced")
	end)
	]]

	controls.resetButton3 = TRB.Functions.OptionsUi:BuildButton(parent, L["ResetBarTextAdvancedFull"], oUi.xCoord, yCoord, 250, 30)
	controls.resetButton3:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Warlock_Affliction_ResetBarTextAdvanced")
	end)

	TRB.Frames.interfaceSettingsFrameContainer.controls.affliction = controls
end

local function AfflictionConstructBarColorsAndBehaviorPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5
	local f = nil

	controls.buttons.exportButton_Warlock_Affliction_BarDisplay = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarDisplay"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_BarDisplay:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarDisplay"] .. ".", 9, 1, true, false, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, 9, 1, yCoord)

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"], L["ResourceSoulShards"])

	yCoord = yCoord - 60
	yCoord = TRB.Functions.OptionsUi:GenerateBarTexturesOptions(parent, controls, spec, 9, 1, yCoord, true, L["ResourceSoulShards"])

	yCoord = yCoord - 30
	yCoord = TRB.Functions.OptionsUi:GenerateBarDisplayOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"], "notFull", false)

	yCoord = yCoord - 90
	yCoord = TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"])

	--[[
	yCoord = yCoord - 30
	controls.checkBoxes.showCastingBar = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Checkbox_ShowCastingBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showCastingBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowCastingBarCheckbox"])
	f.tooltip = L["ShowCastingBarCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.showCasting)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.showCasting = self:GetChecked()
	end)

	controls.colors.spending = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCasting"], spec.colors.bar.spending, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.spending
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "spending", "bar", castingFrame, 2)
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.showPassiveBar = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Checkbox_ShowPassiveBar", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showPassiveBar
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["ShowPassiveBarCheckbox"])
	f.tooltip = L["ShowPassiveBarCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.showPassive)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.showPassive = self:GetChecked()
	end)

	controls.colors.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerPassive"], spec.colors.bar.passive, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "passive", "bar", passiveFrame, 2)
	end)]]

	yCoord = yCoord - 30
	controls.checkBoxes.shadowEmbraceNotMax = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Border_Option_shadowEmbraceNotMax", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.shadowEmbraceNotMax
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionCheckboxShadowEmbraceNotMax"])
	f.tooltip = L["WarlockAfflictionCheckboxShadowEmbraceNotMaxTooltip"]
	f:SetChecked(spec.colors.bar.shadowEmbraceNotMax.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.shadowEmbraceNotMax.enabled = self:GetChecked()
	end)

	controls.colors.shadowEmbraceNotMax = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockAfflictionColorPickerShadowEmbraceNotMax"], spec.colors.bar.shadowEmbraceNotMax.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.shadowEmbraceNotMax
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "shadowEmbraceNotMax")
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.bar, controls.colors, "background", "backdrop", barContainerFrame, 2)
	end)

	yCoord = yCoord - 40
	yCoord = TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, 9, 1, yCoord, L["ResourceMana"], false)
	
	yCoord = yCoord - 30
	controls.checkBoxes.nightfall = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Border_Option_nightfallProc", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.nightfall
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionCheckboxNightfall"])
	f.tooltip = L["WarlockAfflictionCheckboxNightfallTooltip"]
	f:SetChecked(spec.colors.bar.nightfall.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.nightfall.enabled = self:GetChecked()
	end)

	controls.colors.nightfall = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockAfflictionColorPickerNightfall"], spec.colors.bar.nightfall.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.nightfall
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "nightfall")
	end)

	----
	yCoord = yCoord - 30
	controls.checkBoxes.tormentedCrescendo = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Border_Option_tormentedCrescendoProc", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.tormentedCrescendo
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionCheckboxTormentedCrescendo"])
	f.tooltip = L["WarlockAfflictionCheckboxTormentedCrescendoTooltip"]
	f:SetChecked(spec.colors.bar.tormentedCrescendo.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.tormentedCrescendo.enabled = self:GetChecked()
	end)

	controls.colors.tormentedCrescendo = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockAfflictionColorPickerTormentedCrescendo"], spec.colors.bar.tormentedCrescendo.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.tormentedCrescendo
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "tormentedCrescendo")
	end)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsColorsHeader"], oUi.xCoord, yCoord)
	controls.colors.comboPoints = {}

	yCoord = yCoord - 30
	controls.colors.comboPoints.base = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ResourceSoulShards"], spec.colors.comboPoints.base, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.base
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "base")
	end)

	yCoord = yCoord - 30
	controls.colors.comboPoints.penultimate = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerPenultimate"], spec.colors.comboPoints.penultimate, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.penultimate
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "penultimate")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.sameColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_comboPointsSameColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.sameColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxUseHighestForAll"])
	f.tooltip = L["WarlockSoulShardsCheckboxUseHighestForAllTooltip"]
	f:SetChecked(spec.comboPoints.sameColor)
	f:SetScript("OnClick", function(self, ...)
		spec.comboPoints.sameColor = self:GetChecked()
	end)

	controls.colors.comboPoints.final = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerFinal"], spec.colors.comboPoints.final, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.final
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "final")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.malignOmen = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Border_Option_malignOmen", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.malignOmen
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionCheckboxMalignOmen"])
	f.tooltip = L["WarlockAfflictionCheckboxMalignOmenTooltip"]
	f:SetChecked(spec.colors.comboPoints.malignOmen.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.malignOmen.enabled = self:GetChecked()
	end)

	controls.colors.malignOmen = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockAfflictionColorPickerMalignOmen"], spec.colors.comboPoints.malignOmen.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.malignOmen
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "malignOmen")
	end)
	
	yCoord = yCoord - 40
	controls.comboPointColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockSoulShardsBorderColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.comboPoints.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerSoulShardsBorderHeader"], spec.colors.comboPoints.border, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "border")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.succulentSoul = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Border_Option_succulentSoul", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.succulentSoul
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionCheckboxSucculentSoul"])
	f.tooltip = L["WarlockAfflictionCheckboxSucculentSoulTooltip"]
	f:SetChecked(spec.colors.comboPoints.succulentSoul.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.succulentSoul.enabled = self:GetChecked()
	end)

	controls.colors.succulentSoul = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockAfflictionColorPickerSucculentSoul"], spec.colors.comboPoints.succulentSoul.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.succulentSoul
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "succulentSoul")
	end)

	yCoord = yCoord - 30
	controls.checkBoxes.consistentUnfilledColorComboPoint = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_comboPointsConsistentBackgroundColor", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.consistentUnfilledColorComboPoint
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockSoulShardsCheckboxAlwaysDefaultBackground"])
	f.tooltip = L["WarlockSoulShardsCheckboxAlwaysDefaultBackgroundTooltip"]
	f:SetChecked(spec.colors.comboPoints.consistentUnfilledColor)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.consistentUnfilledColor = self:GetChecked()
	end)

	controls.colors.comboPoints.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockSoulShardsColorPickerBackground"], spec.colors.comboPoints.background, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.comboPoints.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown_OLD(button, spec.colors.comboPoints, controls.colors.comboPoints, "background")
	end)
end

local function AfflictionConstructFontAndTextPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warlock_Affliction_FontAndText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportFontText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_FontAndText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixFontText"] .. ".", 9, 1, false, true, false, false, false)
	end)

	yCoord = TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, 9, 1, yCoord)

	yCoord = yCoord - 40
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockManaTextColorsHeader"], oUi.xCoord, yCoord)

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, 9, 1, yCoord)
	
	yCoord = yCoord - 30
	controls.colors.text.current = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCurrentMana"], spec.colors.text.current.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.current
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "current")
	end)

	controls.colors.text.casting = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerCastingMana"], spec.colors.text.casting.color, 300, 25, oUi.xCoord2, yCoord)
	f = controls.colors.text.casting
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "casting")
	end)

	yCoord = yCoord - 30
	controls.colors.text.passive = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["WarlockColorPickerPassiveMana"], spec.colors.text.passive.color, 300, 25, oUi.xCoord, yCoord)
	f = controls.colors.text.passive
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.text, controls.colors.text, "passive")
	end)
	
	local dotVariables = "$agonyCount/$agonyStacks/$agonyTime, $corruptionCount/$corruptionTime, $hauntCount/$hauntTime, $unstableAffliction"
	yCoord = TRB.Functions.OptionsUi:GenerateDefaultDotOptions(parent, controls, spec, 9, 1, yCoord, L["DotChangeColorCheckbox"], string.format(L["DotChangeColorCheckboxTooltip"], dotVariables))

	yCoord = TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, 9, 1, yCoord)
end

local function AfflictionConstructAudioAndTrackingPanel(parent)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5
	local f = nil

	local title = ""

	controls.buttons.exportButton_Warlock_Affliction_AudioAndTracking = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportAudioTracking"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_AudioAndTracking:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAudioTracking"] .. ".", 9, 1, false, false, true, false, false)
	end)

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AudioOptionsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.checkBoxes.nightfall = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_Nightfall_CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.nightfall
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionAudioCheckboxNightfall"])
	f.tooltip = L["WarlockAfflictionAudioCheckboxNightfallTooltip"]
	f:SetChecked(spec.audio.nightfall.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.nightfall.enabled = self:GetChecked()

		if spec.audio.nightfall.enabled then
			PlaySoundFile(spec.audio.nightfall.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.nightfallAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warlock_Affliction_Nightfall_Audio", parent)
	controls.dropDown.nightfallAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.nightfallAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.nightfallAudio, spec.audio.nightfall.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.nightfallAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.nightfallAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.nightfall.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.nightfallAudio:SetValue(newValue, newName)
		spec.audio.nightfall.sound = newValue
		spec.audio.nightfall.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.nightfallAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.nightfall.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.tormentedCrescendo = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_TormentedCrescendoCB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.tormentedCrescendo
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionAudioCheckboxTormentedCrescendo1"])
	f.tooltip = L["WarlockAfflictionAudioCheckboxTormentedCrescendo1Tooltip"]
	f:SetChecked(spec.audio.tormentedCrescendo.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.tormentedCrescendo.enabled = self:GetChecked()

		if spec.audio.tormentedCrescendo.enabled then
			PlaySoundFile(spec.audio.tormentedCrescendo.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.tormentedCrescendoAudio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warlock_Affliction_TormentedCrescendoAudio", parent)
	controls.dropDown.tormentedCrescendoAudio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.tormentedCrescendoAudio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.tormentedCrescendoAudio, spec.audio.tormentedCrescendo.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.tormentedCrescendoAudio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.tormentedCrescendoAudio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.tormentedCrescendo.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.tormentedCrescendoAudio:SetValue(newValue, newName)
		spec.audio.tormentedCrescendo.sound = newValue
		spec.audio.tormentedCrescendo.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.tormentedCrescendoAudio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.tormentedCrescendo.sound, TRB.Data.settings.core.audio.channel.channel)
	end


	yCoord = yCoord - 60
	controls.checkBoxes.tormentedCrescendo2 = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_TormentedCrescendo2CB", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.tormentedCrescendo2
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["WarlockAfflictionAudioCheckboxTormentedCrescendo2"])
	f.tooltip = L["WarlockAfflictionAudioCheckboxTormentedCrescendo2Tooltip"]
	f:SetChecked(spec.audio.tormentedCrescendo2.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio.tormentedCrescendo2.enabled = self:GetChecked()

		if spec.audio.tormentedCrescendo2.enabled then
			PlaySoundFile(spec.audio.tormentedCrescendo2.sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)

	-- Create the dropdown, and configure its appearance
	controls.dropDown.tormentedCrescendo2Audio = LibDD:Create_UIDropDownMenu("TwintopResourceBar_Warlock_Affliction_TormentedCrescendoAudio", parent)
	controls.dropDown.tormentedCrescendo2Audio:SetPoint("TOPLEFT", oUi.xCoord, yCoord-20)
	LibDD:UIDropDownMenu_SetWidth(controls.dropDown.tormentedCrescendo2Audio, oUi.sliderWidth)
	LibDD:UIDropDownMenu_SetText(controls.dropDown.tormentedCrescendo2Audio, spec.audio.tormentedCrescendo2.soundName)
	LibDD:UIDropDownMenu_JustifyText(controls.dropDown.tormentedCrescendo2Audio, "LEFT")

	-- Create and bind the initialization function to the dropdown menu
	LibDD:UIDropDownMenu_Initialize(controls.dropDown.tormentedCrescendo2Audio, function(self, level, menuList)
		local entries = 25
		local info = LibDD:UIDropDownMenu_CreateInfo()
		local sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		local soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")
		if (level or 1) == 1 or menuList == nil then
			local menus = math.ceil(TRB.Functions.Table:Length(sounds) / entries)
			for i=0, menus-1 do
				info.hasArrow = true
				info.notCheckable = true
				info.text = string.format(L["DropdownLabelSoundsX"], i+1)
				info.menuList = i
				LibDD:UIDropDownMenu_AddButton(info)
			end
		else
			local start = entries * menuList

			for k, v in pairs(soundsList) do
				if k > start and k <= start + entries then
					info.text = v
					info.value = sounds[v]
					info.checked = sounds[v] == spec.audio.tormentedCrescendo2.sound
					info.func = self.SetValue
					info.arg1 = sounds[v]
					info.arg2 = v
					LibDD:UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end)

	-- Implement the function to change the audio
	function controls.dropDown.tormentedCrescendo2Audio:SetValue(newValue, newName)
		spec.audio.tormentedCrescendo2.sound = newValue
		spec.audio.tormentedCrescendo2.soundName = newName
		LibDD:UIDropDownMenu_SetText(controls.dropDown.tormentedCrescendo2Audio, newName)
		CloseDropDownMenus()
---@diagnostic disable-next-line: redundant-parameter
		PlaySoundFile(spec.audio.tormentedCrescendo2.sound, TRB.Data.settings.core.audio.channel.channel)
	end
end


local function AfflictionConstructBarTextDisplayPanel(parent, cache)
	if parent == nil then
		return
	end

	local spec = TRB.Data.settings.warlock.affliction
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local controls = interfaceSettingsFrame.controls.affliction
	local yCoord = 5

	TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarDisplayTextCustomizationHeader"], oUi.xCoord, yCoord)
	controls.buttons.exportButton_Warlock_Affliction_BarText = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportMessageExportBarText"], 400, yCoord-5, 225, 20)
	controls.buttons.exportButton_Warlock_Affliction_BarText:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixBarText"] .. ".", 9, 1, false, false, false, true, false)
	end)

	yCoord = yCoord - 30
	TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, 9, 1, yCoord, cache)
end

local function AfflictionConstructOptionsPanel(cache)
	
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	local parent = interfaceSettingsFrame.panel
	local controls = interfaceSettingsFrame.controls.warlock or {}
	local yCoord = 0
	local f = nil

	controls.colors = {}
	controls.labels = {}
	controls.textbox = {}
	controls.checkBoxes = {}
	controls.dropDown = {}
	controls.buttons = controls.buttons or {}

	interfaceSettingsFrame.afflictionDisplayPanel = CreateFrame("Frame", "TwintopResourceBar_Options_Warlock_Affliction", UIParent)
	interfaceSettingsFrame.afflictionDisplayPanel.name = L["WarlockAfflictionFull"]
---@diagnostic disable-next-line: undefined-field
	interfaceSettingsFrame.afflictionDisplayPanel.parent = parent.name
	TRB.Details.addonCategory.specs["affliction"], _ = Settings.RegisterCanvasLayoutSubcategory(TRB.Details.addonCategory.main, interfaceSettingsFrame.afflictionDisplayPanel, L["WarlockAfflictionFull"])
	
	parent = interfaceSettingsFrame.afflictionDisplayPanel

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["WarlockAfflictionFull"], oUi.xCoord, yCoord-5)	
	
	controls.checkBoxes.afflictionWarlockEnabled = CreateFrame("CheckButton", "TwintopResourceBar_Warlock_Affliction_afflictionWarlockEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.afflictionWarlockEnabled
	f:SetPoint("TOPLEFT", 320, yCoord-10)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxEnabledQuestion"])
	f.tooltip = string.format(L["IsBarEnabledForSpecTooltip"], L["WarlockAfflictionFull"])
	f:SetChecked(TRB.Data.settings.core.enabled.warlock.affliction)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.enabled.warlock.affliction = self:GetChecked()
		TRB.Functions.Class:EventRegistration()
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.afflictionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.affliction, true)
	end)
	
	TRB.Functions.OptionsUi:ToggleCheckboxOnOff(controls.checkBoxes.afflictionWarlockEnabled, TRB.Data.settings.core.enabled.warlock.affliction, true)

	controls.buttons.importButton = TRB.Functions.OptionsUi:BuildButton(parent, L["Import"], 415, yCoord-10, 90, 20)
	controls.buttons.importButton:SetFrameLevel(10000)
	controls.buttons.importButton:SetScript("OnClick", function(self, ...)
		StaticPopup_Show("TwintopResourceBar_Import")
	end)

	controls.buttons.exportButton_Warlock_Affliction_All = TRB.Functions.OptionsUi:BuildButton(parent, L["ExportSpecialization"], 510, yCoord-10, 150, 20)
	controls.buttons.exportButton_Warlock_Affliction_All:SetScript("OnClick", function(self, ...)
		TRB.Functions.IO:ExportPopup(L["ExportMessagePrefix"] .. " " .. L["WarlockAfflictionFull"] .. " " .. L["ExportMessagePostfixAll"] .. ".", 9, 1, true, true, true, true, false)
	end)

	yCoord = yCoord - 52

	local tabs = {}
	local tabsheets = {}

	tabs[1] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warlock_Affliction_Tab1", L["TabBarDisplay"], 1, parent, 85)
	tabs[1]:SetPoint("TOPLEFT", 15, yCoord)
	tabs[2] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warlock_Affliction_Tab2", L["TabFontText"], 2, parent, 85, tabs[1])
	tabs[3] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warlock_Affliction_Tab3", L["TabAudioTracking"], 3, parent, 120, tabs[2])
	tabs[4] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warlock_Affliction_Tab4", L["TabBarText"], 4, parent, 60, tabs[3])
	tabs[5] = TRB.Functions.OptionsUi:CreateTab("TwintopResourceBar_Options_Warlock_Affliction_Tab5", L["TabResetDefaults"], 5, parent, 100, tabs[4])

	yCoord = yCoord - 15

	for i = 1, 5 do
		PanelTemplates_TabResize(tabs[i], 0)
		PanelTemplates_DeselectTab(tabs[i])
		tabs[i].Text:SetPoint("TOP", 0, 0)
		tabsheets[i] = TRB.Functions.OptionsUi:CreateTabFrameContainer("TwintopResourceBar_Warlock_Affliction_LayoutPanel" .. i, parent)
		tabsheets[i]:Hide()
		tabsheets[i]:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	end

	tabsheets[1]:Show()
	tabsheets[1].selected = true
	tabs[1]:SetNormalFontObject(TRB.Options.fonts.options.tabHighlightSmall)
	parent.tabs = tabs
	parent.tabsheets = tabsheets
	parent.lastTab = tabsheets[1]
	parent.lastTabId = 1

	TRB.Frames.interfaceSettingsFrameContainer = interfaceSettingsFrame
	TRB.Frames.interfaceSettingsFrameContainer.controls.affliction = controls

	AfflictionConstructBarColorsAndBehaviorPanel(tabsheets[1].scrollFrame.scrollChild)
	AfflictionConstructFontAndTextPanel(tabsheets[2].scrollFrame.scrollChild)
	AfflictionConstructAudioAndTrackingPanel(tabsheets[3].scrollFrame.scrollChild)
	AfflictionConstructBarTextDisplayPanel(tabsheets[4].scrollFrame.scrollChild, cache)
	AfflictionConstructResetDefaultsPanel(tabsheets[5].scrollFrame.scrollChild)
end

local function ConstructOptionsPanel(specCache)
	TRB.Options:ConstructOptionsPanel()
	
	AfflictionConstructOptionsPanel(specCache.affliction)
end
TRB.Options.Warlock.ConstructOptionsPanel = ConstructOptionsPanel