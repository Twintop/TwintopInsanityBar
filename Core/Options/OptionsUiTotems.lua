local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Totems = TRB.Functions.OptionsUi.Totems or {}

-- Totems bar options, for one spec or, with nil classId and specId, the Global panel.

---Constructs the Totems bar's options.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
function TRB.Functions.OptionsUi.Totems:ConstructPanel(parent, classId, specId)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec
	if classId == nil then
		spec = TRB.Data.settings.core
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if spec == nil then
		return
	end

	local barDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("totems")
	local barSettings = spec.bars and spec.bars.totems
	local colors = spec.colors and spec.colors.bars and spec.colors.bars.totems
	if barDef == nil or barSettings == nil or colors == nil then
		return
	end

	local controlsKey = (classId == nil) and "core" or (classNameLower .. "_" .. specName)
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	interfaceSettingsFrame.controls[controlsKey] = interfaceSettingsFrame.controls[controlsKey] or {}
	local controls = interfaceSettingsFrame.controls[controlsKey]
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}
	local namePrefix = "TwintopResourceBar_" .. controlsKey .. "_totems"

	-- Global-panel edits land on the core table; the active spec's merged cache only picks them up on a re-fill.
	local function ApplyLayoutChange()
		local character = TRB.Data.character
		if classId == nil and character ~= nil and character.compositeKey ~= nil and TRB.Data.specCache[character.compositeKey] ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(character.className, character.specName)
		end
		local active = character ~= nil and TRB.Data.specCache[character.compositeKey]
		if TRB.Frames.barGroups ~= nil and active then
			TRB.Functions.Bar:ApplyBarGroupsLayout(active.settings, TRB.Frames.barGroups)
		end
	end

	local yCoord = 5

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barDef, barDef.displayName, "totemsDimensions")
	yCoord = yCoord - 60

	yCoord = TRB.Functions.OptionsUi.Layout:GenerateBarIconOptions(parent, controls, spec, classId, specId, yCoord, barDef)
	yCoord = yCoord - 20

	-- Where slots are elements the bar always shows all four.
	if not TRB.Flavor.totemElements then
		controls.totemsShowAllSlots = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, namePrefix .. "_showAllSlots", L["TotemsShowAllSlots"], L["TotemsShowAllSlotsTooltip"], yCoord,
			function() return barSettings.showAllSlots end,
			function(checked)
				barSettings.showAllSlots = checked
				ApplyLayoutChange()
			end)
		yCoord = yCoord - 30
	end
	-- The icon and Show all totem slots live in the bar's settings table, so they follow the Dimensions box.
	TRB.Functions.OptionsUi.GlobalSettings:AttachLinkedUseGlobalCover(controls.checkBoxes.useGlobalTotemsDimensions, controls.totemsDimensionsSection, controls.totemsIconSection, yCoord)
	yCoord = yCoord - 10

	yCoord = TRB.Functions.OptionsUi.CustomBarColors:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barDef, function(colorParent, colorYCoord)
		local ending = colors.ending
		TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(colorParent, namePrefix .. "_endingEnabled", L["TotemsEndingEnabled"], L["TotemsEndingEnabledTooltip"], colorYCoord,
			function() return ending.enabled end,
			function(checked)
				ending.enabled = checked
				controls.totemsEndingWindow:SetEnabled(checked, L["TotemsEndingDisabledReason"])
			end)
		TRB.Functions.OptionsUi.ColorPickers:BuildColorRow(colorParent, controls.colors, colors, "ending", L["TotemsEndingColor"], colorYCoord, classId, specId)
		colorYCoord = colorYCoord - 40
		controls.totemsEndingWindow = TRB.Functions.OptionsUi.Primitives:BuildRemainingWindowControls(colorParent, namePrefix .. "_endingWindow", {
			gcdRadio = L["TotemsEndingModeGCDs"],
			gcdSlider = L["TotemsEndingGCDs"],
			timeRadio = L["TotemsEndingModeTime"],
			timeSlider = L["TotemsEndingTime"],
		})
		controls.totemsEndingWindow:Bind(ending, function() end)
		colorYCoord = controls.totemsEndingWindow:SetPosition(colorYCoord)
		controls.totemsEndingWindow:SetShown(true)
		controls.totemsEndingWindow:SetEnabled(ending.enabled == true, L["TotemsEndingDisabledReason"])
		return colorYCoord - 60
	end, "totemsColors")
	yCoord = yCoord - 30

	return yCoord
end
